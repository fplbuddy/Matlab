Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
% Adding the extra functions we want
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
addpath(fpath)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
spath = '';
load(dpath);
NewData = Data;
clear Data;
% constants
N = 64;
G = 2;
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(N)];
Ra_list = [8000];
WE = 1;
WO = 1;
tic
Pr = 0;
PrS = "Pr_0";
for j = 1:length(Ra_list)
    Ra = Ra_list(j)
    RaS = RatoRaS(Ra);
    PsiE = NewData.AR_2.OneOne64.Pr_1.Ra_3e4.PsiE;
    [PsiE, dxmin] = NR_zero(PsiE, N, G, Ra);
    
    
    
%     try ngot = not(isfield(NewData.(AR).(type).(PrS), RaS)); catch, ngot = 1; end
%     if ngot % If we need to do NR or not
%         [PsiE, ThetaE] = GetIC(Ra, Pr, NewData, AR, type);
%         [PsiE, ThetaE, dxmin] = NR(PsiE, ThetaE, N, G, Ra, Pr);%, NL);
%         stop
%         NewData.(AR).(type).(PrS).(RaS).Ra = Ra;
%         NewData.(AR).(type).(PrS).(RaS).Pr = Pr;
%         NewData.(AR).(type).(PrS).(RaS).dxmin = dxmin;
%         NewData.(AR).(type).(PrS).(RaS).PsiE = PsiE;
%         NewData.(AR).(type).(PrS).(RaS).ThetaE = ThetaE; 
%         save(spath,'NewData')
%     else
%         ThetaE = NewData.(AR).(type).(PrS).(RaS).ThetaE;
%         PsiE = NewData.(AR).(type).(PrS).(RaS).PsiE;
%     end
%     temp.(AR).(type) = NewData.(AR).(type); % only keeps AR and type we are interested in
%     NewData = temp;
%     if WO
%     % Solving odd problem
%     M = MakeMatrixForOddProblem(N,G, PsiE, ThetaE, Ra, Pr);
%     sigmaodd = eig(M);
%     clear M
%     NewData.(AR).(type).(PrS).(RaS).sigmaodd = sigmaodd;
%     save(spath,'NewData')
%     end
%     if WE
%     % Solve even problem
%     M = MakeMatrixForEvenProblem(N,G, PsiE,ThetaE, Ra, Pr);
%     sigmaeven = eig(M);
%     clear M
%     NewData.(AR).(type).(PrS).(RaS).sigmaeven = sigmaeven;
%     save(spath,'NewData')
%     end
end
toc
%save(spath,'NewData')