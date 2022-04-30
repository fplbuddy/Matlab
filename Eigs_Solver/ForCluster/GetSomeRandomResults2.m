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
N = 88;
G = 2;
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(N)];
spath = '/Volumes/Samsung_T5/SomeStencils/';
load([spath 'NL_' num2str(N)])
Pr_list = [1];
Ra_list = [1e6];
tic
for i=1:length(Pr_list)
    clear Vo Ve
    Pr = Pr_list(i);
    PrS = PrtoPrS(Pr);
    % Getting ICs
    for j = 1:length(Ra_list)
        
        Ra = Ra_list(j);
        RaS = RatoRaS(Ra);
        
%         [PsiE, ThetaE] = GetIC(Ra, Pr, Data, AR, type);
%         [PsiE, ThetaE, dxmin] = NRstenc(PsiE, ThetaE, N, G, Ra, Pr,NL);
%         % Saving the data
%             Data.(AR).(type).(PrS).(RaS).Ra = Ra;
%             Data.(AR).(type).(PrS).(RaS).Pr = Pr;
%             Data.(AR).(type).(PrS).(RaS).dxmin = dxmin;
%             Data.(AR).(type).(PrS).(RaS).PsiE = PsiE;
%             Data.(AR).(type).(PrS).(RaS).ThetaE = ThetaE;
        PsiE = Data.(AR).(type).(PrS).(RaS).PsiE;
        ThetaE = Data.(AR).(type).(PrS).(RaS).ThetaE;
        toc
        % do eigenvalue problem
        % odd
        M = MakeMatrixForOddProblem(N,G, PsiE, ThetaE, Ra, Pr);
        toc
        [Vo,D] = eig(M);
        toc
        clear M
        D = diag(D);
        Data.(AR).(type).(PrS).(RaS).sigmaodd = D;
        clear D
        % even
        M = MakeMatrixForEvenProblem(N,G, PsiE,ThetaE, Ra, Pr);
        toc
        [Ve,D] = eig(M);
        toc
        clear M
        D = diag(D);
        Data.(AR).(type).(PrS).(RaS).sigmaeven = D; 
        clear D
    end
end
toc