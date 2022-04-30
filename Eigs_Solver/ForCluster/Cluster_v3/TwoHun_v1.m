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
% constants
N = 200;
G = 2;
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(N)];
Pr_list = [3e4];
Ra_list = [1e7];
tic
for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    for j = 1:length(Ra_list)
        Ra = Ra_list(j)
        RaS = RatoRaS(Ra);        
        try ngot = not(isfield(NewData.(AR).(type).(PrS), RaS)); catch, ngot = 1; end
        if ngot % If we need to do NR or not
            [PsiE, ThetaE] = GetIC(Ra, Pr, NewData, AR, type);
            [PsiE, ThetaE, dxmin] = NR(PsiE, ThetaE, N, G, Ra, Pr);%, NL);
            NewData.(AR).(type).(PrS).(RaS).Ra = Ra;
            NewData.(AR).(type).(PrS).(RaS).Pr = Pr;
            NewData.(AR).(type).(PrS).(RaS).dxmin = dxmin;
            NewData.(AR).(type).(PrS).(RaS).PsiE = PsiE;
            NewData.(AR).(type).(PrS).(RaS).ThetaE = ThetaE; 
            save(spath,'NewData')
        else
            ThetaE = NewData.(AR).(type).(PrS).(RaS).ThetaE;
            PsiE = NewData.(AR).(type).(PrS).(RaS).PsiE;
        end
        % Solving odd problem
        [sigmaodd,xodd, M] = GetAllWeNeedOdd200(NewData,N,Pr,Ra, AR,PsiE,ThetaE,G);
        stop
        [xodd,sigmaodd] = eigs(M,1,sigmaodd,'StartVector', xodd,'Tolerance',1e-10);
        clear M
        NewData.(AR).(type).(PrS).(RaS).sigmaoddbranch = sigmaodd;
        NewData.(AR).(type).(PrS).(RaS).xoddbranch = xodd;
        save(spath,'NewData')
    end
end
toc
save(spath,'NewData')