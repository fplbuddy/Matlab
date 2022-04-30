run SetUp.m
G = 2;
GS = GtoGS(G);
ARS = ['AR' GS(2:end)];
res = '256x128';
RaA = 1e6; RaAS = convertStringsToChars(RaAtoRaAS(RaA)); RaAT = RatoRaT(RaA);
OEEF = 1e4; OEEFS = convertStringsToChars(OEEFtoOEEFS(OEEF)); OEEFT = RatoRaT(OEEF);
%
path = [path ARS '/' res '/' RaAS '/' OEEFS '/'];
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
text(1e-4,1e5,'$|\widehat \psi_{1,1}|$','FontSize',LabelFS, 'Color','b')
text(2.5e-4,1e5,'$|\widehat \psi_{0,1}|$','FontSize',LabelFS, 'Color','r')
title({['$\frac{O_{energy}}{E_{energy}} = ' OEEFT '$'] ,['$\Gamma =' num2str(G) '$, $Pr = 0$, $\delta Ra =' RaAT '$']}, 'FontSize', LabelFS)
