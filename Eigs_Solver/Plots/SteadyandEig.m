Pr_list = [7 1000 1e4];
Ra_list = [2e6 7e5 5e6];
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);
figsave = '/Users/philipwinchester/Desktop/Figs/';

for i=1:length(Ra_list)
   Pr = Pr_list(i);
   Ra = Ra_list(i);
   RaS = convertStringsToChars(RatoRaS(Ra));
   PrS = PrtoPrS(Pr);
   plotevenfunctionandeig(Data, "AR_2", 256,Pr,Ra,2,1)    
   saveas(gcf,[figsave PrS '_' RaS '.jpg'])
   close all
end