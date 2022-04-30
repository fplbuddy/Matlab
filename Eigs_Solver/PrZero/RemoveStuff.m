fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
addpath(fpath)
addpath(fpath2)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
spath = dpath;
load(dpath);
% constants
crit = 1e-18;
res = "N_64";
GS = "G_2_1";
%PrS_list = string(fields(PrZeroData.(GS).(res)));
PrS_list = ["Pr_1e_4"];
for i =1:length(PrS_list)
   PrS =  PrS_list(i);
   RaAS_list = string(fields(PrZeroData.(GS).(res).(PrS)));
   for j=1:length(RaAS_list)
       RaAS = RaAS_list(j);
       PsiE =  PrZeroData.(GS).(res).(PrS).(RaAS).PsiE;
       check = abs(PsiE(1));
       if check < crit
           PrZeroData.(GS).(res).(PrS) = rmfield(PrZeroData.(GS).(res).(PrS),RaAS);
       end 
   end 
end
