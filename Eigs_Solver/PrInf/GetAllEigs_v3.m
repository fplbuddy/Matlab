Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
% Adding the extra functions we want
fpath =  '/mi/share/scratch/winchester/Matlab/Eigs/';
addpath(fpath)
fpath = '/mi/share/scratch/winchester/Matlab/PrInf/';
addpath(fpath)
% Loading in the old data
dpath = '/home/winchester/MatlabDatatop/Data/PrInfData.mat';
spath = [pwd '/NewData.mat'];
load(dpath);
NewData = PrInfData;
clear PrInfData;
% constants
E = 1;
O = 0;
Ny = 128;
G_list = [2.6];
thres = 1e-14;
GetEigv = 1;
Ra_list = [1e4];
SearchType = "Ctype"; % "Ctype", "CRa","CAr"
tic
for i=1:length(G_list)
    G = G_list(i);
    for j = 1:length(Ra_list)
        Ra = Ra_list(j);
        NewData = GetAllEigsFuncInf_nxny(NewData,Ra,Nx,Ny,G,thres,GetEigv,SearchType,O,E);
    end
end
toc
save(spath,'NewData');
