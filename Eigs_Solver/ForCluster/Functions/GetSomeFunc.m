function Data = GetSomeFunc(Data,Ra,Pr,Ny,Nx,G,WE,WO,getEigv,thres,Search)
% constants
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(Nx)];
PrS = PrtoPrS(Pr);
RaS = RatoRaS(Ra);
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
if WO
    % Solving odd problem
    M = MakeMatrixForOddProblem2_nxny(Nx,Ny,G, PsiE, ThetaE, Ra, Pr);
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
        Data.(AR).(type).(PrS).(RaS).sigmaodd = sigmaodd;
        Data.(AR).(type).(PrS).(RaS).Eigv = Eigvnotconj;
        Data.(AR).(type).(PrS).(RaS).Eigvconj = Eigvconj;
    else
        sigmaodd = eig(M);
        sigmaodd(real(sigmaodd) < -200) = [];
        clear M
        Data.(AR).(type).(PrS).(RaS).sigmaodd = sigmaodd;
    end
end
if WE
    M = MakeMatrixForEvenProblem2_nxny(Nx,Ny,G, PsiE, ThetaE, Ra, Pr);
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
        Data.(AR).(type).(PrS).(RaS).sigmaeven = sigmaeven;
        Data.(AR).(type).(PrS).(RaS).Eigve = Eigvnotconje;
        Data.(AR).(type).(PrS).(RaS).Eigvconje = Eigvconje;
    else
        sigmaeven = eig(M);
        sigmaeven(real(sigmaeven) < -200) = [];
        clear M
        Data.(AR).(type).(PrS).(RaS).sigmaeven = sigmaeven;
    end
    
end
end
