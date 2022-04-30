dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
%%
plotevenfunction(Data, "AR_2", 152,1e3,6e5,2,1);