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
E = 0;
O = 1;
Ny = 172;
G_list = [4];
thres = 1e-14;
GetEigv = 0;
SearchType = "CRa"; % "Ctype", "CRa","CAr"
SearchType2 = "NonLinear";
cont = 0;
prec = 3;
tic
for i=1:length(G_list)
    G = G_list(i);
    %Nx=4*round(Ny*G/4);
    Nx=4*round(Ny*sqrt(G)/4);
    type = ['N_' num2str(Nx) 'x' num2str(Ny)];
    AR = ['AR_' strrep(num2str(G),'.','_')];
    M = GetFullMinf(NewData, AR,type);
    [Done,RaNew] = GetNextRa2(M, SearchType2,prec);
    while not(Done)
        cc
    NewData = GetAllEigsFuncInf_nxny(NewData,RaNew,Nx,Ny,G,thres,GetEigv,SearchType,O,E);
    M = GetFullMinf(NewData, AR,type);
    [Done,RaNew] = GetNextRa2(M, SearchType2,prec);
    end
end
toc
PrInfData = NewData;
save(spath,'PrInfData');
