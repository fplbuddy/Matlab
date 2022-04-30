function [PrZeroData, LimReached] = GetCrossingInitialFunc(PrZeroData,WNLData, N,G,Pr,thres, getEigv, type1,type2,WO,WE,SearchType,lims,prec,res_list)
LimReached = 0;
% constants
res = ['N_' num2str(N)];
RaC = pi^4*(4+G^2)^3/(4*G^4);
GS = GtoGS(G);
PrS = PrtoPrSZero(Pr);
try
% Check if we have crossing
D = GetFullMZero(PrZeroData, GS,PrS, type1,res_list);
sigma_list = D(2,:);
signs = sign(sigma_list);
dsigns = diff(signs);
nc = length(dsigns) - nnz(~dsigns); % number of crossings
catch % if error above, simply set crossings to 0
    nc = 0;
end
if nc == 0 % only do this if we do not have crossing
% calculating RaA_list
if type2 == "WNL"
    Ktwo = (2*pi/G)^2 + pi^2;
    a = (1/pi)*(4*G^3/(Ktwo^2*(4+G^2)^2))^(1/3);
    try
        prefact = WNLData.(GS).calcs.pitch*G/(2*pi*a);
    catch
        GSC = ClosestG(G, WNLData);
        prefact = WNLData.(GSC).calcs.pitch*G/(2*pi*a);
    end
    middle = prefact*Pr^2;
elseif type2 == "Closest"
    % Get closest Pr and its crossing, might be buggy tbf.. if it does not
    % have crossing for example
    try % going to try closest Pr in same GS
    PrS_list = string(fields(PrZeroData.(GS).(res)));
    PrSC = ClosestPrZero(Pr, PrS_list);
    D = GetFullMZero(PrZeroData, GS,PrSC, type1,res_list);
    [~,middle] = GetNextRaA2(D,SearchType,prec);
    catch % If not, will try closest GS in same Pr
        try
        GCS = ClosestG(G, PrZeroData,1);
        D = GetFullMZero(PrZeroData, GCS,PrS, type1,res_list);
        [~,middle] = GetNextRaA2(D,SearchType,prec);
        catch % if does not work, but middle equal to 1e-3
            middle = 1e-3;
        end
    end
end
RaA_list = [middle*0.9 middle*1.1];
for j = 1:length(RaA_list)
    RaA = RaA_list(j)
    RaA = round(RaA,3,'significant');
    Ra = RaA + RaC;
    RaAS = RaAtoRaAS(RaA);
    try ngot = not(isfield(PrZeroData.(GS).(res).(PrS), RaAS)); catch, ngot = 1; end
    if ngot % If we need to do NR or not
        [PsiE, ThetaE] = GetICZero(RaA, Pr, res,GS,PrZeroData);
        [PsiE, ThetaE] = CheckSize(PsiE, ThetaE,N);
        [PsiE, ThetaE, dxmin] = NR2(PsiE, ThetaE, N, G, Ra, Pr, thres);%, NL);
        PrZeroData.(GS).(res).(PrS).(RaAS).RaA = RaA;
        PrZeroData.(GS).(res).(PrS).(RaAS).Pr = Pr;
        PrZeroData.(GS).(res).(PrS).(RaAS).dxmin = dxmin;
        PrZeroData.(GS).(res).(PrS).(RaAS).PsiE = PsiE;
        PrZeroData.(GS).(res).(PrS).(RaAS).ThetaE = ThetaE;
        skip = 0;
    else
        skip = 1;
    end
    if not(skip)
        % Solving odd problem
        if WO
            M = MakeMatrixForOddProblem2(N,G, PsiE, ThetaE, Ra, Pr);
            if getEigv
                [Eigv,sigmaodd] = eig(M);
                clear M
                sigmaodd = diag(sigmaodd);
                [~,indices] = sort(real(sigmaodd),'descend');
                % getting location of most unstable eigenvalue
                Eigvnotconj = Eigv(:,indices(1));
                Eigvconj = Eigv(:,indices(2));
                clear Eigv
                sigmaodd(real(sigmaodd) < -10) = [];
                PrZeroData.(GS).(res).(PrS).(RaAS).sigmaodd = sigmaodd;
                PrZeroData.(GS).(res).(PrS).(RaAS).Eigv = Eigvnotconj;
                PrZeroData.(GS).(res).(PrS).(RaAS).Eigvconj = Eigvconj;
            else
                sigmaodd = eig(M);
                sigmaodd(real(sigmaodd) < -10) = [];
                clear M
                PrZeroData.(GS).(res).(PrS).(RaAS).sigmaodd = sigmaodd;
            end
        end
        % Solving even problem
        if WE
            M = MakeMatrixForEvenProblem2(N,G, PsiE, ThetaE, Ra, Pr);
            if getEigv
                [Eigv,sigmaeven] = eig(M);
                clear M
                sigmaeven = diag(sigmaeven);
                [~,indices] = sort(real(sigmaeven),'descend');
                % getting location of most unstable eigenvalue
                Eigvnotconj = Eigv(:,indices(1));
                Eigvconj = Eigv(:,indices(2));
                clear Eigv
                sigmaeven(real(sigmaeven) < -10) = [];
                PrZeroData.(GS).(res).(PrS).(RaAS).sigmaeven = sigmaeven;
                PrZeroData.(GS).(res).(PrS).(RaAS).Eigv = Eigvnotconj;
                PrZeroData.(GS).(res).(PrS).(RaAS).Eigvconj = Eigvconj;
            else
                sigmaeven = eig(M);
                sigmaeven(real(sigmaeven) < -10) = [];
                clear M
                PrZeroData.(GS).(res).(PrS).(RaAS).sigmaeven = sigmaeven;
            end
        end
    end
end
% Check if we have crossing
D = GetFullMZero(PrZeroData, GS,PrS, type1,res_list);
sigma_list = D(2,:);
RaA_list = D(1,:);
signs = sign(sigma_list);
dsigns = diff(signs);
nc = length(dsigns) - nnz(~dsigns); % number of crossings
while nc == 0 % ie we have no crossings
    signlast = signs(end);
    if signlast == -1 % we need to increase
        RaA = RaA_list(end)*2;
    else % we need to decrease increase
        RaA = RaA_list(1)/2;
    end
    if RaA < lims(1) || RaA > lims(2) % returns if we are outside the bounds we want
        return
        LimReached = 1;
    end
    RaA = round(RaA,3,'significant');
    PrZeroData = GetAllEigsFunc(PrZeroData,N,G,RaA,Pr,thres,getEigv,WO,WE);
    % see if we have crossing now
    D = GetFullMZero(PrZeroData, GS,PrS, type1,res_list);
    sigma_list = D(2,:);
    RaA_list = D(1,:);
    signs = sign(sigma_list);
    dsigns = diff(signs);
    nc = length(dsigns) - nnz(~dsigns); % number of crossings
end
end
end

