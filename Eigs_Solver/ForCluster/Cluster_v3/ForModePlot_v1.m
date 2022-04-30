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
WE = 0;
WO = 1;
N = 152;
type = ['OneOne' num2str(N)];
Nx = N;
Ny = Nx;
Search = "CRa";
AR = ['AR_' num2str(G)];
%% section which works out which Ra and Pr we want to do
Pr_lim = [6.16 1e5];
Ra_lim = [6e5 0];
PrS_list_start = string(fieldnames(NewData.(AR).(type)));
rem = [];
for i=1:length(PrS_list_start)
    PrS = PrS_list_start(i); Pr = PrStoPr(PrS);
    if Pr < min(Pr_lim) || Pr > max(Pr_lim) % removing PrS outside the lim
        rem = [rem i];
    end
end
PrS_list_start(rem) = [];
Pr_list = [];
Ra_list = [];
for i=1:length(PrS_list_start)
    PrS = PrS_list_start(i); Pr = PrStoPr(PrS);
    M = GetFullM(NewData, PrS, AR,type);
    v = CrossingVector(M);
    Ra_list = [Ra_list v];
    Pr_list = [Pr_list Pr*ones(1,length(v))];
end
Pr_list(Ra_list > max(Ra_lim) | Ra_list < min(Ra_lim)) = [];
Ra_list(Ra_list > max(Ra_lim) | Ra_list < min(Ra_lim)) = [];
%%
for i=1:length(Pr_list)
    Pr = Pr_list(i);
    Ra = Ra_list(i);
    NewData = GetSomeFunc(NewData,Ra,Pr,Ny,Nx,G,WE,WO,1,thres,Search);
    save(spath,'NewData');
end
