fpath = '/Users/philipwinchester/Dropbox/Matlab/NewSteadyState/Functions';
addpath(fpath);
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions';
addpath(fpath);
% get data
path = '/Volumes/Samsung_T5/OldData/NewSteadyState.mat';
load(path)
%RaA_list = 1.75e-3;
RaA_list = [1.02e-5];
Pr_list = [3e-5 2e-5 6e-5];
r = 1.02e-3/(1e-4)^2; % approx when hopf happens
%Ra_list = [836];
Nx = 32;
Ny = 32;
thresh = 1e-14;
G_list = [2];
GetEigV = 1;
stab = 1;
lowPrScaling = 0;
for i=1:length(G_list)
    G = G_list(i);
    RaC = pi^4*(4+G^2)^3/(4*G^4);
    %RaA_list = Ra_list - RaC; 
    for i=1:length(Pr_list)
    Pr = Pr_list(i);
    for i=1:length(RaA_list)
        i
        %RaA = RaA_list(i);
        RaA = r*Pr^2;
        RaA = round(RaA, 3, 'significant');
        Data = FunctionSolveSomeParam_nxny(Data,G,RaA,Pr,Nx,Ny,thresh,GetEigV,stab,lowPrScaling);
    end
end
end
save(path,'Data')
