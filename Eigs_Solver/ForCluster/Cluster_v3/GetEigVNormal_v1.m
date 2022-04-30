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
N = 256;
G = 2;
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(N)];
Pr_list = [];
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
    M = MakeMatrixForOddProblem2(N,G, PsiE, ThetaE, Ra, Pr);
    [Eigv,sigmaodd] = eig(M);
    clear M
    sigmaodd = diag(sigmaodd);
    [~,I] = max(real(sigmaodd)); % getting location of most unstable eigenvalue
    Eigv = Eigv(:,I);
    NewData.(AR).(typef).(PrS).(RaS).Eigv = Eigv;
    save(spath,'NewData')
end
toc