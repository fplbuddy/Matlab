AR = "AR_2";
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions');
run SetUp.m
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
%load(dpath);
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
%load(dpath);
RaC = 8*pi^4;
markermin = 2;
xstart = 0.06;
width = 0.27;
height = 0.7;
dif = 0.06;
ystart = 0.17;

%% p1

%% k3
figure('Renderer', 'painters', 'Position', [5 5 1200 300])
set(subplot(1,3,3), 'Position', [xstart + 2*(width+dif), ystart, width, height])
x_list = [-0.957 -0.161 0.635];
y_list = [6678 6710 6742];
plot(x_list, y_list, '-k'), hold on
plot(x_list, -y_list, '-k')
%arrow([x_list(1)*0.7 + x_list(2)*0.3  y_list(1)*0.7 + y_list(2)*0.3],[x_list(1)*0.3 + x_list(2)*0.7  y_list(1)*0.3 + y_list(2)*0.7], 'length', 10, 'width', 0.00001)
%arrow([x_list(2)*0.7 + x_list(3)*0.3  y_list(2)*0.7 + y_list(3)*0.3],[x_list(2)*0.3 + x_list(3)*0.7  y_list(2)*0.3 + y_list(3)*0.7], 'length', 10, 'width', 0.00001)
%arrow([x_list(1)*0.7 + x_list(2)*0.3  -y_list(1)*0.7 - y_list(2)*0.3],[x_list(1)*0.3 + x_list(2)*0.7  -y_list(1)*0.3 - y_list(2)*0.7], 'length', 10, 'width', 0.00001)
%arrow([x_list(2)*0.7 + x_list(3)*0.3  -y_list(2)*0.7 - y_list(3)*0.3],[x_list(2)*0.3 + x_list(3)*0.7  -y_list(2)*0.3 - y_list(3)*0.7], 'length', 10, 'width', 0.00001)
arrow([-1 6710],[-0.75 6710], 'length', 10)
arrow([-1 -6710],[-0.75 -6710], 'length', 10)
arrow([0 6710],[0.1 6710], 'length', 10)
arrow([0 -6710],[0.1 -6710], 'length', 10)
arrow([0.1  2500],[-0.1 2500], 'length', 10, 'width', 0.00001)
arrow([0.1  -2500],[-0.1 -2500], 'length', 10, 'width', 0.00001)
%
Pr = 8.58;
PrS = PrtoPrS(Pr);
Ra_list = [1.27e6 1.28e6 1.29e6];
cmap = colormap(winter(length(Ra_list)));
names = ["$1.27$" "$1.28$" "$1.29$"];
for i=1:length(Ra_list)
    Ra = Ra_list(i);
    RaS = RatoRaS(Ra);
    sigs = Data.AR_2.OneOne256.(PrS).(RaS).sigmaodd;
    h(i) = plot(real(sigs), imag(sigs), '*', 'Color',cmap(i,:),'DisplayName', names(i),'MarkerSize',MarkerS-markermin); hold on
end
xlim([-1 1])
ylim([-1e4 1e4])
plot([0 0], [-1e4 1e4],'--k')
lgnd = legend(h(1:length(Ra_list)),'Location', 'Bestoutside', 'FontSize', numFS); title(lgnd,'$Ra/10^6$', 'FontSize', numFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$\mathcal{R}(\sigma^o)$','FontSize', LabelFS);
title('$Pr = 8.58$','FontSize', LabelFS);
text(0.7,0, '(c)', 'FontSize', LabelFS)
text(1.5,1.2e4, '$q_3$', 'FontSize', LabelFS, 'Color', 'r')
text(-1.82,1.2e4, '$q_2$', 'FontSize', LabelFS, 'Color', 'r')
text(-5.1,1.2e4, '$q_1$', 'FontSize', LabelFS, 'Color', 'r')
xlabel('$\mathcal{R}(\sigma^o)$','FontSize', LabelFS);

%% k1
set(subplot(1,3,1), 'Position', [xstart, ystart, width, height])
Pr = 0.2;
PrS = PrtoPrS(Pr);
RaS_list = string(fields((Data.AR_2.OneOne152.(PrS))));
RaS_list = OrderRaS_list(RaS_list);
Is = find(RaS_list == "Ra_3_32e5");
Ie = find(RaS_list == "Ra_3_38e5");
RaS_list = RaS_list(Is:Ie);
sig_list = [];
Ra_list = [];
for i=1:length(RaS_list)
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
plt = plot(real(sig_list), abs(imag(sig_list)), 'k'); hold on
sig_list2 = sig_list(loc:end);
plot(real(sig_list2), -abs(imag(sig_list2)), 'k')
% zero line
plot([0 0], [-0.4 0.4], '--k')

%arrows
arrow([0.2 0],[0.1 0], 'length', 10)
s = 7;
arrow([real(sig_list2(s)) abs(imag(sig_list2(s)))],[real(sig_list2(s+1)) abs(imag(sig_list2(s+1)))], 'length', 10)
arrow([real(sig_list2(s)) -abs(imag(sig_list2(s)))],[real(sig_list2(s+1)) -abs(imag(sig_list2(s+1)))], 'length', 10)


% starts
Ra_list = [3.32e5 3.32859e5 3.33e5 3.35e5];
names = ["$3.32 $" "$3.32859$" "$3.33$" "$3.35$"];
cmap = colormap(winter(length(Ra_list)));
for i=1:length(Ra_list)
   Ra =  Ra_list(i);
   RaS = RatoRaS(Ra);
   sigs = Data.AR_2.OneOne152.(PrS).(RaS).sigmaodd;
   [~,I] = max(real(sigs));
   sigplot = sigs(I);
   if abs(imag(sigplot)) > 0.001
       sigplot = [sigplot conj(sigplot)];
   end
   h(i) = plot(real(sigplot), imag(sigplot), '*', 'Color',cmap(i,:),'DisplayName', names(i),'MarkerSize',MarkerS-markermin); hold on
end
lgnd = legend(h(1:length(Ra_list)),'Location', 'Bestoutside', 'FontSize', numFS); title(lgnd,'$Ra/10^5$', 'FontSize', numFS)

ylim([-0.4 0.4])
xlim([-0.05 0.2])
xticks([0 0.1 0.2])
yticks([-0.4 -0.2 0 0.2 0.4])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$\mathcal{I}(\sigma^o)$','FontSize', LabelFS);
xlabel('$\mathcal{R}(\sigma^o)$','FontSize', LabelFS);
title('$Pr = 0.2$','FontSize', LabelFS)
text(0.16,0.3, '(a)', 'FontSize', LabelFS)
xlabel('$\mathcal{R}(\sigma^o)$','FontSize', LabelFS);

%% k2
set(subplot(1,3,2), 'Position', [xstart+(width+dif), ystart, width, height])
Ra = 3.949e6;
PrS_list = ["Pr_4_97" "Pr_4_98" "Pr_4_99"];
RaS = RatoRaS(Ra);
PrS_list = OrderPrS_list(PrS_list);
plot([0 0], [-2e4 2e4], '--k'),  hold on
plot([-1 0.848], [13500 13500], 'k')
plot([-1 0.848], -[13500 13500], 'k')
% arrows
arrow([-1 13500],[-0.75 13500], 'length', 10)
arrow([-1 -13500],[-0.75 -13500], 'length', 10)
arrow([0 13500],[0.2 13500], 'length', 10)
arrow([0 -13500],[0.2 -13500], 'length', 10)
arrow([0.1 5e3],[-0.1 5e3], 'length', 10)
arrow([0.1 -5e3],[-0.1 -5e3], 'length', 10)

cmap = colormap(winter(length(PrS_list)));
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    sigs = Data.AR_2.OneOne256.(PrS).(RaS).sigmaodd; 
    h(i) = plot(real(sigs),imag(sigs), '*', 'Color',cmap(i,:),'DisplayName', num2str(Pr),'MarkerSize',MarkerS-markermin); hold on
end
xlim([-1 1])
lgnd = legend(h(1:length(PrS_list)),'Location', 'Bestoutside', 'FontSize', numFS); title(lgnd,'$Pr$', 'FontSize', numFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$\mathcal{R}(\sigma^o)$','FontSize', LabelFS);
text(0.7,0, '(b)', 'FontSize', LabelFS)
title('$Ra = 3.949 \times 10^6$','FontSize', LabelFS)

saveas(gcf,[figpath 'Qpoints.eps'], 'epsc')
% 
