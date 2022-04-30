run SetUp.m
G = 2.4;
GS = GtoGS(G);
ARS = ['AR' GS(2:end)];
res = '128x128';
Pr = 1e-3; PrS = convertStringsToChars(PrtoPrSZero(Pr));
RaA = 1.35e4; RaAS = convertStringsToChars(RaAtoRaAS(RaA));
%
RaC = RaCfunc(G);
Ra = RaC + RaA;
kappa = sqrt((pi)^3/(Ra*Pr));
%
path = [path ARS '/' res '/' PrS '/' RaAS '/'];
convdata = importdata([path 'Checks/conv.txt']);
t = convdata(:,1);
OneOne = abs(convdata(:,4));
%
figure('Renderer', 'painters', 'Position', [5 5 600 250])
plot(t, OneOne, 'b'), hold on
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t$ (s)', 'FontSize', LabelFS)
ylabel('$\widehat \psi_{1,1}$', 'FontSize', LabelFS)
title('$\Gamma = 2.4$, $Pr = 10^{-3}$, $Ra = Ra_c + 1.35 \times 10^4$', 'FontSize', LabelFS)