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
Pr_list = [6.7e5 7e5];
thres = 1e-12;
Ra_list = [2.53e7 2.54e7 2.55e7 2.56e7];
for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    for i=1:length(Ra_list)
        Ra = Ra_list(i);
        RaS = RatoRaS(Ra);
        % check if maybe we have it
        try
            NewData.(AR).(type).(PrS).(RaS).sigmaoddZ;
            gotZonal = 1;
        catch
            gotZonal = 0;
        end
        try
            NewData.(AR).(type).(PrS).(RaS).sigmaoddNZ;
            gotNonZonal = 1;
        catch
            gotNonZonal = 0;
        end
        stip
        if not(gotZonal) || not(gotNonZonal)
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
            M = MakeMatrixForOddProblem2(N,G, PsiE, ThetaE, Ra, Pr);
            if not(gotZonal)
                sigmaoddguess = -1i*5.6e3;
                EigvZ = NewData.AR_2.OneOne400.Pr_160000.Ra_1_85e7;
                [~,sigmaoddZ] = eigs(M,1,sigmaoddguess,'StartVector', EigvZ,'Tolerance',1e-10);
                NewData.(AR).(type).(PrS).(RaS).sigmaoddZ = sigmaoddZ;
                %NewData.(AR).(type).(PrS).(RaS).EigvZ = EigvZ;
                save(spath,'NewData')
                clear EigvZ
            end
            if not(gotNonZonal)
                sigmaoddguess = 0;
                EigvNZ = NewData.AR_2.OneOne400.Pr_200000.Ra_2_58e7.Eigv;
                [~,sigmaoddZ] = eigs(M,1,sigmaoddguess,'StartVector', EigvNZ,'Tolerance',1e-10);
                NewData.(AR).(type).(PrS).(RaS).sigmaoddNZ = sigmaoddNZ;
                %NewData.(AR).(type).(PrS).(RaS).EigvNZ = EigvNZ;
                clear EigvNZ
                save(spath,'NewData')
            end
            clear M
        end
    end
end
