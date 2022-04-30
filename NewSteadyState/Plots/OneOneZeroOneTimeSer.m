run SetUp.m
G = 1;
GS = GtoGS(G);
ARS = ['AR' GS(2:end)];
res = '32x16';
RaA = 1e-1; RaAS = convertStringsToChars(RaAtoRaAS(RaA)); RaAT = RatoRaT(RaA);
Pr = 2e-3; PrS = convertStringsToChars(PrtoPrSZero(Pr)); PrT = RatoRaT(Pr);
%
RaC = RaCfunc(G);
Ra = RaC + RaA;
nu = sqrt(pi^3*Pr/Ra);
path = [path ARS '/' res '/' PrS '/' RaAS '/'];
kpsmodes1 = importdata([path 'Checks/kpsmodes1.txt']);
t = kpsmodes1(:,1)/(pi^2/nu);
ZeroOne = 2*abs(kpsmodes1(:,2))/nu;
OneOne = 2*sqrt(kpsmodes1(:,3).^2+kpsmodes1(:,5).^2)/nu;
%
figure('Renderer', 'painters', 'Position', [5 5 600 250])
plot(t, ZeroOne, 'r'), hold on
plot(t,OneOne,'b')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t/(d^2/\nu)$ ', 'FontSize', LabelFS)
text(1.91e5,1,'$|\widehat \psi_{1,1}|/\nu$','FontSize',LabelFS, 'Color','b')
text(1.93e5,1,'$|\widehat \psi_{0,1}|/\nu$','FontSize',LabelFS, 'Color','r')
title(['$\Gamma =' num2str(G) '$, $Pr = ' PrT '$, $\delta Ra =' RaAT '$'], 'FontSize', LabelFS)
%xlim([1.9e5 2e5])
