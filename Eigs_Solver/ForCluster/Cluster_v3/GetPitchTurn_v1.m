Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
% Adding the extra functions we want
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
spath = '';
load(dpath);
NewData = Data;
clear Data;
% Setting up some constants
G = 2;
N = 152;
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(N)];
Pr_list = [0.2];
thresh = 1e-14;
thresh2 = 1e-5;

for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    A = GetFullMwithImag(NewData, PrS, AR, type);
    [Ra,Done] = GetNextPitch(A,thresh2);
    while not(Done)
        RaS = RatoRaS(Ra)
        % getting steady state
        [PsiE, ThetaE] = GetIC(Ra, Pr, NewData, AR, type);
        [PsiE, ThetaE] = CheckSize(PsiE, ThetaE,N);
        [PsiE, ThetaE, dxmin] = NR2(PsiE, ThetaE, N, G, Ra, Pr, thresh);
        NewData.(AR).(type).(PrS).(RaS).Ra = Ra;
        NewData.(AR).(type).(PrS).(RaS).Pr = Pr;
        NewData.(AR).(type).(PrS).(RaS).dxmin = dxmin;
        NewData.(AR).(type).(PrS).(RaS).PsiE = PsiE;
        NewData.(AR).(type).(PrS).(RaS).ThetaE = ThetaE;
        % Solving odd problem
        M = MakeMatrixForOddProblem2(N,G, PsiE, ThetaE, Ra, Pr);
        sigmaodd = eig(M);
        clear M
        NewData.(AR).(type).(PrS).(RaS).sigmaodd = sigmaodd;
        % Prepping for next round
        A = GetFullMwithImag(NewData, PrS, AR, type);
        [Ra,Done] = GetNextPitch(A,thresh2);
    end
end
save(spath,'NewData');
