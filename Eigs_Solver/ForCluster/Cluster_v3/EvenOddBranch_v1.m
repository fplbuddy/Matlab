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
WE = [0]; % If we want to do the even problem
WO = [0]; % If we want to do the odd problem
clean = 1;
tic
for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    WEinst = WE(i);
    WOinst = WO(i);
    if not(isfield(NewData.(AR).(type), PrS)) % Checking if we have not got the field
       NewData = StartBranch(NewData,Pr, AR,G, Ra_list(1)); % Add what we need to 88 or 100 if we have it
    end
    stop
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
%         temp.(AR).(type) = NewData.(AR).(type); % only keeps AR and type we are interested in
%         NewData = temp;
        % Solving odd problem
        if WOinst
            [sigmaodd,xodd,NewData] = GetAllWeNeedOdd(NewData,N,Pr,Ra, AR);
            stop
            M = MakeMatrixForOddProblem(N,G, PsiE, ThetaE, Ra, Pr);
            if clean
                [M,rem] = CleanEigenMatrix(M, N,"odd");
                if length(xodd) == N^2
                    xodd(rem) = []; % clen xodd if we have not already
                end
            end  
            NewData.(AR).(type).(PrS).(RaS).clean = clean;
            [xodd,sigmaodd] = eigs(M,1,sigmaodd,'StartVector', xodd,'Tolerance',1e-10);
            clear M
            NewData.(AR).(type).(PrS).(RaS).sigmaoddbranch = sigmaodd;
            NewData.(AR).(type).(PrS).(RaS).xoddbranch = xodd;
            save(spath,'NewData')
            if real(sigmaodd) > 0
                break
            end 
        end
        % Solve even problem
        if WEinst
            [sigmaeven,xeven,NewData] = GetAllWeNeedEven(NewData,N,Pr,Ra, AR);
            M = MakeMatrixForEvenProblem(N,G, PsiE,ThetaE, Ra, Pr);
            if clean
                [M,rem] = CleanEigenMatrix(M, N,"even");
                if length(xeven) == N^2
                    xeven(rem) = []; % clen xeven if we have not already
                end
            end  
            [xeven, sigmaeven] = eigs(M,1,sigmaeven,'StartVector', xeven,'Tolerance',1e-10);
            clear M
            NewData.(AR).(type).(PrS).(RaS).sigmaevenbranch = sigmaeven;
            NewData.(AR).(type).(PrS).(RaS).xevenbranch = xeven;
            save(spath,'NewData')
        end
    end
end
toc
save(spath,'NewData')