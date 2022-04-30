Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
% Adding the extra functions we want
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
% constants
N = 400;
G = 2;
Pr_list = [3e4];
Ra_list = [8.62e6];
thres = 1e-13;
GetEigV = 1;
for i=1:length(Pr_list)
    Pr = Pr_list(i)
    for j=1:length(Ra_list)
        Ra = Ra_list(j)
        NewData = GetSomeFunc400zonal(NewData,Ra,Pr,N,G,thres,GetEigV);
        save(spath,'NewData')
    end
end

