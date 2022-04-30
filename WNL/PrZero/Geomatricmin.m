load('/Volumes/Samsung_T5/OldData/WNLZero.mat')
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrActuallyZero/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions')
%% compare to solver
G  = 2;
GS = GtoGS(G);
eps = 0.01;
epsS = epstoepsS(eps);
t = WNLZero.(GS).(epsS).t;
phi = WNLZero.(GS).(epsS).phi;
theta = WNLZero.(GS).(epsS).theta;
%t = t_comb;
%phi= phi_comb;
TF = islocalmin(phi);
thetamin = islocalmin(theta);
phimin = phi(TF);
phimaxloc =  islocalmax(phi);
Ac_list_true = exp(theta(thetamin));

%%
phi1 = phimin(1)*eps^2;
A_list = WNLZero.(GS).As;
sigma_list = WNLZero.(GS).sigmas;
lambda_list = abs(imag(WNLZero.(GS).Fs)); % abs as i have got the signs wrong in how I constricted the ODEs
[~,I] = min(abs(sigma_list));
Astar = A_list(I);
SigDivA = @(A) interp1(A_list,sigma_list,A)./A;
SigFuncA = @(t,Ac) interp1(A_list,sigma_list,Ac*exp(t));
SigDivlam = @(A) interp1(A_list,sigma_list,A)./interp1(A_list,lambda_list,A);
phi_list = [phi1];
phi_list_noerror = [phi1];
phi_analysis_noerror = [phi1];
A0_list = [];
Ac_list = [];
A0_list_noerror = [];
Ac_list_noerror = [];
period_list = [];
Ac = Astar*5;
A0 = Astar*1.1;
T = 1;
for i=1:14
    % do the error case first
    [Ac,A0,phi1] = getNext(phi1,A0,Ac/10,Astar,A_list,sigma_list,SigDivA,SigDivlam);
    phi_list = [phi_list phi1];
    A0_list = [A0_list A0];
    Ac_list = [Ac_list Ac];
    
    [Ac,A0,phi2] = getNext(phimin(i)*eps^2,A0,Ac,Astar,A_list,sigma_list,SigDivA,SigDivlam);
    phi_list_noerror = [phi_list_noerror phi2];
    A0_list_noerror = [A0_list_noerror A0];
    Ac_list_noerror = [Ac_list_noerror Ac];
    T = GetPeriod(T,SigFuncA,Ac);
    period_list = [period_list T];
end

% get points from analysis
sigmainf = sigma_list(end);
X = lambda_list./A_list; 
X0 = X(2);
Y = lambda_list.*A_list;
Yinf = Y(end);
I1 = GetI1(sigmainf,SigDivA,1e8,Astar); %1e8 is the largest I can have without error. Answer is approx 
for i=1:14
    phi2 = nextAnalysis(Astar,sigmainf,X0,Yinf,phimin(i)*eps^2,I1);
    phi_analysis_noerror = [phi_analysis_noerror phi2];
end

%% Plot which shows period
tatAcmin = t(thetamin);
figure()
plot(Ac_list(1:end-1),period_list(1:end-1),'*','MarkerSize',10,'DisplayName','Model'), hold on
plot(Ac_list(1:end-1),diff(tatAcmin),'*','MarkerSize',10,'DisplayName','True')
legend()
ylabel('Period')
xlabel('$A_{min}$')
saveas(gcf,[figpath 'PeriodPlot'], 'epsc')

%% Plot which shows A points
figure()
plot(t,exp(theta),'-b'), hold on
plot(t(phimaxloc),A0_list_noerror,'--r')
plot(t(phimaxloc),Ac_list_noerror,'--r')
xlabel('t')
ylabel('A')
title('$Pr = 0$, $\Gamma = 2$, $\epsilon = 10^{-2}$')

saveas(gcf,[figpath 'APoints'], 'epsc')


%%  Random plot
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)

numFS = 16;
titelFS = 18;
figure('Renderer', 'painters', 'Position', [5 5 600 200])
semilogy(t,abs(eps^2*phi)); hold on
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
plot(t(TF),abs(phi_list),'r*')
plot(t(TF),abs(phi_list_noerror),'g*')
plot(t(TF),abs(phi_analysis_noerror),'b*')
yticks([1e-6 1e-4 1e-2 1 1e2 1e4 1e6])
ylabel('$|\phi|$','FontSize',titelFS)
xlabel('$t$','FontSize',titelFS)
title('$Pr = 0$, $\Gamma = 2$, $\epsilon = 10^{-2}$','FontSize',titelFS)
figure('Renderer', 'painters', 'Position', [5 5 600 200])
plot(t,eps^2*phi); hold on
plot(t(TF),phi_list,'r*')
plot(t(TF),phi_list_noerror,'g*')
plot(t(TF),phi_analysis_noerror,'b*')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$\phi$','FontSize',titelFS)
xlabel('$t$','FontSize',titelFS)
title('$Pr = 0$, $\Gamma = 2$, $\epsilon = 10^{-2}$','FontSize',titelFS)

%% Plots for Pr = 0 Oscillations document
close all
% sigma
figure('Renderer', 'painters', 'Position', [5 5 600 250])
semilogx(A_list,sigma_list), hold on
xlim([1e-5 1e5])
xticks([1e-5 1 1e5])
plot([1e-5 1], [sigma_list(1) sigma_list(1)], 'k--')
text(1.5,sigma_list(1)+20, '$\sigma_0$', 'FontSize',titelFS)
plot([1e5 1], [sigma_list(end) sigma_list(end)], 'k--')
text(0.2,sigma_list(end)-20, '$\sigma_{\infty}$', 'FontSize',titelFS)
ylim([-450 250])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$A$','FontSize',titelFS)
ylabel('$\sigma(A)$','FontSize',titelFS)
% X
figure('Renderer', 'painters', 'Position', [5 5 600 250])
semilogx(A_list,X), hold on
xlim([1e-5 1e5])
xticks([1e-5 1 1e5])
plot([1e-5 1], [X(2) X(2)], 'k--')
text(1.5,X(2)-20, '$X_0$', 'FontSize',titelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$A$','FontSize',titelFS)
ylabel('$X(A)$','FontSize',titelFS)
% Y
figure('Renderer', 'painters', 'Position', [5 5 600 250])
semilogx(A_list,Y), hold on
xlim([1e-5 1e5])
xticks([1e-5 1 1e5])
plot([1e5 1], [Y(end) Y(end)], 'k--')
text(0.2,Y(end)-20, '$Y_{\infty}$', 'FontSize',titelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$A$','FontSize',titelFS)
ylabel('$Y(A)$','FontSize',titelFS)


%% functions
function I1 = GetI1(sigmainf,SigDivA,large,Astar)
    I1 = sigmainf*log(large/Astar)-integral(@(A) SigDivA(A), Astar, large);
end


function A0 = GetA0(Astar,A_list,sigma_list,A0,phi1,SigDivA)
    % Does one NR for A0
    A0 = A0*(1-(integral(@(A) SigDivA(A), Astar, A0)+phi1)/interp1(A_list,sigma_list,A0));
end

function Ac = GetAc(A0,Ac,SigDivlam)
    % Does one NR for Ac
    Ac = Ac + integral(@(A) SigDivlam(A), Ac, A0)/SigDivlam(Ac);
end

function T2 = NrPeriod(T1,SigFuncA,Ac)
    % Does one NR for period
    T2 = T1 - integral(@(t) SigFuncA(t,Ac), 0, T1)/SigFuncA(T1,Ac);
end

function T = GetPeriod(Tstart,SigFuncA,Ac)
% do NR
d = 1;
T = Tstart;
while d > 1e-14
    Told = T;
    T = NrPeriod(T,SigFuncA,Ac);
    d = abs(Told-T);
end
end

function [Ac,A0,phinext] = getNext(phi,A0,Ac,Astar,A_list,sigma_list,SigDivA,SigDivlam)
% Get A0
d = 1;
while d > 1e-14
    A0old = A0;
    A0 = GetA0(Astar,A_list,sigma_list,A0,phi,SigDivA);
    d = abs(A0old-A0);
end
% Get Ac
d = 1;
while d > 1e-14
    Acold = Ac;
    Ac = GetAc(A0,Ac,SigDivlam);
    d = abs(Acold-Ac);
end
% calculate phi2
phinext = integral(@(A) SigDivA(A), Ac, Astar);   
end

function phi2 = nextAnalysis(Astar,sigmainf,X0,Yinf,phi1,I1)
    phi2 = (Astar^2*sigmainf*X0/(2*Yinf))*(1-exp(2*(I1-phi1)/sigmainf));
end
