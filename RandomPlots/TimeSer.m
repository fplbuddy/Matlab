TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
figsave = '/Users/philipwinchester/Desktop/Figs/';
FS = 20;
%%
path = '/Volumes/Samsung_T5/RaAdd/AR_2/64x64/Pr_1e_2/RaA_6';
kpsmodes1 = importdata([path '/Checks/kpsmodes1.txt']);
figure('Renderer', 'painters', 'Position', [5 5 540 200])
t = kpsmodes1(:,1);
ZeroOne = kpsmodes1(:,2);
OneOneR = kpsmodes1(:,3); OneOneI = kpsmodes1(:,5); OneOne = (OneOneR.^2+OneOneI.^2).^(0.5);
%semilogy(t,OneOne, 'LineWidth',2), hold on
semilogy(t,abs(ZeroOne), 'LineWidth',2)
title('Ra = Ra$_c+6$, Pr $= 10^{-2}$', 'FontSize',FS)
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
%saveas(gcf,[figsave 'PrZeroOne.eps'], 'epsc')
%%
path = '/Volumes/Samsung_T5/RaAdd/AR_2/64x64/Pr_1e_2/RaA_7';
kpsmodes1 = importdata([path '/Checks/kpsmodes1.txt']);
figure('Renderer', 'painters', 'Position', [5 5 540 200])
t = kpsmodes1(:,1);
ZeroOne = kpsmodes1(:,2);
OneOneR = kpsmodes1(:,3); OneOneI = kpsmodes1(:,5); OneOne = (OneOneR.^2+OneOneI.^2).^(0.5);
%semilogy(t,OneOne, 'LineWidth',2), hold on
semilogy(t,abs(ZeroOne), 'LineWidth',2)
title('Ra = Ra$_c+7$, Pr $= 10^{-2}$', 'FontSize',FS)
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
%saveas(gcf,[figsave 'PrZeroTwo.eps'], 'epsc')
