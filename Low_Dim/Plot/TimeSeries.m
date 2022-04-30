% Getting functions we need
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
fpath3 = '/Users/philipwinchester/Dropbox/Matlab/Normal/Functions/';
fpath4 = '/Users/philipwinchester/Dropbox/Matlab/Low_Dim/Functions';
addpath(fpath)
addpath(fpath2)
addpath(fpath3)
addpath(fpath4)
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
%%
load('/Volumes/Samsung_T5/OldData/LowDim.mat')
FS = 20;
Pr = 1e-3;
PrS = PrtoPrSZero(Pr);
figure('Renderer', 'painters', 'Position', [5 5 600 300])
subplot(2,1,1)
OneOne = results.RaA_1e0.Pr_1e_3.y(1,:);
ZeroOne = results.RaA_1e0.Pr_1e_3.y(3,:);
t = results.RaA_1e0.Pr_1e_3.t;
plot(t,OneOne,'Color','blue'), hold on
plot(t,ZeroOne,'Color','red')
xlim([1e6, 2e6])
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
ylim([-0.015 0.015])
title('$\delta$Ra = $1$', 'FontSize',FS)

subplot(2,1,2)
OneOne = results.RaA_1e2.Pr_1e_3.y(1,:);
ZeroOne = results.RaA_1e2.Pr_1e_3.y(3,:);
t = results.RaA_1e2.Pr_1e_3.t;
plot(t,OneOne,'Color','blue'), hold on
plot(t,ZeroOne,'Color','red')
xlim([4e5, 4.1e5])
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
ylim([-0.015 0.015])
xlabel('t/$((\pi d)^2/\kappa)$', 'FontSize', FS)
title('$\delta$Ra = $100$', 'FontSize',FS)

text(4.019e5,0.03,'$\widehat \psi_{1,1}$','FontSize',FS, 'Color', 'blue')
text(4.027e5,0.03,'$\widehat \psi_{0,1}$','FontSize',FS, 'Color', 'red')