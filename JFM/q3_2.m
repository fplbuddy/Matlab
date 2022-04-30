run SetUp.m

%% make exponential growth
figure('Renderer', 'painters', 'Position', [5 5 700 200])
range = 0.5;

Pr = 8.57;
Ra = 1.2e6;
PrS = PrtoPrS(Pr);
RaS = RatoRaS(Ra);
path = AllData.AR_2.(PrS).(RaS).path;
kappa = AllData.AR_2.(PrS).(RaS).kappa;
xlower = AllData.AR_2.(PrS).(RaS).ICT;

kpsmodes1 = importdata([convertStringsToChars(path) '/Checks/kpsmodes1.txt']);
t = kpsmodes1(:,1);
signal = kpsmodes1(:,2);
% non dim
fact = 1e6*1e-10;
t = t/(pi^2/kappa); t = t(xlower:end);
signal = signal/kappa; signal = signal(xlower:end)/fact;


% make new signal

subplot(1,3,1)
plot(t,signal, 'Color', 'red')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$\widehat \psi_{0,1} \times 10^{10}$','FontSize', LabelFS)
%ylim([1e-6 3e20])
%xlim([0 300])
xlabel('$t$','FontSize', LabelFS)
%yticks([1e-6 1e2 1e10 1e18])
xticks([t(end)-range t(end)-range/2 t(end)])
xticklabels(["0" "0.25" "0.5"])
title('(a) $Ra/10^6 = 1.2$', 'FontSize', LabelFS)
text(18.13,2.85, '$q_3$', 'FontSize', LabelFS,'Color', 'r')
xlim([t(end)-range t(end)])
%% 
Ra = 1.27e6;
RaS = RatoRaS(Ra);
path = AllData.AR_2.(PrS).(RaS).path;
kappa = AllData.AR_2.(PrS).(RaS).kappa;
xlower = AllData.AR_2.(PrS).(RaS).ICT;

kpsmodes1 = importdata([convertStringsToChars(path) '/Checks/kpsmodes1.txt']);
t = kpsmodes1(:,1);
signal = kpsmodes1(:,2);
% non dim
fact = 8*1e-10;
t = t/(pi^2/kappa); t = t(xlower:end);
signal = signal/kappa; signal = signal(xlower:end)/fact;


% make new signal

subplot(1,3,2)
plot(t,signal, 'Color', 'red')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
%ylim([1e-6 3e20])
%xlim([0 300])
xlabel('$t$','FontSize', LabelFS)
yticks([])
xticks([t(end)-range t(end)-range/2 t(end)])
xticklabels(["0" "0.25" "0.5"])
%xticks([0 100 200 300])
title('(b) $1.27$', 'FontSize', LabelFS)
%text(5,1e17, '(a)', 'FontSize', LabelFS)
xlim([t(end)-range t(end)])

%%
Ra = 1.3e6;
RaS = RatoRaS(Ra);
path = AllData.AR_2.(PrS).(RaS).path;
kappa = AllData.AR_2.(PrS).(RaS).kappa;
xlower = AllData.AR_2.(PrS).(RaS).ICT;

kpsmodes1 = importdata([convertStringsToChars(path) '/Checks/kpsmodes1.txt']);
t = kpsmodes1(:,1);
signal = kpsmodes1(:,2);
% non dim
fact = 2e3*1e-10;
t = t/(pi^2/kappa); t = t(xlower:end);
signal = signal/kappa; signal = signal(xlower:end)/fact;


% make new signal

subplot(1,3,3)
plot(t,signal, 'Color', 'red')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
%ylim([1e-6 3e20])
%xlim([0 300])
xlabel('$t$','FontSize', LabelFS)
yticks([])
xticks([t(end)-range t(end)-range/2 t(end)])
xticklabels(["0" "0.25" "0.5"])
%xticks([0 100 200 300])
title('(c) $1.3$', 'FontSize', LabelFS)
%text(5,1e17, '(a)', 'FontSize', LabelFS)
xlim([t(end)-range t(end)])

saveas(gcf,[figpath 'q3.eps'], 'epsc')

