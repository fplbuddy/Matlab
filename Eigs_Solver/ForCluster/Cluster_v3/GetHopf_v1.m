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
N = 152;
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(N)];
Pr_list = [0.22];
thresh = 1e-14;
thresh2 = 1e-5;
%% First make sure that we have stuff on either side
Ra_list = [1e5 4e5];
for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    for j = 1:length(Ra_list)
        Ra = Ra_list(j)
        RaS = RatoRaS(Ra);
        try ngot = not(isfield(NewData.(AR).(type).(PrS), RaS)); catch, ngot = 1; end
        if ngot % If we need to do NR or not
            [PsiE, ThetaE] = GetIC(Ra, Pr, NewData, AR, type);
            [PsiE, ThetaE] = CheckSize(PsiE, ThetaE,N);
            [PsiE, ThetaE, dxmin] = NR2(PsiE, ThetaE, N, G, Ra, Pr, thres);%, NL);
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
        end
    end
end

for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    A = hofp(NewData, PrS, AR,type);
    [Ra,Done] = GetNextHopf(A, thresh2);
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
        A = hofp(NewData, PrS, AR,type);
        [Ra,Done] = GetNextHopf(A, thresh2);
    end
end
Data = NewData;
save(dpath,'Data');
