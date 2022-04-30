run SetUp.m

h = pi;

% Get BurstData
ARS = "AR_2";
PrS = "Pr_1";
RaS = "Ra_6_4e6";
kpsmodes1b = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
kenergyb = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
ICT = AllData.(ARS).(PrS).(RaS).ICT;
tb = kpsmodes1b(:,1); tb = tb(ICT:end);
OneOneb = kpsmodes1b(:,2); OneOneb = 2*OneOneb(ICT:end);
urms = AllData.(ARS).(PrS).(RaS).urms;
OneOneb = OneOneb/(h*urms); 
tb = tb/(h/urms);

Ik = kenergyb(:,4);
kappa = AllData.(ARS).(PrS).(RaS).kappa;
Nub = 1 + pi*2*Ik(ICT:end)/kappa;

% Get Rev-data
% ARS = "AR_2";
% PrS = "Pr_30";
% RaS = "Ra_6_4e6";
% kpsmodes1r = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
% kenergyr = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
% ICT = AllData.(ARS).(PrS).(RaS).ICT;
% tr = kpsmodes1r(:,1); tr = tr(ICT:end);
% OneOner = kpsmodes1r(:,2); OneOner = 2*OneOner(ICT:end);
% urms = AllData.(ARS).(PrS).(RaS).urms;
% OneOner = OneOner/(h*urms); 
% tr = tr/(h/urms);
% 
% 
% Ik = kenergyr(:,4);
% kappa = AllData.(ARS).(PrS).(RaS).kappa;
% Nur = 1 + pi*2*Ik(ICT:end)/kappa

% Doing it with ext, as I have dont with fig 3
urms = AllData.AR_2.Pr_30.Ra_6_4e6.urms; h = pi; kappa = AllData.AR_2.Pr_30.Ra_6_4e6.kappa;
kpsmodes1ext = importdata('/Users/philipwinchester/Documents/Data/Residue/Ra_6_4e6_ext/Checks/kpsmodes1.txt');
kenergy = importdata('/Users/philipwinchester/Documents/Data/Residue/Ra_6_4e6_ext/Checks/kenergy.txt');
OneOner = 2*kpsmodes1ext(:,2)/(h*urms); tr = kpsmodes1ext(:,1)/(h/urms);
Ik = kenergy(:,4);
Nur = 1 + pi*2*Ik/kappa;

%% Make Plot
figure('Renderer', 'painters', 'Position', [5 5 700 600])
subplot(2,2,3)
plot(tr-1.4e4, Nur(1:length(tr)), 'Color', [0 0.5 0])
xlim([0 2000])
ylim([0 80])
yticks([0 35 70])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('Nu$(t)$', 'Fontsize', LabelFS)
xlabel('$t/(\pi d/u_{rms})$', 'Fontsize', LabelFS)
xticklabels({'10000' '11000' '12000'})
xticks([0 1000 2000])
%
subplot(2,2,4)
plot(tb-min(tb), Nub(1:length(tb)), 'Color', 'r')
xlim([0 2000])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t/(\pi d/u_{rms})$', 'Fontsize', LabelFS)
ylim([0 100])
xticklabels({'10000' '11000' '12000'})
xticks([0 1000 2000])
%
subplot(2,2,1)
plot(tr-1.4e4, OneOner(1:length(tr)), 'Color', [0 0.5 0])
xlim([0 2000])
%ylim([0 80])
%yticks([0 35 70])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$\widehat \psi_{0,1}$', 'Fontsize', LabelFS)
title('Ra $= 6.4 \times 10^6$, Pr $=30$', 'Fontsize', TitleFS)
xticklabels({'' '' '' '' '' '' '' ''})
xticks([0 1000 2000])
%
subplot(2,2,2)
plot(tb-min(tb), -OneOneb(1:length(tb)),'Color', 'r')
xlim([0 2000])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
title('Ra $= 6.4 \times 10^6$, Pr $=1$', 'Fontsize', TitleFS)
xticklabels({'' '' '' '' '' '' '' ''})
xticks([0 1000 2000])

