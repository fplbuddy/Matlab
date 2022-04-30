Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
% Adding the extra functions we want
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrInf/Functions/';
addpath(fpath)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/PrInfData.mat';
spath = dpath;
load(dpath);
NewData = PrInfData;
clear PrInfData;
% constants
N = 128;
G = 2;
AR = ['AR_' num2str(G)];
type = ['N_' num2str(N)];
thres = 1e-14;
Ra_list = [6e3 3e3 2e3 1e3 800 780];
tic
for j = 1:length(Ra_list)
    Ra = Ra_list(j)
    RaS = RatoRaS(Ra);
    try ngot = not(isfield(NewData.(AR).(type), RaS)); catch, ngot = 1; end
    if ngot % If we need to do NR or not
        ThetaE = GetICinf(Ra, NewData, AR, type);
        [ThetaE, dxmin] = NR3inf(ThetaE, N, G, Ra,thres);%, NL);
        NewData.(AR).(type).(RaS).Ra = Ra;
        NewData.(AR).(type).(RaS).dxmin = dxmin;
        NewData.(AR).(type).(RaS).ThetaE = ThetaE;
    else
        ThetaE = NewData.(AR).(type).(RaS).ThetaE;
    end
    % Solving odd problem
    M = MakeMatrixForOddProblem2inf(N,G, ThetaE, Ra);
    sigmaodd = eig(M);
    sigmaoddr = real(sigmaodd);
    sigmaodd(sigmaoddr < -200) = [];
    clear M
    NewData.(AR).(type).(RaS).sigmaodd = sigmaodd;
end
toc
PrInfData = NewData;
save(spath,'PrInfData');
