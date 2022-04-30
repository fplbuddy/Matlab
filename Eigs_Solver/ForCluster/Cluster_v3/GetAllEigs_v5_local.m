% Treads = 1;
% maxNumCompThreads(Treads);
% maxNumCompThreads(Treads);
%fpath = '/mi/share/scratch/winchester/Matlab/Eigs/';
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions';
addpath(fpath)
% Loading in the old data
%dpath = '/home/winchester/MatlabDatatop/Data/masternew.mat';
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
%spath = [pwd '/NewData.mat'];
load(dpath);
thres = 1e-14;
G = 2;
WE = 0;
WO = 1;
Nx = 152;
Ny = Nx;
GetEigV = 0;
Pr_list = [0.2];
Ra_list = [3.4e5];
Search = "Random";
for i=1:length(Pr_list)
    Pr = Pr_list(i);
    for j=1:length(Ra_list)
        Ra = Ra_list(j);
        Data = GetSomeFunc(Data,Ra,Pr,Ny,Nx,G,WE,WO,GetEigV,thres,Search);
    end
end
stip
save(dpath,'Data');