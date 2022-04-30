% Treads = 1;
% maxNumCompThreads(Treads);
% maxNumCompThreads(Treads);
%fpath = '/mi/share/scratch/winchester/Matlab/Eigs/';
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions';
addpath(fpath)
% Loading in the old data
%dpath = '/home/winchester/MatlabDatatop/Data/masternew.mat';
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
spath = [pwd '/NewData.mat'];
load(dpath);
NewData = Data;
clear Data;
thres = 1e-14;
G = 2;
WE = 0;
WO = 1;
N = 152;
type = ['OneOne' num2str(N)];
Nx = N;
Ny = Nx;
Search = "Random";
AR = ['AR_' num2str(G)];
%% section which works out which Ra and Pr we want to do
Pr_lim = [0.4 1e5];
Ra_lim = [0 6e5];
[Ra_list,Pr_list] = GetStabBoundary(NewData);
Pr_list(Ra_list > max(Ra_lim) | Ra_list <= min(Ra_lim)) = [];
Ra_list(Ra_list > max(Ra_lim) | Ra_list <= min(Ra_lim)) = [];
Ra_list(Pr_list > max(Pr_lim) | Pr_list <= min(Pr_lim)) = [];
Pr_list(Pr_list > max(Pr_lim) | Pr_list <= min(Pr_lim)) = [];
[Pr_list,I] = sort(Pr_list);
Ra_list = Ra_list(I);
Pr_list = Pr_list(61);
Ra_list = Ra_list(61);
%%
for i=1:length(Pr_list)
    Pr = Pr_list(i);
    Ra = Ra_list(i);
    NewData = GetSomeFunc(NewData,Ra,Pr,Ny,Nx,G,WE,WO,1,thres,Search);
    save(spath,'NewData');
end
