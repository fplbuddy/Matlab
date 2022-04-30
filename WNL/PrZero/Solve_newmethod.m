addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/PrZero/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/Functions')
load('/Volumes/Samsung_T5/OldData/WNLZero.mat')
%%
G = 2;
GS = GtoGS(G);
As = WNLZero.(GS).As;
Fs = imag(WNLZero.(GS).Fs);
sigmas = WNLZero.(GS).sigmas;
eps = 1e-2;
tmax = 100; % biggest thing we have in each stage
CFL = 1e-3;
epsS = epstoepsS(eps);
numjumps = 25;
[~, Astar,~] = FindBifPointZero2(As,sigmas,Fs);
theta_comb = [log(Astar)];
phi_comb = [-1000];
t_comb = [0];
for i=1:numjumps
    i
    % solve fast stage
    solv = SolverZero_faststage([theta_comb(end) phi_comb(end)],tmax,As, sigmas,eps,Fs,CFL);
    % add data
    tend = t_comb(end);
    thetaadd = solv.y(1,:); thetaadd = thetaadd(2:end);
    phisadd = solv.y(2,:); phisadd = phisadd(2:end);
    tadd = solv.x + tend; tadd = tadd(2:end);
    t_comb = [t_comb tadd];
    theta_comb = [theta_comb thetaadd];
    phi_comb = [phi_comb phisadd];
    % solve slow stage
    solv = SolverZero_slowstage([theta_comb(end) phi_comb(end)],tmax,As, sigmas,eps,Fs,CFL);
    % add data
    tend = t_comb(end);
    thetaadd = solv.y(1,:); thetaadd = thetaadd(2:end);
    phisadd = solv.y(2,:); phisadd = phisadd(2:end);
    tadd = solv.x + tend; tadd = tadd(2:end);
    t_comb = [t_comb tadd];
    theta_comb = [theta_comb thetaadd];
    phi_comb = [phi_comb phisadd];
end