Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
% Adding the extra functions we want
fpath = '/mi/share/scratch/winchester/Matlab/Eigs/';
addpath(fpath)
% Loading in the old data
dpath = '/home/winchester/MatlabDatatop/Data/masternew.mat';
spath =  [pwd  '/NewData.mat'];
load(dpath);
NewData = Data;
clear Data;
% constants
N = 400;
G = 2;
AR = ['AR_' num2str(G)];
typef = 'OneOne256';
type = ['OneOne' num2str(N)];
Pr_list = [1e4 6e4 1e5 3e5 1e6];
thres = 1e-13;

tic
for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    A = GetFullM(NewData, PrS, AR,type);
    [~,Ra] = GetNextRaNonLinear(A);   
    RaS = RatoRaS(Ra);
    ThetaE = NewData.(AR).(type).(PrS).(RaS).ThetaE;
    PsiE = NewData.(AR).(type).(PrS).(RaS).PsiE;
    Eigv = NewData.(AR).(typef).(PrS).(RaS).Eigv;
    Eigv = ExpandEigenFunc2(Eigv,256, N);
    sigmas = NewData.(AR).(typef).(PrS).(RaS).sigmaodd;
    [~,I] = max(real(sigmas));
    sigmaoddguess = sigmas(I);
    M = MakeMatrixForOddProblem2(N,G, PsiE, ThetaE, Ra, Pr);
    [Eigv,~] = eigs(M,1,sigmaoddguess,'StartVector', Eigv,'Tolerance',1e-10);
    clear M
    NewData.(AR).(type).(PrS).(RaS).Eigv = Eigv;
    save(spath,'NewData')
end
toc