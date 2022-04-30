Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
% Adding the extra functions we want
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrInf/Functions/';
addpath(fpath)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/PrInfData.mat';
spath = dpath; 
load(dpath);
NewData = PrInfData;
clear PrInfData;
% constants
E = 0;
O = 0;
Ny = 324;
G_list = [0.8];
thres = 1e-14;
GetEigv = 0;
Ra_list = [3e7];
SearchType = "Ctype"; % "Ctype", "CRa","CAr"
tic
for i=1:length(G_list)
    G = G_list(i);
    Nx=4*round(Ny*G/4)
    for j = 1:length(Ra_list)
        Ra = Ra_list(j);
        NewData = GetAllEigsFuncInf_nxny(NewData,Ra,Nx,Ny,G,thres,GetEigv,SearchType,O,E);
    end
end
toc
PrInfData = NewData;
save(spath,'PrInfData');
