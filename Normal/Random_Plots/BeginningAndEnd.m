TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
path = '/Volumes/Samsung_T5/EigComp/256x256/Pr_8/';
fpath = '/Users/philipwinchester/Dropbox/Matlab/Normal/Functions';
addpath(fpath);
RaS = 'Ra_1_41e6';
FS = 18;
path = [path RaS '/'];
kpsmodes1  = importdata([path 'Checks/kpsmodes1.txt']);
start = 1000;
figure('Renderer', 'painters', 'Position', [5 5 700 400])
subplot(1,2,1)
plot(kpsmodes1(:,1), kpsmodes1(:,2))
xlim([0 start])
xlabel('t (s)', 'FontSize', FS)
ylabel('$\widehat\psi_{0,1}$', 'FontSize',FS)
ax = gca;
ax.YAxis.FontSize = FS;
ax.XAxis.FontSize = FS;
subplot(1,2,2)
plot(kpsmodes1(:,1), kpsmodes1(:,2))
xlabel('t (s)', 'FontSize', FS)
ax = gca;
ax.YAxis.FontSize = FS;
ax.XAxis.FontSize = FS;
Ra = RaStoRa(RaS);
RaT = RatoRaT(Ra);
xlim([11000 11300])
sgtitle(['Ra $=' RaT '$, Pr $=8$'], 'Fontsize', FS)
