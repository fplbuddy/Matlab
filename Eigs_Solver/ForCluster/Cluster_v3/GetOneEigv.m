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
NewData = Data;
clear Data;
thres = 1e-14;
G = 2;
Nx = 400;
Ny = Nx;
Pr_list = [1e-6];
Ra_list = [1e8];
Search = "Type";
for i=1:length(Pr_list)
    Pr = Pr_list(i);
    for j=1:length(Ra_list)
        Ra = Ra_list(j);
        NewData = GetSomeFuncOneEigV(NewData,Ra,Pr,Ny,Nx,G,thres,Search,Ra,Pr,256);
        save(spath,'NewData');
    end
end
