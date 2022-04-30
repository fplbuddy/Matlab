addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/PrZero/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/Functions')
load('/Volumes/Samsung_T5/OldData/WNLZero.mat')
%%
G = 2;
GS = GtoGS(G);
%a = (1+G^2/4); % just useful for ICs
%b = a*(4+G^2)*pi^2/G^2;
As = WNLZero.(GS).As;
Fs = WNLZero.(GS).Fs;
sigmas = WNLZero.(GS).sigmas;
[~, Astar,Bstar] = FindBifPointZero2(As,sigmas,Fs);
eps = 1e-2;
tmax = 10;
CFL = 1e-3/tmax;
reset = 1;
epsS = epstoepsS(eps);
if not(isfield(WNLZero.(GS),epsS)) || reset % stat from scratch
    theta0 = log(Astar);
    phi0 = -1;
    solv = SolverZero([theta0 phi0],tmax,As, sigmas,eps,imag(Fs),CFL);
    theta = solv.y(1,:);
    phi = solv.y(2,:);
    t = solv.x;
    % when phi is below 1, we onlt take 1/100th of the points
    burstpoints = find(phi > -1);
    cutpoints = find(phi <= -1);
    keep = [burstpoints cutpoints(1:100:end)];
    keep = sort(keep);
    theta = theta(keep);
    phi = phi(keep);
    t = t(keep);
%     WNLZero.(GS).(epsS).eps = eps;
%     WNLZero.(GS).(epsS).theta = theta;
%     WNLZero.(GS).(epsS).phi = phi;
%     WNLZero.(GS).(epsS).t = t;
else
    theta = WNLZero.(GS).(epsS).theta;
    phi = WNLZero.(GS).(epsS).phi;
    t = WNLZero.(GS).(epsS).t;
    %         rem  = find(isnan(theta));
    %         theta(rem) = [];
    %         phi(rem) = [];
    %         t(rem) = [];
    tend = t(end);
    theta0 = theta(end);
    phi0 = phi(end);
    solv = SolverZero([theta0 phi0],tmax,As, sigmas,eps,imag(Fs),CFL);
    thetaadd = solv.y(1,:); thetaadd = thetaadd(2:end);
    phisadd = solv.y(2,:); phisadd = phisadd(2:end);
    tadd = solv.x + tend; tadd = tadd(2:end);
    
    % when phi is below 1, we onlt take 1/100th of the points
    burstpoints = find(phisadd > -1);
    cutpoints = find(phisadd <= -1);
    keep = [burstpoints cutpoints(1:100:end)];
    keep = sort(keep);
    thetaadd = thetaadd(keep);
    phisadd = phisadd(keep);
    tadd = tadd(keep);
    
    
    WNLZero.(GS).(epsS).theta = [theta thetaadd];
    WNLZero.(GS).(epsS).phi = [phi phisadd];
    WNLZero.(GS).(epsS).t = [t tadd];
end

%save('/Volumes/Samsung_T5/OldData/WNLZero.mat', "WNLZero")
figure('Renderer', 'painters', 'Position', [5 5 600 250])
t = WNLZero.(GS).(epsS).t;
theta = WNLZero.(GS).(epsS).theta;
phi = WNLZero.(GS).(epsS).phi;
plot(t,exp(theta), '-o'), hold on
plot(WNLZero.(GS).(epsS).t,phi*eps^2, '-o')
% TF = islocalmin(phi);
% plot(t(TF), phi(TF)*eps^2,'g*')