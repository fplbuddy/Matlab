path = '/Volumes/Samsung_T5/AR_2/32x32/Pr_0_001/Ra_9e2';
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
fpath3 = '/Users/philipwinchester/Dropbox/Matlab/Normal/Functions/';
fpath4 = '/Users/philipwinchester/Dropbox/Matlab/Low_Dim/Functions';
addpath(fpath)
addpath(fpath2)
addpath(fpath3)
addpath(fpath4)
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
kpsmodes1 = importdata([path '/Checks/kpsmodes1.txt']);
OneOne = kpsmodes1(:,5);
ZeroOne = kpsmodes1(:,2);
t = kpsmodes1(:,1);
Ra = 9e2;
Pr = 1e-3;
kappa = sqrt(pi^3/(Ra*Pr));
OneOne = 2*OneOne/kappa;
ZeroOne = 2*ZeroOne/kappa;
t = t/(pi^2/kappa);
FS = 20;

%%
%semilogy(ZeroOne(1:4e4))
%[alpha, ~, ~, ~, Rval] = Fitslogy(t(1:4e4),abs(ZeroOne(1:4e4)));