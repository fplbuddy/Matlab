Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
% Adding the extra functions we want
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
spath ='';
load(dpath);
NewData = Data;
clear Data;
% constants
N = 172;
G = 2;
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(N)];
Pr_list = [7];
WE = [0]; % If we want to do the even problem
WO = [1]; % If we want to do the odd problem
tic
for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    WEinst = WE(i);
    WOinst = WO(i);
    M = GetM(NewData, PrS, convertCharsToStrings(type), AR,1, 1,"odd", 1); % Get the first M, will add later
    [Done,RaNew] = GetNextRaNonLinear(M);
    stop
    while not(Done)
        Ra = RaNew
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
        temp.(AR).(type) = NewData.(AR).(type); % only keeps AR and type we are interested in
        NewData = temp;
        % Solving odd problem
        if WOinst
            [sigmaodd,xodd,NewData] = GetAllWeNeedOdd(NewData,N,Pr,Ra, AR);
            A = MakeMatrixForOddProblem(N,G, PsiE, ThetaE, Ra, Pr);
            [xodd,sigmaodd] = eigs(A,1,sigmaodd,'StartVector', xodd,'Tolerance',1e-10);
            clear A
            NewData.(AR).(type).(PrS).(RaS).sigmaoddbranch = sigmaodd;
            NewData.(AR).(type).(PrS).(RaS).xoddbranch = xodd;
            M = AddtoM(M,Ra,real(sigmeodd)); % Adding what we got to M
            save(spath,'NewData')
        end
        % Solve even problem
        if WEinst
            [sigmaeven,xeven,NewData] = GetAllWeNeedEven(NewData,N,Pr,Ra, AR);
            A = MakeMatrixForEvenProblem(N,G, PsiE,ThetaE, Ra, Pr);
            [xeven, sigmaeven] = eigs(A,1,sigmaeven,'StartVector', xeven,'Tolerance',1e-10);
            clear A
            NewData.(AR).(type).(PrS).(RaS).sigmaevenbranch = sigmaeven;
            NewData.(AR).(type).(PrS).(RaS).xevenbranch = xeven;
            M = AddtoM(M,Ra,real(sigmeven)); % Adding what we got to M
            save(spath,'NewData')
        end
        % Saving the NewData
        [Done,RaNew] = GetNextRaNonLinear(M); % Finding next step and if we are done
    end
end
toc 
