Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
% Adding the extra functions we want
fpath = '/mi/share/scratch/winchester/Matlab/PrInf';
addpath(fpath)
fpath = '/mi/share/scratch/winchester/Matlab/Eigs';
addpath(fpath)
% Loading in the old data
dpath = '/scratch/winchester/Matlab/PrInf/PrInfData.mat';
spath = dpath;
load(dpath);
% constants
N = 440;
G = 2;
AR = ['AR_' num2str(G)];
typef = 'N_400';
type = ['N_' num2str(N)];
Ra_list = [2.53e7];
thres = 1e-13;

tic
%% Now we move up
for j = 1:length(Ra_list)
    Ra = Ra_list(j)
    RaS = RatoRaS(Ra);
    try ngot = not(isfield(PrInfData.(AR).(type), RaS)); catch, ngot = 1; end
    if ngot % If we need to do NR or not
        ThetaE = GetICinf(Ra, PrInfData, AR, type);
        [ThetaE, dxmin] = NR3inf(ThetaE, N, G, Ra,thres);%, NL);
        PrInfData.(AR).(type).(RaS).Ra = Ra;
        PrInfData.(AR).(type).(RaS).dxmin = dxmin;
        PrInfData.(AR).(type).(RaS).ThetaE = ThetaE;
    else
        ThetaE = PrInfData.(AR).(type).(RaS).ThetaE;
    end
    save(spath,'PrInfData');
    % Solving odd problem
    sigmas = PrInfData.(AR).(typef).(RaS).sigmaodd;
    [~,I] = max(real(sigmas));
    sigmaoddguess = sigmas(I);
    Eigv = PrInfData.(AR).N_256.(RaS).Eigv;
    Eigv = ExpandEigenFunc2inf(Eigv,256, N);
    M = MakeMatrixForOddProblem2inf(N,G, ThetaE, Ra);
    [~,sigmaodd] = eigs(M,1,sigmaoddguess,'StartVector', Eigv,'Tolerance',1e-10);
    clear M
    PrInfData.(AR).(type).(RaS).sigmaodd = sigmaodd;
    save(spath,'PrInfData');
end
toc
save(spath,'PrInfData');
