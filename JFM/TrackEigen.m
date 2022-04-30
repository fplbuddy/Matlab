run SetUp.m
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);
%%
figure('Renderer', 'painters', 'Position', [5 5 550 200])
Pr = 0.212;
PrS = PrtoPrS(Pr);

RaS_list = string(fields((Data.AR_2.OneOne152.(PrS))));
[RaS_list, ~] = OrderRaS_list(RaS_list);
sig_list = [];
Ra_list = [];
for i=5:length(RaS_list)
    RaS = RaS_list(i);
    Ra = RaStoRa(RaS);
    Ra_list = [Ra_list Ra];
    sigs = Data.AR_2.OneOne152.(PrS).(RaS).sigmaodd;
    [~,I] = max(real(sigs));
    sig_list = [sig_list sigs(I)];  
end

% add anchor
loc = find(abs(imag(sig_list)) > 1e-5, 1 );
sig_list = [sig_list(1:loc-1) real(sig_list(loc)) sig_list(loc:end)];


plot(real(sig_list), abs(imag(sig_list)), 'k'); hold on
sig_list2 = sig_list(loc:end);
plot(real(sig_list2), -abs(imag(sig_list2)), 'k'), hold on
xlim([-0.5 0.4])
ylim([-3 3])
ylabel('$\mathcal{I}(\sigma^m)$','FontSize', LabelFS)
xlab = xlabel('$\mathcal{R}(\sigma^m)$','FontSize', LabelFS);

% direction arrows
arrow([0.2 0],[0.3 0], 'length', 10)
arrow([0.2 0],[0.1 0], 'length', 10)
%arrow([-0.5 0],[-0.45 0], 'length', 10)
arrow([real(sig_list2(3)) imag(sig_list2(3))],[real(sig_list2(4)) imag(sig_list2(4))], 'length', 10)
arrow([real(sig_list2(3)) -imag(sig_list2(3))],[real(sig_list2(4)) -imag(sig_list2(4))], 'length', 10)

% arrow and Ra
acstart = [0.05 0.5];
acend = [0 0];
arrow(acstart,acend, 'length', 10)
text(acstart(1), acstart(2), '$Ra_a, Ra_c$', 'FontSize', numFS)

bstart = [0.34 -0.5];
bend = [0.355 0];
arrow(bstart,bend, 'length', 10)
text(bstart(1), bstart(2), '$Ra_b$', 'FontSize', numFS, 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'right')

dstart = [-0.40 0.5];
dend = [-0.367 0];
arrow(dstart,dend, 'length', 10)
text(dstart(1), dstart(2), '$Ra_d$', 'FontSize', numFS, 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'right')

estart = [-0.1 1.9];
eend = [0 1.35];
arrow(estart,eend, 'length', 10)
text(estart(1), estart(2), '$Ra_e$', 'FontSize', numFS, 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'right')

% make start
plot(real(sig_list(1)), imag(sig_list(1)), 'k*', 'MarkerSize', MarkerS)
arrow([real(sig_list(1)) 0], [real(sig_list(1))+0.05 0],'length',10)
text(real(sig_list(1))+0.03, 0.5, '$Ra_s$', 'FontSize', numFS, 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center')
plot([0 0], [-3 3], 'k--')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlab.Position(2) = xlab.Position(2) + 0.001;
xlab.Position(1) = xlab.Position(1) - 0.02;

saveas(gcf,[figpath 'Track.eps'], 'epsc')