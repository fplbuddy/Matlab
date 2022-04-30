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
Nx = 152;
Ny = Nx;
Pr_list = [30 60];
Ra_list = [4e4 8e4];
SearchType = "NonLinear";
type = ['OneOne' num2str(Nx)];
prec = 3;
AR = ['AR_' num2str(G)];
PrS = PrtoPrS(Pr);
% make sure we have crossing
for i=1:length(Pr_list)
    Pr = Pr_list(i);
    for j=1:length(Ra_list)
        Ra = Ra_list(j);
        Data = GetSomeFunc(Data,Ra,Pr,Ny,Nx,G,WE,WO,0,thres);
        save(spath,'NewData');
    end
end
% now we go closser 
for i=1:length(Pr_list)
Pr = Pr_list(i);
PrS = PrtoPrS(Pr);
M = GetFullM(Data, PrS, AR,type);
[Done,RaNew] = GetNextRa2(M, SearchType,prec);
while not(Done)
    Data = GetSomeFunc(Data,RaNew,Pr,Ny,Nx,G,WE,WO,0,thres);
    M = GetFullM(Data, PrS, AR,"");
    [Done,RaNew] = GetNextRa2(M, SearchType,prec);
    save(spath,'NewData');
end
% Get Eigv
Data = GetSomeFunc(Data,RaNew,Pr,Ny,Nx,G,WE,WO,1,thres);
save(spath,'NewData');
end
