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
typef = 'OneOne256';
type = ['OneOne' num2str(N)];
Pr_list = [2e5];
epsr = 1;
epsi = 10;
thres = 1e-13;

tic
%% Get eigv from 256 first
for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    RaS_list = string(fields(NewData.(AR).(typef).(PrS)));
    for j = 1:length(RaS_list)
        RaS = RaS_list(j);
        Ra = RaStoRa(RaS);
            try ngot = not(isfield(NewData.(AR).(typef).(PrS), RaS)); catch, ngot = 1; end
            if ngot % If we need to do NR or not
                [PsiE, ThetaE] = GetIC(Ra, Pr, NewData, AR, typef);
                [PsiE, ThetaE] = CheckSize(PsiE, ThetaE,256);
                [PsiE, ThetaE, dxmin] = NR2(PsiE, ThetaE, 256, G, Ra, Pr, thres);%, NL);
                NewData.(AR).(typef).(PrS).(RaS).Pr = Pr;
                NewData.(AR).(typef).(PrS).(RaS).dxmin = dxmin;
                NewData.(AR).(typef).(PrS).(RaS).PsiE = PsiE;
                NewData.(AR).(typef).(PrS).(RaS).ThetaE = ThetaE;
            else
                ThetaE = NewData.(AR).(typef).(PrS).(RaS).ThetaE;
                PsiE = NewData.(AR).(typef).(PrS).(RaS).PsiE;
            end
            %save(spath,'NewData')
            % Solving odd problem
            EigvZ = NewData.AR_2.OneOne256.Pr_160000.Ra_1_85e7.Eigv;
            sig = NewData.(AR).(typef).(PrS).(RaS).sigmaodd;
            sig(abs(imag(sig))<500) = [];
            [~,I] = max(real(sig));
            sig = sig(I); sig = real(sig) + epsr - 1i*abs(imag(sig))-1i*epsi;
            M = MakeMatrixForOddProblem2(256,G, PsiE, ThetaE, Ra, Pr);
            [EigvZ,sigmaoddZ] = eigs(M,1,sig,'StartVector', EigvZ,'Tolerance',1e-10);
            clear M
            NewData.(AR).(typef).(PrS).(RaS).sigmaoddZ = sigmaoddZ;
            NewData.(AR).(typef).(PrS).(RaS).EigvZ = EigvZ;
            save(spath,'NewData')
    end
end
toc
%% Now we move up
for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    RaS_list = string(fields(NewData.(AR).(type).(PrS)));
    for j = 1:length(Ra_list)
        RaS = RaS_list(j);
        Ra = RaStoRa(RaS);
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
        M = MakeMatrixForOddProblem2(N,G, PsiE, ThetaE, Ra, Pr);
        sigmaoddguess = NewData.(AR).(typef).(PrS).(RaS).sigmaoddZ;
        EigvZ = NewData.(AR).(typef).(PrS).(RaS).EigvZ;
        EigvZ = ExpandEigenFunc2(EigvZ,256, N);
        [~,sigmaoddZ] = eigs(M,1,sigmaoddguess,'StartVector', EigvZ,'Tolerance',1e-10);
        clear M
        NewData.(AR).(type).(PrS).(RaS).sigmaoddZ = sigmaoddZ;
        save(spath,'NewData')
    end
end
toc

