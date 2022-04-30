Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
% Adding the extra functions we want
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
spath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Cluster_v3/NewData.mat';
load(dpath);
NewData = Data;
clear Data;
% Setting up some constants
G = 2;
N = 100;
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(N)];
Pr_list = [8.6];
for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    A = GetMForReCrossing(NewData, PrS, AR);
    [Done,Ra] = GetNextRaNonLinear(A);
    while not(Done)
        RaS = RatoRaS(Ra)
        % getting steady state
        [PsiE, ThetaE] = GetIC(Ra, Pr, NewData, AR, type);
        [PsiE, ThetaE, dxmin] = NR(PsiE, ThetaE, N, G, Ra, Pr);
        NewData.(AR).(type).(PrS).(RaS).Ra = Ra;
        NewData.(AR).(type).(PrS).(RaS).Pr = Pr;
        NewData.(AR).(type).(PrS).(RaS).dxmin = dxmin;
        NewData.(AR).(type).(PrS).(RaS).PsiE = PsiE;
        NewData.(AR).(type).(PrS).(RaS).ThetaE = ThetaE;
        %save(spath,'NewData')
        % Solving odd problem
        M = MakeMatrixForOddProblem(N,G, PsiE, ThetaE, Ra, Pr);
        sigmaodd = eig(M);
        clear M
        NewData.(AR).(type).(PrS).(RaS).sigmaodd = sigmaodd;
        %save(spath,'NewData')
        % Prepping for next round
        A = GetMForReCrossing(NewData, PrS, AR);
        [Done,Ra] = GetNextRaNonLinear(A);
    end
end
