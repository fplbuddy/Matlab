function Data = GetSomeFunc_Quasi(Data,Ra,Pr,Ny,Nx,G,Gy,WE,WO,getEigv,thres,Search)
% constants
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(Nx)];
PrS = PrtoPrS(Pr);
RaS = RatoRaS(Ra);
GyS = ['Gy_' replace(num2str(Gy),'.','_')];
try ngot = not(isfield(Data.(AR).(type).(PrS), RaS)); catch, ngot = 1; end
if ngot % If we need to do NR or not
    [PsiE, ThetaE] = GetIC(Ra, Pr, Data, AR, type,Search);
    [PsiE, ThetaE, dxmin] = NR2_nxny(PsiE, ThetaE, Nx,Ny, G, Ra, Pr, thres);%, NL);
    Data.(AR).(type).(PrS).(RaS).Ra = Ra;
    Data.(AR).(type).(PrS).(RaS).Pr = Pr;
    Data.(AR).(type).(PrS).(RaS).dxmin = dxmin;
    Data.(AR).(type).(PrS).(RaS).PsiE = PsiE;
    Data.(AR).(type).(PrS).(RaS).ThetaE = ThetaE;
else
    ThetaE = Data.(AR).(type).(PrS).(RaS).ThetaE;
    PsiE = Data.(AR).(type).(PrS).(RaS).PsiE;
    % fix if too long
    if length(ThetaE) == Nx*Ny/4
        [Rem,~,~,~] = GetRemKeep_nxny(Nx,Ny,1);
        ThetaE(Rem) = [];
        PsiE(Rem) = [];
        Data.(AR).(type).(PrS).(RaS).ThetaE = ThetaE;
        Data.(AR).(type).(PrS).(RaS).PsiE = PsiE;
    end
end
% Going to try setting PsiE to 0 and only keep zonal modes in ThetaE
PsiE = 0*PsiE;
[~,~,n,~] = GetRemKeep_nxny(Nx,Ny,1);
for i=1:length(n)
    if n ~= 0
        ThetaE(i) = 0;
    end
end
if WO
    % Solving odd problem
    M = MakeMatrixForOddProblem2_nxny_Quasi(Nx,Ny,G, PsiE, ThetaE, Ra, Pr,Gy);
    if getEigv
        [Eigv,sigmaodd] = eig(M);
        clear M
        sigmaodd = diag(sigmaodd);
        [~,indices] = sort(real(sigmaodd),'descend');
        % getting location of most unstable eigenvalue
        Eigvnotconj = Eigv(:,indices(1));
        Eigvconj = Eigv(:,indices(2));
        clear Eigv
        sigmaodd(real(sigmaodd) < -200) = [];
        Data.(AR).(type).(PrS).(RaS).(GyS).sigmaodd = sigmaodd;
        Data.(AR).(type).(PrS).(RaS).(GyS).Eigv = Eigvnotconj;
        Data.(AR).(type).(PrS).(RaS).(GyS).Eigvconj = Eigvconj;
    else
        sigmaodd = eig(M);
        sigmaodd(real(sigmaodd) < -200) = [];
        clear M
        Data.(AR).(type).(PrS).(RaS).(GyS).sigmaodd = sigmaodd;
    end
end
if WE
    M = MakeMatrixForEvenProblem2_nxny_Quasi(Nx,Ny,G, PsiE, ThetaE, Ra, Pr,Gy);
    if getEigv
        [Eigv,sigmaeven] = eig(M);
        clear M
        sigmaeven = diag(sigmaeven);
        [~,indices] = sort(real(sigmaeven),'descend');
        % getting location of most unstable eigenvalue
        Eigvnotconje = Eigv(:,indices(1));
        Eigvconje = Eigv(:,indices(2));
        clear Eigv
        sigmaeven(real(sigmaeven) < -200) = [];
        Data.(AR).(type).(PrS).(RaS).(GyS).sigmaeven = sigmaeven;
        Data.(AR).(type).(PrS).(RaS).(GyS).Eigve = Eigvnotconje;
        Data.(AR).(type).(PrS).(RaS).(GyS).Eigvconje = Eigvconje;
    else
        sigmaeven = eig(M);
        sigmaeven(real(sigmaeven) < -200) = [];
        clear M
        Data.(AR).(type).(PrS).(RaS).(GyS).sigmaeven = sigmaeven;
    end
end
end
