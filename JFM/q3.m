run SetUp.m
%ylimFFT = [1e-11 1e-6];
%scaling = 1e5;
eps = 1.000001;
ytick = [1e-12 1e-11 1e-10 1e-9 1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1 1e1 1e2];

%% lower time series
figure('Renderer', 'painters', 'Position', [5 5 600 600])
ARS = "AR_2";
Pr = 8.58;
Ra = 1.27e6;
PrS = PrtoPrS(Pr);
RaS = RatoRaS(Ra);
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
t = kpsmodes1(:,1);
signal = kpsmodes1(:,2);
% non-dim
kappa = AllData.(ARS).(PrS).(RaS).kappa;
xlower = AllData.(ARS).(PrS).(RaS).ICT;
t = t(xlower:end); t = t/(pi^2/kappa);
signal = signal(xlower:end); signal = signal/kappa;

subplot(2,2,1)
semilogy(t,abs(signal), '-r')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([t(1) t(end)])
% set ylim
pks = findpeaks(abs(signal));
ylower = floor(log10(min(pks)));
yupper = ceil(log10(max(pks)));
ylim([10^ylower 10^yupper*eps])
yticks([1e-10 1e-9 1e-8 1e-7 1e-6 1e-5 1e-4])
ylabel('$|\widehat \psi_{0,1}|$', 'FontSize', LabelFS)
xlabel('$t$', 'FontSize', LabelFS)
title('$Ra = 1.27 \times 10^6$', 'FontSize', LabelFS)

%% lower FFT
subplot(2,2,3)
[f, P1] = GetSpectra(signal, t);
semilogy(f,P1, '-r')
xlim([0 1500])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
%ylim(ylimFFT)
yticks(ytick)
xlabel('$f/(\kappa/d^2)$', 'FontSize', LabelFS)
ylabel('FFT$(\widehat \psi_{0,1})$', 'FontSize', LabelFS)

%% upper time series
Pr = 8.58;
Ra = 1.35e6;
PrS = PrtoPrS(Pr);
RaS = RatoRaS(Ra);
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
t = kpsmodes1(:,1);
signal = kpsmodes1(:,2);
% non-dim
kappa = AllData.(ARS).(PrS).(RaS).kappa;
xlower = AllData.(ARS).(PrS).(RaS).ICT;
t = t(xlower:end); t = t/(pi^2/kappa);
signal = signal(xlower:end); signal = signal/kappa;
%signal = signal/scaling;

subplot(2,2,2)
semilogy(t,abs(signal), '-r')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([t(1) t(end)])
% calculating ylim
pks = findpeaks(abs(signal));
ylower = floor(log10(min(pks)));
yupper = ceil(log10(max(pks)));
ylim([10^ylower 10^yupper*eps])
yticks([1e-10 1e-9 1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1 1e1 1e2])
xlabel('$t$', 'FontSize', LabelFS)
title('$Ra = 1.35 \times 10^6$', 'FontSize', LabelFS)
text(t(end), (10^yupper)*4, '$q_3$','FontSize', LabelFS,'Color','r')

%% upper FFT
subplot(2,2,4)
[f, P1] = GetSpectra(signal, t);
semilogy(f,P1, '-r')
xlim([0 1500])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
%ylim(ylimFFT)
yticks(ytick)
xlabel('$f/(\kappa/d^2)$', 'FontSize', LabelFS)

saveas(gcf,[figpath 'q3'], 'epsc')