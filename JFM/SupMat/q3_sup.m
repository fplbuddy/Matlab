addpath('/Users/philipwinchester/Dropbox/Matlab/JFM')
run SetUp.m
yt = [1e-18 1e-14 1e-10 1e-6 1e-2 1e2 1e6 1e10];
%% make exponential growth
figure('Renderer', 'painters', 'Position', [5 5 700 200])
range = 0.5;

sstart = 1.5e-10;
Pr = 8.57;
Ra = 1.2e6;
PrS = PrtoPrS(Pr);
RaS = RatoRaS(Ra);
kappa = AllData.AR_2.(PrS).(RaS).kappa;

f = 108;
period = 1/f;
t = 0:1e-4:100;
s = sin(2*pi*(t)/period); 

% now work out the decay
%lam = log(abs(signal(locs(1)))/(abs(signal(locs(2)))))/(period/2);
lam = 0.428;
decay = exp(lam*t);
signal = sstart*decay.*s;



subplot(1,3,1)
semilogy(t,abs(signal), 'Color', 'red')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$|\widehat \psi_{0,1}|$','FontSize', LabelFS)
xlabel('$t$','FontSize', LabelFS)
title('(a) $Ra/10^6 = 1.2$', 'FontSize', LabelFS)
%text(18.13,2.85, '$q_3$', 'FontSize', LabelFS,'Color', 'r')
yticks(yt)
ylim([1e-10 max(abs(signal))])
%% 
Ra = 1.2e6;
RaS = RatoRaS(Ra);
kappa = AllData.AR_2.(PrS).(RaS).kappa;

f = 110;
period = 1/f;
s = sin(2*pi*(t)/period); 

% now work out the decay
%lam = log(abs(signal(locs(1)))/(abs(signal(locs(2)))))/(period/2);
lam = -0.169;
decay = exp(lam*t);
signal = sstart*decay.*s;



subplot(1,3,2)
semilogy(t,abs(signal), 'Color', 'red')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t$','FontSize', LabelFS)
title('(b) $1.27$', 'FontSize', LabelFS)
yticks(yt)
ylim([1e-18 1e-10])
%%
Ra = 1.3e6;
PrS = PrtoPrS(Pr);
RaS = RatoRaS(Ra);
kappa = AllData.AR_2.(PrS).(RaS).kappa;

f = 1.01e3;
period = 1/f;
s = sin(2*pi*(t)/period); 

% now work out the decay
%lam = log(abs(signal(locs(1)))/(abs(signal(locs(2)))))/(period/2);
lam = 0.232;
decay = exp(lam*t);
signal = sstart*decay.*s;



subplot(1,3,3)
semilogy(t,abs(signal), 'Color', 'red')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t$','FontSize', LabelFS)
title('(c) $1.3$', 'FontSize', LabelFS)
%text(18.13,2.85, '$q_3$', 'FontSize', LabelFS,'Color', 'r')
yticks(yt)
ylim([1e-10 max(abs(signal))])

saveas(gcf,[figpath2 'q3_sup.eps'], 'epsc')

