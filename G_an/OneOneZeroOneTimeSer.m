run SetUp.m
G = 1.2;
GS = GtoGS(G);
ARS = ['AR' GS(2:end)];
res = '32x32';
Pr = 1e-4; PrS = convertStringsToChars(PrtoPrSZero(Pr));
RaA = 0.3; RaAS = convertStringsToChars(RaAtoRaAS(RaA));
%
RaC = RaCfunc(G);
Ra = RaC + RaA;
kappa = sqrt((pi)^3/(Ra*Pr));
%
path = [path ARS '/' res '/' PrS '/' RaAS '/'];
kpsmodes1 = importdata([path 'Checks/kpsmodes1.txt']);
t = kpsmodes1(:,1);
ZeroOne = 2*abs(kpsmodes1(:,2));
OneOne = 2*sqrt(kpsmodes1(:,3).^2 + kpsmodes1(:,5).^2);
ZeroOne = ZeroOne/kappa;
OneOne = OneOne/kappa;
t = t/(pi^2/kappa);
%
figure('Renderer', 'painters', 'Position', [5 5 600 250])
semilogy(t, ZeroOne, 'r'), hold on
%plot(t, OneOne, 'b')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
text(500, 1e-50,'$\widehat \psi_{0,1}$', 'FontSize', LabelFS, 'Color','r')
text(600, 1e-50,'$\widehat \psi_{1,1}$', 'FontSize', LabelFS, 'Color','b')
xlabel('$t/(d^2/\kappa)$ ', 'FontSize', LabelFS)
ylabel('$\widehat \psi_{0,1}$', 'FontSize', LabelFS)
title('$\Gamma = 1.2$, $Pr = 10^{-4}$, $Ra = Ra_c + 0.3$', 'FontSize', LabelFS)
