run SetUp.m
G = 2;
GS = GtoGS(G);
ARS = ['AR' GS(2:end)];
res = '512x256';
nuS = 'nu_1e_7';
%
path = [path ARS '/' res '/' nuS '/'];
kpsmodes1 = importdata([path 'Checks/kpsmodes1.txt']);
t = kpsmodes1(:,1);
ZeroOne = 2*abs(kpsmodes1(:,2));
OneOne = 2*sqrt(kpsmodes1(:,3).^2+kpsmodes1(:,5).^2);
%
figure('Renderer', 'painters', 'Position', [5 5 600 250])
semilogy(t, ZeroOne, 'r'), hold on
plot(t,OneOne,'b')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t$ ', 'FontSize', LabelFS)
text(100,1e-10,'$|\widehat \psi_{1,1}|$','FontSize',LabelFS, 'Color','b')
text(120,1e-10,'$|\widehat \psi_{0,1}|$','FontSize',LabelFS, 'Color','r')
title('$\Gamma = 2$, $Pr = 0$, $\nu = 10^{-7}$', 'FontSize', LabelFS)
