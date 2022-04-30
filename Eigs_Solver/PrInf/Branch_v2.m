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
% constants
N = 400;
G = 2;
AR = ['AR_' num2str(G)];
typef = 'N_256';
type = ['N_' num2str(N)];
Ra_list = [2e7 3e7];
thres = 1e-14;

tic
%% Get eigv from 256 first
for j = 1:length(Ra_list)
    Ra = Ra_list(j)
    RaS = RatoRaS(Ra);
    try ngot = not(isfield(PrInfData.(AR).(typef), RaS)); catch, ngot = 1; end
    if ngot % If we need to do NR or not
        ThetaE = GetICinf(Ra, PrInfData, AR, typef);
        [ThetaE, dxmin] = NR3inf(ThetaE, 256, G, Ra,thres);%, NL);
        PrInfData.(AR).(typef).(RaS).Ra = Ra;
        PrInfData.(AR).(typef).(RaS).dxmin = dxmin;
        PrInfData.(AR).(typef).(RaS).ThetaE = ThetaE;
    else
        ThetaE = PrInfData.(AR).(typef).(RaS).ThetaE;
    end
    if not((isfield(PrInfData.(AR).(typef).(RaS), 'Eigv')))
        save(spath,'PrInfData');
        % Solving odd problem
        M = MakeMatrixForOddProblem2inf(256,G, ThetaE, Ra);
        [Eigv,sigmaodd] = eig(M);
        sigmaodd = diag(sigmaodd);
        sigmaoddr = real(sigmaodd);
        [~,I] = max(real(sigmaodd)); % getting location of most unstable eigenvalue
        Eigv = Eigv(:,I);
        sigmaodd(sigmaoddr < -200) = [];
        clear M
        PrInfData.(AR).(typef).(RaS).sigmaodd = sigmaodd;
        PrInfData.(AR).(typef).(RaS).Eigv = Eigv;
        save(spath,'PrInfData');
    end
end

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
    M = MakeMatrixForOddProblem2inf(N,G, ThetaE, Ra);
    sigmas = PrInfData.(AR).(typef).(RaS).sigmaodd;
    [~,I] = max(real(sigmas));
    sigmaoddguess = sigmas(I);
    Eigv = PrInfData.(AR).(typef).(RaS).Eigv;
    Eigv = ExpandEigenFunc2inf(Eigv,256, N);
    [~,sigmaodd] = eigs(M,1,sigmaoddguess,'StartVector', Eigv,'Tolerance',1e-10);
    clear M
    PrInfData.(AR).(type).(RaS).sigmaodd = sigmaodd;
    save(spath,'PrInfData');
end
toc
save(spath,'PrInfData');
