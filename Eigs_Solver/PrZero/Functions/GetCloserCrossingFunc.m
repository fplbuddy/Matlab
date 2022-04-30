function PrZeroData = GetCloserCrossingFunc(PrZeroData, N,G,Pr,thres, getEigv, type,WO,WE,SearchType,prec,res_list)
% constants
res = ['N_' num2str(N)];
RaC = pi^4*(4+G^2)^3/(4*G^4);
GS = GtoGS(G);
PrS = PrtoPrSZero(Pr);
D = GetFullMZero(PrZeroData, GS,PrS, type,res_list);
[Done,RaA] = GetNextRaA2(D,SearchType,prec);
while not(Done)
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
    else
        ThetaE = PrZeroData.(GS).(res).(PrS).(RaAS).ThetaE;
        PsiE = PrZeroData.(GS).(res).(PrS).(RaAS).PsiE;
    end
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
    D = GetFullMZero(PrZeroData, GS,PrS,type,res_list);
    [Done,RaA] = GetNextRaA2(D,SearchType,prec);
end

end

