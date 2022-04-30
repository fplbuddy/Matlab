Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
% Adding the extra functions we want
%fpath = '/mi/share/scratch/winchester/Matlab/Eigs/';
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions';
addpath(fpath)
% Loading in the old data
%dpath = '/home/winchester/MatlabDatatop/Data/masternew.mat';
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
%spath = [pwd '/NewData.mat'];
load(dpath);
NewData = Data;
clear Data;
% constants
N = 400;
G = 2;
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(N)];
Pr_list = [3e5];
thres = 1e-13;
for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    % fist check if we have PrS
    if not(isfield(NewData.(AR).(type), PrS))
        Ra_list = [2e7 2.5e7];
        for i=1:length(Ra_list)
            Ra = Ra_list(i);
            RaS = RatoRaS(Ra);
            [RaC,PrC]  = GetRaSPrSClose(Ra, Pr, NewData, AR, type); % need to do this before
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
            else
                ThetaE = NewData.(AR).(type).(PrS).(RaS).ThetaE;
                PsiE = NewData.(AR).(type).(PrS).(RaS).PsiE;
            end
            save(spath,'NewData')
            % Solving odd problem
            sigmaoddguess = NewData.(AR).(type).(PrC).(RaC).sigmaoddZ;
            EigvZ = NewData.AR_2.OneOne400.Pr_160000.Ra_1_85e7;
            M = MakeMatrixForOddProblem2(N,G, PsiE, ThetaE, Ra, Pr);
            [~,sigmaoddZ] = eigs(M,1,sigmaoddguess,'StartVector', EigvZ,'Tolerance',1e-10);
            clear M
            clear EigvZ
            NewData.(AR).(type).(PrS).(RaS).sigmaoddZ = sigmaoddZ;
            save(spath,'NewData')
        end    
    end
    A = GetFullMZonal(NewData, PrS);
    [Done,Ra] = GetNextRaNonLinear(A);
    while not(Done)
        RaS = RatoRaS(Ra);
        [RaC,PrC]  = GetRaSPrSClose(Ra, Pr, NewData, AR, type);
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
        else
            ThetaE = NewData.(AR).(type).(PrS).(RaS).ThetaE;
            PsiE = NewData.(AR).(type).(PrS).(RaS).PsiE;
        end
        save(spath,'NewData')
        % Solving odd problem
        sigmaoddguess = NewData.(AR).(type).(PrC).(RaC).sigmaoddZ;
        EigvZ = NewData.AR_2.OneOne400.Pr_160000.Ra_1_85e7.Eigv;
        M = MakeMatrixForOddProblem2(N,G, PsiE, ThetaE, Ra, Pr);
        [EigvZ,sigmaoddZ] = eigs(M,1,sigmaoddguess,'StartVector', EigvZ,'Tolerance',1e-10);
        clear M
        NewData.(AR).(type).(PrS).(RaS).sigmaoddZ = sigmaoddZ;
        NewData.(AR).(type).(PrS).(RaS).EigvZ = EigvZ;
        save(spath,'NewData')
        A = GetFullMZonal(NewData, PrS);
        [Done,Ra] = GetNextRaNonLinear(A);
    end
end

