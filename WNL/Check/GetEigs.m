addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/Check/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/Functions')

RaC = 8*pi^4;
RaA = 1e-2;
Ra = RaC + RaA;
Pr = 1e-3;
N = 32;
PrS = PrtoPrSZero(Pr);
RaAS = RaAtoRaAS(RaA);
G = 2;

%% Get IC
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
load(dpath);
PsiE = PrZeroData.N_32.(PrS).(RaAS).PsiE;
ThetaE = PrZeroData.N_32.(PrS).(RaAS).ThetaE;
kappa = sqrt(pi^3/(Ra*Pr));
nu = kappa*Pr;
ThetaE = ThetaE/Pr;
PsiE = PsiE/Pr;
ThetaE(1) = ThetaE(1)+1; % Some pert
[Rem,~,~,~] = GetRemKeep(N,1);
ThetaE(Rem) = [];
PsiE(Rem) = [];

%%

[PsiR, ThetaR, dxmin] = NRWNLcheck(PsiE, ThetaE, N, 2, Ra, Pr,1e-14);

%%
[Rem,~,~,~] = GetRemKeep(N,1);
RaA_list = [1e-4 1e-3 1e-2 6e-2 7e-2 1e-1];
siglist_WNL = [];
siglist_full = [];
for i = 1:length(RaA_list)
    RaA = RaA_list(i);
    Ra = RaC + RaA;
    RaAS = RaAtoRaAS(RaA);
    % Get SS
    PsiE = PrZeroData.N_32.(PrS).(RaAS).PsiE;
    ThetaE = PrZeroData.N_32.(PrS).(RaAS).ThetaE;
    ThetaE = ThetaE/Pr;
    PsiE = PsiE/Pr;
    ThetaE(Rem) = [];
    PsiE(Rem) = [];
    A = ThetaE(1);
    % get sig from full
    M1 = MakeMatrixForOddProblemWNLcheck(N,G, PsiE, ThetaE, Ra, Pr);
    sigma = eig(M1);
    siglist_full = [siglist_full max(real(sigma))];
    % get sig from WNL
    M2 = MakeMatrixEigProb(N,G, A);
    sigma = eig(M2);
    siglist_WNL = [siglist_WNL max(real(sigma))];
end
