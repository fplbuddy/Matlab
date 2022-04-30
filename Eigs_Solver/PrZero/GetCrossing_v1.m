fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
addpath(fpath)
addpath(fpath2)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
spath = dpath;
load(dpath);
% constants
RaC = 8*pi^4;
N = 64;
G = 2;
res = ['N_' num2str(N)];
Pr_list = [0.0187 0.0186];
%PrS_list = string(fieldnames(PrZeroData.(res)));
WE = 0;
WO = 1;
clean = 1;
tic
for i=1:length(Pr_list)
%for i=1:length(PrS_list)
    Pr = Pr_list(i);
    PrS = PrtoPrSZero(Pr);
%     PrS = PrS_list(i);
%     Pr = PrStoPrZero(PrS);
    D = GetFullMZero(PrZeroData, res,PrS);
    [Done,RaA] = GetNextRaA2(D);
    while not(Done)
        Ra = RaA + RaC;
        RaAS = RaAtoRaAS(RaA);
        try ngot = not(isfield(PrZeroData.(res).(PrS), RaAS)); catch, ngot = 1; end
        if ngot % If we need to do NR or not
            [PsiE, ThetaE] = GetICZero(RaA, Pr, res,PrZeroData);
            [PsiE, ThetaE, dxmin] = NR(PsiE, ThetaE, N, G, Ra, Pr);%, NL);
            PrZeroData.(res).(PrS).(RaAS).RaA = RaA;
            PrZeroData.(res).(PrS).(RaAS).Pr = Pr;
            PrZeroData.(res).(PrS).(RaAS).dxmin = dxmin;
            PrZeroData.(res).(PrS).(RaAS).PsiE = PsiE;
            PrZeroData.(res).(PrS).(RaAS).ThetaE = ThetaE;
        else
            ThetaE = PrZeroData.(res).(PrS).(RaAS).ThetaE;
            PsiE = PrZeroData.(res).(PrS).(RaAS).PsiE;
        end
        if WO
            % Solving odd problem
            M = MakeMatrixForOddProblem(N,G, PsiE, ThetaE, Ra, Pr);
            if clean
                [M,rem] = CleanEigenMatrix(M, N,"odd");
            end
            PrZeroData.(res).(PrS).(RaAS).clean = clean;
            sigmaodd = eig(M);
            clear M
            PrZeroData.(res).(PrS).(RaAS).sigmaodd = sigmaodd;
        end
        if WE
            % Solve even problem
            M = MakeMatrixForEvenProblem(N,G, PsiE,ThetaE, Ra, Pr);
            sigmaeven = eig(M);
            clear M
            PrZeroData.(res).(PrS).(RaAS).sigmaeven = sigmaeven;
        end
        D = GetFullMZero(PrZeroData, res,PrS);
        [Done,RaA] = GetNextRaA2(D);
    end
end
toc
save(spath,'PrZeroData')