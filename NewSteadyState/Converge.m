fpath = '/Users/philipwinchester/Dropbox/Matlab/NewSteadyState/Functions';
addpath(fpath);
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions';
addpath(fpath);
% get data
path = '/Volumes/Samsung_T5/OldData/NewSteadyState.mat';
load(path)
Pr_list = [1e-4];
Nx = 32;
Ny = 32;
thresh = 1e-14;
G_list = [1];
SearchType = "Simple";
rempitch = 1;
prec = 3;
GetEigV = 0;
stab = 1;
lowPrScaling = 0;
res_list = ['N_' num2str(Nx) 'x' num2str(Ny)]; res_list = [convertCharsToStrings(res_list)];
for i=1:length(G_list)
    G = G_list(i)
    for i=1:length(Pr_list)
        Pr = Pr_list(i);
        Data = FunctionGetCloserCrossing(Data,G,Pr,Nx,Ny,thresh,SearchType,rempitch,prec,GetEigV,stab,lowPrScaling,res_list);
    end
end

save(path,'Data')