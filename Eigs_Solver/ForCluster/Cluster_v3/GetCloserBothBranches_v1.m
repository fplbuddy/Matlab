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
Pr_list = [7e5];
thres = 1e-12;
Ra_list = [2.4e7 2.7e7];
for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    % check if we have crossings
    try
        A = GetFullMZonal(NewData, PrS);
        sig = sign(A(2,:));
        GotZonalCross = not(sig(1) == sig(end));
    catch
        GotZonalCross = 0;
    end
    try
        A = GetFullMNonZonal(NewData, PrS);
        sig = sign(A(2,:));
        GotNonZonalCross = not(sig(1) == sig(end));
    catch
        GotNonZonalCross = 0;
    end
    if not(GotNonZonalCross) || not(GotZonalCross)
        for i=1:length(Ra_list)
            Ra = Ra_list(i);
            RaS = RatoRaS(Ra);
            %[RaC,PrC]  = GetRaSPrSClose(Ra, Pr, NewData, AR, type); need
            %to make sure that the RaC and PrC i get has sigmaoddZ. could
            %do this by first reducing NewData to the nodes that have?
            %think this is what i will do
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
            if not(GotZonalCross)
                %sigmaoddguess = NewData.(AR).(type).(PrC).(RaC).sigmaoddZ;
                sigmaoddguess = -1i*5.6e3;
                EigvZ = NewData.AR_2.OneOne400.Pr_160000.Ra_1_85e7;
                [~,sigmaoddZ] = eigs(M,1,sigmaoddguess,'StartVector', EigvZ,'Tolerance',1e-10);
                clear EigvZ
                NewData.(AR).(type).(PrS).(RaS).sigmaoddZ = sigmaoddZ;
                save(spath,'NewData')
            end
            if not(GotNonZonalCross)
                sigmaoddguess = 0;
                EigvNZ = NewData.AR_2.OneOne400.Pr_200000.Ra_2_58e7.Eigv;
                [~,sigmaoddZ] = eigs(M,1,sigmaoddguess,'StartVector', EigvNZ,'Tolerance',1e-10);
                clear EigvNZ
                NewData.(AR).(type).(PrS).(RaS).sigmaoddNZ = sigmaoddNZ;
                save(spath,'NewData')
            end
        end
    end
end
% now we have made sure we have crossing for both, now we need to get
% closer

% do zonal first
for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    A = GetFullMZonal(NewData, PrS);
    [Done,Ra] = GetNextRaNonLinear(A);
    while not(Done)
        RaS = RatoRaS(Ra);
        %[RaC,PrC]  = GetRaSPrSClose(Ra, Pr, NewData, AR, type);
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
        %sigmaoddguess = NewData.(AR).(type).(PrC).(RaC).sigmaoddZ;
        sigmaoddguess = -1i*5.6e3;
        EigvZ = NewData.AR_2.OneOne400.Pr_160000.Ra_1_85e7;
        M = MakeMatrixForOddProblem2(N,G, PsiE, ThetaE, Ra, Pr);
        [EigvZ,sigmaoddZ] = eigs(M,1,sigmaoddguess,'StartVector', EigvZ,'Tolerance',1e-10);
        clear M
        NewData.(AR).(type).(PrS).(RaS).sigmaoddZ = sigmaoddZ;    
        A = GetFullMZonal(NewData, PrS);
        [Done,Ra] = GetNextRaNonLinear(A);
        if Done
            NewData.(AR).(type).(PrS).(RaS).EigvZ = EigvZ; % save eigV if done
        else
            clear EigvZ
        end
        save(spath,'NewData')
    end
end

% now do non-zonal first
for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    A = GetFullMNonZonal(NewData, PrS);
    [Done,Ra] = GetNextRaNonLinear(A);
    while not(Done)
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
        sigmaoddguess = 0;
        EigvNZ = NewData.AR_2.OneOne400.Pr_200000.Ra_2_58e7.Eigv;
        M = MakeMatrixForOddProblem2(N,G, PsiE, ThetaE, Ra, Pr);
        [EigvNZ,sigmaoddNZ] = eigs(M,1,sigmaoddguess,'StartVector', EigvNZ,'Tolerance',1e-10);
        clear M
        NewData.(AR).(type).(PrS).(RaS).sigmaoddNZ = sigmaoddNZ;
        A = GetFullMNonZonal(NewData, PrS);
        [Done,Ra] = GetNextRaNonLinear(A);
        if Done
            NewData.(AR).(type).(PrS).(RaS).EigvNZ = EigvNZ; % save eigV if done
        else
            clear EigvNZ
        end
        save(spath,'NewData')
    end
end