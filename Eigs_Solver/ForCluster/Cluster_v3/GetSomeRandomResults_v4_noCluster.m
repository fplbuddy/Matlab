Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
% Adding the extra functions we want
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);
% constants
N = 172;
G = 2;
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(N)];
% spath = '/Volumes/Samsung_T5/SomeStencils/';
% load([spath 'NL_' num2str(N)])
Pr_list = [8];
Ra_list = [1.41e6];
tic
for i=1:length(Pr_list)
    Pr = Pr_list(i);
    PrS = PrtoPrS(Pr);
    for j = 1:length(Ra_list)
        Ra = Ra_list(j);
        RaS = RatoRaS(Ra);        
        try ngot = not(isfield(Data.(AR).(type).(PrS), RaS)); catch, ngot = 1; end
        if ngot % If we need to do NR or not
            [PsiE, ThetaE] = GetIC(Ra, Pr, Data, AR, type);
            [PsiE, ThetaE, dxmin] = NR(PsiE, ThetaE, N, G, Ra, Pr);%, NL);
        else
            ThetaE = Data.(AR).(type).(PrS).(RaS).ThetaE;
            PsiE = Data.(AR).(type).(PrS).(RaS).PsiE;
        end
        [sigmaeven,xeven, sigmaodd,xodd,Data] = GetAllWeNeed(Data,N,Pr,Ra, AR);
        stop
        % Solving odd problem
        M = MakeMatrixForOddProblem(N,G, PsiE, ThetaE, Ra, Pr);
        [xodd,sigmaoddnew] = eigs(M,1,sigmaodd,'StartVector', xodd,'Tolerance',1e-10);
        % Solve even problem
        clear M
        M = MakeMatrixForEvenProblem(N,G, PsiE,ThetaE, Ra, Pr);
        [xeven, sigmaevennew] = eigs(M,1,sigmaeven,'StartVector', xeven,'Tolerance',1e-10);
        clear M
        % Saving the data
        if ngot % had to do NR
            Data.(AR).(type).(PrS).(RaS).Ra = Ra;
            Data.(AR).(type).(PrS).(RaS).Pr = Pr;
            Data.(AR).(type).(PrS).(RaS).dxmin = dxmin;
            Data.(AR).(type).(PrS).(RaS).PsiE = PsiE;
            Data.(AR).(type).(PrS).(RaS).ThetaE = ThetaE;
            Data.(AR).(type).(PrS).(RaS).sigmaoddbranch = sigmaodd;
            Data.(AR).(type).(PrS).(RaS).sigmaevenbranch = sigmaeven;
            Data.(AR).(type).(PrS).(RaS).xoddbranch = xodd;
            Data.(AR).(type).(PrS).(RaS).xevenbranch = xeven;
        else % Did not have to do NR
            Data.(AR).(type).(PrS).(RaS).sigmaoddbranch = sigmaodd;
            Data.(AR).(type).(PrS).(RaS).sigmaevenbranch = sigmaeven;
            Data.(AR).(type).(PrS).(RaS).xoddbranch = xodd;
            Data.(AR).(type).(PrS).(RaS).xevenbranch = xeven;
            
        end
        
    end
end
toc