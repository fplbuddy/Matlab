
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
%load(dpath);

%%
N = 64;
G = 2;
Pr = 9;
Ra = 6e4;
PsiE = Data.AR_2.OneOne64.Pr_9.Ra_6e4.PsiE;
ThetaE = Data.AR_2.OneOne64.Pr_9.Ra_6e4.ThetaE;
[Rem,~,~,~] = GetRemKeep(N,1);
PsiE(Rem) = 0;
ThetaE(Rem) = 0;
Mold = MakeMatrixForEvenProblem(N,G, PsiE, ThetaE, Ra, Pr);
%% trimmming SCRS
PsiE(Rem) = [];
ThetaE(Rem) = [];9
Mnew = MakeMatrixForEvenProblem2(N,G, PsiE, ThetaE, Ra, Pr);

%% compare the two
n = [(-N/2+1):2:(N/2-1) (-N/2):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); 
m = 1:N; m = repelem(m, N/2);
[Rem,~,~,~] = GetRemGeneral(n,m,N);
Rem = [Rem Rem+length(n)];
Mold(:,Rem) = [];
Mold(Rem,:) = [];