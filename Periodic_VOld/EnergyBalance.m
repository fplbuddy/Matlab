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
dis = kenergy(:,3);
fin = kenergy(:,4);
henk = kenergy(:,5);
%%
figure('Renderer', 'painters', 'Position', [5 5 540 300])
plot(t,(dis*nu+hnu*henk),'DisplayName', '$\langle \nu u\cdot\nabla^{2n}u + \mu u\cdot \nabla^{-1}u \rangle $'), hold on
plot(t,fin,'DisplayName', '$\langle  \nabla^2 \psi f \rangle$')
xlim([100 1000])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t\,(s)$')
lgnd = legend('Location', 'best', 'FontSize', numFS);
title('NV 3 Energy Balance', 'FontSize',labelFS)
nuS = convertStringsToChars(nuS); 
saveas(gcf,[figpath 'VOEnergyBalance_' nuS], 'epsc')

