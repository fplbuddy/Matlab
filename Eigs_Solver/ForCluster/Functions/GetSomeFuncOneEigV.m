function Data = GetSomeFuncOneEigV(Data,Ra,Pr,Ny,Nx,G,thres,Search,RaO,PrO,NxO)
% Ra0 etc are where we take the eig from
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
% Solving odd problem
RaOS = RatoRaS(RaO);
PrOS = PrtoPrS(PrO);
typeO = ['OneOne' num2str(NxO)];
EigV = Data.(AR).(typeO).(PrOS).(RaOS).Eigv;
EigV = ExpandEigenFunc2(EigV,NxO, Nx);
sigmaoddguess = Data.(AR).(typeO).(PrOS).(RaOS).sigmaodd;
[~,I] = max(real(sigmaoddguess));
sigmaoddguess = sigmaoddguess(I);
M = MakeMatrixForOddProblem2_nxny(Nx,Ny,G, PsiE, ThetaE, Ra, Pr);
[EigV,sigmaodd] = eigs(M,1,sigmaoddguess,'StartVector', EigV,'Tolerance',1e-10);
Data.(AR).(type).(PrS).(RaS).sigmaodd = sigmaodd;
Data.(AR).(type).(PrS).(RaS).Eigv = EigV;
end
