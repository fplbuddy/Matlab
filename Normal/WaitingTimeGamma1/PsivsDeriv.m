%% Get Data
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
G = 1;
ARS = ['AR_' num2str(G)];
Pr = 30;
PrS = ['Pr_' num2str(Pr)];
Ra = 5e5; RaS = normaltoS(Ra,'Ra',1); RaT = RatoRaT(Ra);
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
s = kpsmodes1(:,2);
t = kpsmodes1(:,1);
xlower = AllData.(ARS).(PrS).(RaS).ICT;
t = kpsmodes1(:,1); t = t(xlower:end);
s = kpsmodes1(:,2); s = s(xlower:end);
%%
alph = 0.01;
x = s(1:end-1);
y = zeros(1,length(x));
for i=1:length(s)-1
   y(i) = s(i+1)-s(i);
end
dt = mean(diff(t));
y = y/dt;
%%
scatter1 = scatter(x,y,50,'filled'); 
scatter1.MarkerFaceAlpha = alph;
scatter1.MarkerEdgeAlpha = alph;
xlabel('$\widehat \psi_{0,1}$')
ylabel('$\dot{\widehat{\psi}}_{0,1}$')
title(['$Pr = ' num2str(Pr) ',\, Ra = ' RaT ',\,\Gamma = ' num2str(G) '$'])
saveas(gcf,[figpath 'Scattar_' RaS], 'jpg')