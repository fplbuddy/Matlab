run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
G = 1;
ARS = ['AR_' num2str(G)];
Pr = 30;
PrS = ['Pr_' num2str(Pr)];
Ra = 5e5; RaS = normaltoS(Ra,'Ra',1); RaT = RatoRaT(Ra);
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
plot(kpsmodes1(:,1),kpsmodes1(:,2)*2)
ylabel('$\widehat \psi_{0,1}$')
xlabel('$t\,(s)$')
title(['$Ra = ' RaT ',\, Pr = ' num2str(Pr) ',\, \Gamma = ' num2str(G) '$'])
saveas(gcf,[figpath 'TS_' RaS '_' PrS '_' ARS], 'epsc')
