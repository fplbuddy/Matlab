addpath('/Users/philipwinchester/Dropbox/Matlab/Periodic/Plot')
run SetUp.m
%%
nu = 3e-3; nuS = nutonuS(nu); 
hnu = 2;
n = 256;
res = ['n_' num2str(n)];
path = '/Volumes/Samsung_T5/Periodic_Vold/n_256/NV3';
kenergy = importdata([path '/Checks/kenergy.txt']);
t = kenergy(:,1);
en = kenergy(:,2);
%%
figure('Renderer', 'painters', 'Position', [5 5 540 300])
plot(t,en)
xlim([100 1000])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t\,(s)$')
ylabel('Kinetic Energy')
title('NV 3', 'FontSize',labelFS)
nuS = convertStringsToChars(nuS); 
saveas(gcf,[figpath 'VOEnergy_' nuS], 'epsc')

