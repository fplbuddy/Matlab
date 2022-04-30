run SetUp.m

%% make exponential growth
figure('Renderer', 'painters', 'Position', [5 5 700 200])

Pr = 0.2;
Ra = 3.32e5;
kappa = sqrt((pi)^3/(Ra*Pr));
path = '/Volumes/Samsung_T5/AR_2/152x152/Pr_0_2/Ra_3_32e5/';
kpsmodes1 = importdata([path 'Checks/kpsmodes1.txt']);
t = kpsmodes1(:,1);
signal = kpsmodes1(:,2);
% non dim
t = t/(pi^2/kappa);
signal = signal/kappa;

% make new signal
initialamp = 2.2e-6;
[alpha, ~, ~, ~, ~] = Fitslogy(t([2400 16000]),abs(signal([2400 16000])));
tnew = 0:mean(diff(t)):300;
decay = exp(alpha*tnew);
newsignal = decay*initialamp;


subplot(1,4,1)
semilogy(tnew,abs(newsignal), 'Color', 'red')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$|\widehat \psi_{0,1}|$','FontSize', LabelFS)
ylim([1e-6 3e20])
xlim([0 300])
xlabel('$t$','FontSize', LabelFS)
yticks([1e-6 1e2 1e10 1e18])
xticks([0 100 200 300])
title('$Ra/10^5 = 3.32$', 'FontSize', LabelFS)
text(5,1e17, '(a)', 'FontSize', LabelFS)
% text(70,-230, '$Ra = 3.33 \times 10^5$', 'FontSize', LabelFS)
% text(70,-357, '$Ra = 3.35 \times 10^5$', 'FontSize', LabelFS)
% text(-35,0, '(a)', 'FontSize', LabelFS)
% text(-35,-230, '(b)', 'FontSize', LabelFS)
% text(-35,-430, '(c)', 'FontSize', LabelFS)
% %text(8,110, '(i)', 'FontSize', LabelFS)
% %text(75,110, '(ii)', 'FontSize', LabelFS)

%% make exponential decay non-osc
Ra = 3.32859e5;
RaS = RatoRaS(Ra);
lam =  max(real(Data.AR_2.OneOne152.Pr_0_2.(RaS).sigmaodd));
tend = 900;
ampend = initialamp*exp(lam*tend);
subplot(1,4,2);
semilogy([0 tend], [initialamp ampend], 'Color', 'r')
xlim([0 900])
ylim([5e-10 2e-6])
yticks([1e-9 1e-8 1e-7 1e-6])
xticks([0 300 600 900])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t$','FontSize', LabelFS)
title('$3.32859$', 'FontSize', LabelFS)
text(600,7e-7, '(b)', 'FontSize', LabelFS)

%% make exponential decay osc
Ra = 3.33e5;
kappa = sqrt((pi)^3/(Ra*Pr));
path = '/Volumes/Samsung_T5/AR_2/152x152/Pr_0_2/Ra_3_33e5/';
kpsmodes1 = importdata([path 'Checks/kpsmodes1.txt']);
t = kpsmodes1(:,1);
signal = kpsmodes1(:,2);
% non dim
t = t/(pi^2/kappa);
signal = signal/kappa;
t = t(50:end);
signal = signal(50:end);

% find peaks
[pks,locs] = findpeaks(abs(signal));
pks = pks(2:3);
locs = locs(2:3);
period = (t(locs(2)) - t(locs(1)))*2

tnew = 0:mean(diff(t)):1500;
s = sin(2*pi*(tnew-0)/period); % - to set some random starting phase

% now work out the decay
%lam = log(abs(signal(locs(1)))/(abs(signal(locs(2)))))/(period/2);
lam =  max(real(Data.AR_2.OneOne152.Pr_0_2.Ra_3_33e5.sigmaodd));
decay = exp(lam*tnew);
newsignal = initialamp*decay.*s;

subplot(1,4,3);
semilogy(tnew, abs(newsignal), 'Color', 'red')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t$','FontSize', LabelFS)
xlim([0 900])
ylim([5e-10 2e-6])
yticks([1e-9 1e-8 1e-7 1e-6])
xticks([0 300 600 900])
title('$3.33$', 'FontSize', LabelFS)
text(600,7e-7, '(c)', 'FontSize', LabelFS)

%% make exponential growth osc
Ra = 3.35e5;
kappa = sqrt((pi)^3/(Ra*Pr));
path = '/Volumes/Samsung_T5/AR_2/152x152/Pr_0_2/Ra_3_35e5/';
kpsmodes1 = importdata([path 'Checks/kpsmodes1.txt']);
t = kpsmodes1(:,1);
signal = kpsmodes1(:,2);
% non dim
t = t/(pi^2/kappa);
signal = signal/kappa;
t = t(50:end);
signal = signal(50:end);


% find peaks
[pks,locs] = findpeaks(abs(signal));
pks = pks(2:3);
locs = locs(2:3);
period = (t(locs(2)) - t(locs(1)))*2

tnew = 0:mean(diff(t)):900;
s = sin(2*pi*(tnew-0)/period); % - to set some random starting phase

% now work out the decay
%lam = log(abs(signal(locs(1)))/(abs(signal(locs(2)))))/(period/2);
lam = max(real(Data.AR_2.OneOne152.Pr_0_2.Ra_3_35e5.sigmaodd));
decay = exp(lam*tnew);
newsignal = initialamp*decay.*s;

subplot(1,4,4);
semilogy(tnew, abs(newsignal), 'Color', 'red')
ylim([1e-6 3e-3])
xlim([0 900])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t$','FontSize', LabelFS)
yticks([1e-6 1e-5 1e-4 1e-3])
xticks([0 300 600 900])
title('$3.35$', 'FontSize', LabelFS)
text(5*3,1.1e-3, '(d)', 'FontSize', LabelFS)
text(950,1e-2, '$q_1$', 'FontSize', LabelFS,'Color','r')

saveas(gcf,[figpath 'Reversals.eps'], 'epsc')

