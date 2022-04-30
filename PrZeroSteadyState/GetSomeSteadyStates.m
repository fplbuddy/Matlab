load('/Volumes/Samsung_T5/OldData/WNLZero.mat') % Used for ICs
dpath = '/Volumes/Samsung_T5/OldData/PrZeroSS.mat';
load(dpath)
addpath('/Users/philipwinchester/Dropbox/Matlab/NewSteadyState/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/PrZeroSteadyState/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/PrZero/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/Functions')
%%
RaA_list = [1e-4 1e-5 1e-6 1e-7 1e-8 1e-9];
G_list = [1 0.4 0.3];
Nx = 32;
Ny = 32;
type = ['N_'  num2str(Nx) 'x' num2str(Nx)];
thres = 1e-14;
for i=1:length(RaA_list)
    RaA = RaA_list(i);
    RaAS = RaAtoRaAS(RaA);
    for j=1:length(G_list)
        G = G_list(j);
        GS = GtoGS(G);
        RaC = RaCfunc(G);
        Ra = RaC + RaA;
        PsiE = GetICsFromWNL(RaA, WNLZero,G,Nx,Ny);
        [PsiE, dxmin] = NR2PrZss_nxny(PsiE, Nx, Ny,G, Ra,thres);
        M = MakeMatrix_nxnyPrZss(Nx,Ny,G, PsiE, Ra);
        sigmas = eig(M);
        PrZeroSS.(GS).(type).(RaAS).PsiE = PsiE;
        PrZeroSS.(GS).(type).(RaAS).sigmas = sigmas;
    end
end

save(dpath, "PrZeroSS")