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
wpath = '/Volumes/Samsung_T5/OldData/WNLData.mat';
spath = dpath;
load(dpath);
load(wpath);
% constants
N = 32;
G_list = [2];
Pr_list = [4e-3 5e-3 7e-3 8e-3 9e-3];
thres = 1e-13;
getEigv = 0;
WO = 1;
WE = 0;
type1_list = ["Odd"];
type2 = "WNL";
SearchType = 'Simple';
lims = [0 1e5];
flag = 0;
prec = 3;
tic
LimReached = 0;
res_list = ['N_' num2str(N)]; res_list = [convertCharsToStrings(res_list)];

for j=1:length(type1_list)
    type1 = type1_list(j)
for k=1:length(G_list)
    G = G_list(k)
    for i=1:length(Pr_list)
        Pr = Pr_list(i);
        [PrZeroData, LimReached] = GetCrossingInitialFunc(PrZeroData,WNLData, N,G,Pr,thres, getEigv, type1,type2,WO,WE,SearchType, lims,prec,res_list);
        if not(LimReached)
            PrZeroData = GetCloserCrossingFunc(PrZeroData, N,G,Pr,thres, getEigv, type1,WO,WE,SearchType,prec,res_list);
        else
            flag = 1;
            break
        end
    end
    if flag
        break
    end
end
end
toc
save(spath,"PrZeroData")
