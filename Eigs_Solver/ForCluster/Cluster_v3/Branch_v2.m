Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
% Adding the extra functions we want
fpath = '/mi/share/scratch/winchester/Matlab/Eigs/';
addpath(fpath)
% Loading in the old data
dpath = '/home/winchester/MatlabDatatop/Data/masternew.mat';
spath = [pwd '/NewData.mat'];
load(dpath);
NewData = Data;
clear Data;
% constants
N = 400;
G = 2;
AR = ['AR_' num2str(G)];
typef = 'OneOne256';
type = ['OneOne' num2str(N)];
Pr_list = [1.1e5 1.2e5 1.3e5 1.6e5 2e5];
Ra_list = [1e7 3e7];
thres = 1e-13;

tic
%% Get eigv from 256 first
for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    for j = 1:length(Ra_list)
        Ra = Ra_list(j)
        RaS = RatoRaS(Ra);
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
            save(spath,'NewData')
            % Solving odd problem
	    if not(isfield(NewData.(AR).(typef).(PrS).(RaS),"Eigv"))
            M = MakeMatrixForOddProblem2(256,G, PsiE, ThetaE, Ra, Pr);
            [Eigv,sigmaodd] = eig(M);
            clear M
            sigmaodd = diag(sigmaodd);
	    sigmaoddr = real(sigmaodd);
	    sigmaodd(sigmaoddr<-200) = [];
            [~,I] = max(real(sigmaodd)); % getting location of most unstable eigenvalue
            Eigv = Eigv(:,I);
            NewData.(AR).(typef).(PrS).(RaS).sigmaodd = sigmaodd;
            NewData.(AR).(typef).(PrS).(RaS).Eigv = Eigv;
            save(spath,'NewData')
	
        end
    end
end
toc
%% Now we move up
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
        else
            ThetaE = NewData.(AR).(type).(PrS).(RaS).ThetaE;
            PsiE = NewData.(AR).(type).(PrS).(RaS).PsiE;
        end
        save(spath,'NewData')
        % Solving odd problem
        M = MakeMatrixForOddProblem2(N,G, PsiE, ThetaE, Ra, Pr);
        sigmas = NewData.(AR).(typef).(PrS).(RaS).sigmaodd;
        [~,I] = max(real(sigmas));
        sigmaoddguess = sigmas(I);
        Eigv = NewData.(AR).(typef).(PrS).(RaS).Eigv;
        Eigv = ExpandEigenFunc2(Eigv,256, N);
        [~,sigmaodd] = eigs(M,1,sigmaoddguess,'StartVector', Eigv,'Tolerance',1e-10);
        clear M
        NewData.(AR).(type).(PrS).(RaS).sigmaodd = sigmaodd;
        save(spath,'NewData')
    end
end
toc

