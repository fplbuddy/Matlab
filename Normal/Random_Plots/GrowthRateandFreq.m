fpath = '/Users/philipwinchester/Dropbox/Matlab/Normal/Functions';
addpath(fpath);
FS = 20;
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
%% get data
ARS = 'AR_2';
Pr = 4e5;
Ra = 2.6e7;
RaS = RatoRaS(Ra);
PrS = PrtoPrS(Pr);
kappa = AllData.(ARS).(PrS).(RaS).kappa;
path = AllData.(ARS).(PrS).(RaS).path;
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
ZeroOne = kpsmodes1(:,2);
t = kpsmodes1(:,1);
clear kpsmodes1
xlower = AllData.(ARS).(PrS).(RaS).ICT;
t = t(xlower:end); t = t/(pi^2/kappa);
ZeroOne = ZeroOne(xlower:end); ZeroOne = ZeroOne/kappa;
%% calculate growth rate
aZeroOne = abs(ZeroOne);
[~,locs] = findpeaks(aZeroOne);
[alpha, ~, xfit, yfit, ~] = Fitslogy(t(locs),aZeroOne(locs));
alpha

%%
[f, P1] = GetSpectra(ZeroOne, t);
[~,I] = max(P1);
fmax = f(I)
figure()
semilogy(f,P1,'-o')

%%
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(t, abs(ZeroOne)), hold on
xlim([min(t), max(t)])
%plot(xfit,yfit, 'k--')
ylabel('$\widehat \psi_{0,1}/\kappa$', 'FontSize',FS)
xlabel('$t/((\pi d)^2/\kappa)$', 'FontSize',FS)
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
title(['$Pr = ' num2str(Pr) ', Ra =' num2str(Ra,'%0.3g') '$'], 'FontSize',FS)