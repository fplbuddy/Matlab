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
WE = 1;
WO = 1;
Nx = 64;
Ny = Nx;
GetEigV = 1;
Gy_list = [0.5 0.4];
Pr_list = [10];
Ra_list = [4e4];
Search = "CRa";
for i=1:length(Pr_list)
    Pr = Pr_list(i);
    for j=1:length(Ra_list)
        Ra = Ra_list(j);
        for k=1:length(Gy_list)
            Gy = Gy_list(k);
            NewData = GetSomeFunc_Quasi(NewData,Ra,Pr,Ny,Nx,G,Gy,WE,WO,GetEigV,thres,Search);
            save(spath,'NewData');
        end
    end
end
