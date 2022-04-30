run SetUp.m

%% make exponential growth
figure('Renderer', 'painters', 'Position', [5 5 700 600])

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

subplot(3,2,1)
plot(t,signal, 'Color', 'red')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$\widehat \psi_{0,1}/\kappa$','FontSize', LabelFS)
xlim([0 15])
xlabel('$t/(d^2/\kappa)$','FontSize', LabelFS)

subplot(3,2,2)
plot(t,signal, 'Color', 'red')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([50 100])
xlabel('$t/(d^2/\kappa)$','FontSize', LabelFS)
%% Make all the text
text(70,75, '$Ra = 3.32 \times 10^5$', 'FontSize', LabelFS)
text(70,-230, '$Ra = 3.33 \times 10^5$', 'FontSize', LabelFS)
text(70,-357, '$Ra = 3.35 \times 10^5$', 'FontSize', LabelFS)
text(-35,0, '(a)', 'FontSize', LabelFS)
text(-35,-230, '(b)', 'FontSize', LabelFS)
text(-35,-430, '(c)', 'FontSize', LabelFS)
%text(8,110, '(i)', 'FontSize', LabelFS)
%text(75,110, '(ii)', 'FontSize', LabelFS)



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
period = (t(locs(2)) - t(locs(1)))*2;

initialamp = 2.2e-4;
tnew = 0:mean(diff(t)):500;
s = sin(2*pi*(tnew-0)/period); % - to set some random starting phase

% now work out the decay
lam = log(abs(signal(locs(1)))/(abs(signal(locs(2)))))/(period/2);
decay = exp(-lam*tnew);
newsignal = initialamp*decay.*s;

plt = subplot(3,2,[3 4]);
plot(tnew, newsignal, 'Color', 'red')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
shift = 0.22;
plt.Position(1) = plt.Position(1) + shift;
plt.Position(3) = plt.Position(3) - shift*2;
ylabel('$\widehat \psi_{0,1}/\kappa$','FontSize', LabelFS)
xlabel('$t/(d^2/\kappa)$','FontSize', LabelFS)
xlim([0 300])

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

subplot(3,2,5)
plot(t,signal*1e2, 'Color', 'red')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$\widehat \psi_{0,1}/\kappa$','FontSize', LabelFS)
xlabel('$t/(d^2/\kappa)$','FontSize', LabelFS)

path = '/Volumes/Samsung_T5/Residue/152x152/Pr_0_2/Ra_3_35e5_2/';
kpsmodes1 = importdata([path 'Checks/kpsmodes1.txt']);
t = kpsmodes1(:,1);
signal = kpsmodes1(:,2);
% non dim
t = t/(pi^2/kappa);
signal = signal/kappa;

subplot(3,2,6)
plot(t,signal, 'Color', 'red')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t/(d^2/\kappa)$','FontSize', LabelFS)
xlim([190 240])

saveas(gcf,[figpath 'Reversals.eps'], 'epsc')

