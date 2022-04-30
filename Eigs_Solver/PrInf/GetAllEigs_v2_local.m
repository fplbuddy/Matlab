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
N = 152;
G_list = [2.7:0.1:4];
thres = 1e-14;
GetEigv = 0;
Ra_list = [2e4 3e4 6e4 1e5 2e5];
SearchType = "CRa"; % "Ctype", "CRa","CAr"
tic
for i=1:length(G_list)
    G = G_list(i);
    for j = 1:length(Ra_list)
        Ra = Ra_list(j)
        NewData = GetAllEigsFuncInf(NewData,Ra,N,G,thres,GetEigv,SearchType);
    end
end
toc
PrInfData = NewData;
save(spath,'PrInfData');
