PND = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Cluster_v3/NewData.mat';
PD = '/Volumes/Samsung_T5/OldData/masternew.mat';
safe = '/Volumes/Samsung_T5/OldData/BackUp/masternew.mat';
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)

load(PND); % Load the new data
load(PD); % Load the old data
save(safe, 'Data'); % Save the old one just in case
[~, ~, d2] = comp_struct(Data, NewData); % d2 is thing that NewData has that differs from Data
Data = JoinStruct(d2,Data);
save(PD,'Data')

