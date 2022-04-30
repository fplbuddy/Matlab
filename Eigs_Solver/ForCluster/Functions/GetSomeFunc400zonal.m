function Data = GetSomeFunc400zonal(Data,Ra,Pr,N,G,thres,GetEigV)
% constants
PrS = PrtoPrS(Pr);
RaS = RatoRaS(Ra);
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(N)];
%[RaC,PrC]  = GetRaSPrSClose(Ra, Pr, Data, AR, type); % need to do this before
try ngot = not(isfield(Data.(AR).(type).(PrS), RaS)); catch, ngot = 1; end
if ngot % If we need to do NR or not
    [PsiE, ThetaE] = GetIC(Ra, Pr, Data, AR, type);
    [PsiE, ThetaE] = CheckSize(PsiE, ThetaE,N);
    [PsiE, ThetaE, dxmin] = NR2(PsiE, ThetaE, N, G, Ra, Pr, thres);%, NL);
    Data.(AR).(type).(PrS).(RaS).Ra = Ra;
    Data.(AR).(type).(PrS).(RaS).Pr = Pr;
    Data.(AR).(type).(PrS).(RaS).dxmin = dxmin;
    Data.(AR).(type).(PrS).(RaS).PsiE = PsiE;
    Data.(AR).(type).(PrS).(RaS).ThetaE = ThetaE;
else
    ThetaE = Data.(AR).(type).(PrS).(RaS).ThetaE;
    PsiE = Data.(AR).(type).(PrS).(RaS).PsiE;
end
% Solving odd problem
%sigmaoddguess = Data.(AR).(type).(PrC).(RaC).sigmaoddZ;
sigmaoddguess = 0 - 1i*5e3;
EigvZ = Data.AR_2.OneOne400.Pr_160000.Ra_1_85e7.Eigv;
M = MakeMatrixForOddProblem2(N,G, PsiE, ThetaE, Ra, Pr);
if GetEigV
    [EigvZ,sigmaoddZ] = eigs(M,1,sigmaoddguess,'StartVector', EigvZ,'Tolerance',1e-10);
    Data.(AR).(type).(PrS).(RaS).EigvZ = EigvZ;
else
    [~,sigmaoddZ] = eigs(M,1,sigmaoddguess,'StartVector', EigvZ,'Tolerance',1e-10);
end
clear M
clear EigvZ
Data.(AR).(type).(PrS).(RaS).sigmaoddZ = sigmaoddZ;
end

