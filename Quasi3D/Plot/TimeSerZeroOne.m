run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
W = 1; Pr = 30; Ra = 9e6;
WS = normaltoS(W,'W'); PrS = normaltoS(Pr,'Pr'); RaS = normaltoS(Ra,'Ra');
N = 256;
NS = ['N_' num2str(256) 'x' num2str(256)];
IC = 'IC_N';
path = AllData.(IC).(NS).(PrS).(RaS).(WS).path;
kenergy = importdata([path '/Checks/kenergy.txt']);
%%
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(kenergy(:,1), kenergy(:,5))
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t\,  (s)$','FontSize',labelFS)
ylabel('$\widehat \psi_{0,1}$','FontSize',labelFS)
WT = RatoRaT(W); RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
title(['$W=' WT ',\, Ra = ' RaT ',\, Pr = ' PrT '$'], 'FontSize',labelFS)
WS = convertStringsToChars(WS); PrS = convertStringsToChars(PrS);  RaS = convertStringsToChars(RaS); 
%saveas(gcf,[figpath 'W_' WS 'Ra_' RaS 'Pr_' PrS], 'epsc')