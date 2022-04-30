% Treads = 1;
% maxNumCompThreads(Treads);
% maxNumCompThreads(Treads);
% Adding the extra functions we want
%fpath = '/mi/share/scratch/winchester/Matlab/Eigs/';
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
addpath(fpath)
addpath(fpath2)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
spath = dpath;
load(dpath);
% constants
N = 32;
G_list = [2];
Pr_list = [1e-4];
RaA_list = [6.36e-4 6.35e-4];
res = ['N_' num2str(N)];
thres = 1e-13;
getEigv = 1;
WO = 1;
WE = 0;
tic
for k=1:length(G_list)
    G = G_list(k);
    for i=1:length(Pr_list)
        Pr = Pr_list(i)
        for j = 1:length(RaA_list)
            RaA = round(RaA_list(j),3,'significant');
            PrZeroData = GetAllEigsFunc(PrZeroData,N,G,RaA,Pr,thres,getEigv,WO,WE);
        end
    end
end
toc
save(spath,"PrZeroData")
