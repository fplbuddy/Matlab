run SetUp.m
figure('Renderer', 'painters', 'Position', [5 5 600 200])
path = '/Volumes/Samsung_T5/EigComp/Pr_6_2';
Pr = 6.2;

subplot(1,2,1)
Ra = 6e4;
RaS =  RatoRaS(Ra);
kpsmodes1 = importdata([path '/' convertStringsToChars(RaS) '/Checks/kpsmodes1.txt']);
Ra = 6e4;
kappa = sqrt((pi)^3/(Ra*Pr));
S1 = kpsmodes1(:,2);
t1 = kpsmodes1(:,1);
% non-dim
S1 = S1/kappa;
t1 = t1/(pi^2/kappa);
plot(t1,S1), hold on

% Get growth rate
xlower = 30;
xupper = length(kpsmodes1(:,2)); %4500; %2e4;
S1 = S1(xlower:xupper);
t1 = t1(xlower:xupper);
% getting peaks
[~,locs] = findpeaks(abs(S1));
sp1 = S1(locs);
tp1 = t1(locs);

%%
[alpha, ~, xFitted, yFitted, ~] = Fitslogy(tp1,abs(sp1));
plot(xFitted, yFitted, '--black', 'LineWidth',2)
xlim([0.1 4.1])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t/((\pi d)^2/\kappa)$', 'FontSize', LabelFS)
ylabel('$\widehat \psi_{0,1}/\kappa$', 'FontSize', LabelFS)
text(0.5,1.5e-8,['$\sigma = ' num2str(round(alpha,3)) '$' ], 'FontSize', LabelFS)
text(0.5,-1.5e-8,'Ra $= 6 \times 10^4$', 'FontSize', LabelFS)
xticks([0.1 1.1 2.1 3.1 4.1])
xticklabels({'0' '1' '2' '3' '4'})
%
%
%
%
%
subplot(1,2,2)
Ra = 7e4;
RaS =  RatoRaS(Ra);
kpsmodes1 = importdata([path '/' convertStringsToChars(RaS) '/Checks/kpsmodes1.txt']);
Ra = 6e4;
kappa = sqrt((pi)^3/(Ra*Pr));
S2 = kpsmodes1(:,2);
t2 = kpsmodes1(:,1);
% non-dim
S2 = S2/kappa;
t2 = t2/(pi^2/kappa);
plot(t2,S2), hold on
xlower = 30;
xupper = 2e4;
S2 = S2(xlower:xupper);
t2 = t2(xlower:xupper);
% getting peaks
[~,locs] = findpeaks(abs(S2));
sp2 = S2(locs);
tp2 = t2(locs);

%
[alpha, ~, xFitted, yFitted, ~] = Fitslogy(tp2,abs(sp2));
plot(xFitted, yFitted, '--black', 'LineWidth',2)

xlim([0.1 4.1])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t/((\pi d)^2/\kappa)$', 'FontSize', LabelFS)
%ylabel('$\widehat \psi_{0,1}/\kappa$', 'FontSize', LabelFS)
text(1.7,3.8e-9,['$\sigma = ' num2str(round(alpha,3)) '0$' ], 'FontSize', LabelFS)
text(1.7,-3.8e-9,'Ra $= 7 \times 10^4$', 'FontSize', LabelFS)
xticks([0.1 1.1 2.1 3.1 4.1])
xticklabels({'0' '1' '2' '3' '4'})
