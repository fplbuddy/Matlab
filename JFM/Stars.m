AR = "AR_2";
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions');
run SetUp.m
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
%load(dpath);
RaC = 8*pi^4;

%% p1
figure('Renderer', 'painters', 'Position', [5 5 1200 400])
Pr = 5.48e-2;
PrS = PrtoPrSZero(Pr);
RaAS_list = string(fields(PrZeroData.N_32.(PrS)));
RaAS_list = OrderRaAS_list(RaAS_list);
Ra_list = zeros(1,length(RaAS_list));
sigma_list = zeros(1,length(RaAS_list));
for i=1:length(RaAS_list)
    RaAS = RaAS_list(i);
    RaA = RaAStoRaA(RaAS);
    Ra_list(i) = RaA + RaC;
    sig = PrZeroData.N_32.(PrS).(RaAS).sigmaodd;
    sig = max(real(sig));
    sigma_list(i) = sig; 
end
[~,I] = max(sigma_list);
subplot(2,3,1)
%plot(Ra_list, sigma_list), hold on
p = pchip(Ra_list,sigma_list,min(Ra_list):max(Ra_list));
plot(min(Ra_list):max(Ra_list),p, '-k'), hold on
xlim([1130 1190])
ylim([-0.2e-3 0.2e-3])
plot([1120 1200], [0 0], 'k--')
xticks([360+RaC Ra_list(I) 396+RaC])
xticklabels(["1.14", "1.16", "1.18"])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$Ra/10^3$','FontSize', LabelFS)
label_h = ylabel('max$[\sigma^o]$','FontSize', LabelFS);
label_h.Position(1) = label_h.Position(1)*0.999; % change horizontal position of ylabel
title('$Pr = 5.48 \times 10^{-2}$','FontSize', LabelFS)

% do all the text
% p1
text(1.14e3,2.6e-4, '(a)', 'FontSize', LabelFS)
text(1.185e3,2.6e-4, '$p_1$', 'FontSize', LabelFS, 'Color', 'r')
add = 0.06e3;
% p2
text(1.14e3 + add,2.6e-4, '(b)', 'FontSize', LabelFS)
text(1.185e3+add+8,2.6e-4, '$p_2$', 'FontSize', LabelFS, 'Color', 'r')

% p3
text(1.14e3 + 2*add+17,2.6e-4, '(c)', 'FontSize', LabelFS)
text(1.185e3+2*add+17,2.6e-4, '$p_3$', 'FontSize', LabelFS, 'Color', 'r')

% p4
text(1.131e3,-5e-4, '(d)', 'FontSize', LabelFS)
text(1.185e3,-5e-4, '$p_4$', 'FontSize', LabelFS, 'Color', 'r')

% p6
text(1.133e3+add+14,-5e-4, '(e)', 'FontSize', LabelFS)
text(1.185e3+add+8,-5e-4, '$p_6$', 'FontSize', LabelFS, 'Color', 'r')

% p7
text(1.14e3 + 2*add+8,-5e-4, '(f)', 'FontSize', LabelFS)
text(1.185e3+2*add+17,-5e-4, '$p_7$', 'FontSize', LabelFS, 'Color', 'r')

%% p2
Pr = 1.81e-2;
PrS = PrtoPrS(Pr);
RaS_list = string(fields(Data.AR_2.OneOne128.(PrS)));
Ra_list = [];
sigma_list = [];
for i=1:length(RaS_list)
    RaS = RaS_list(i);
    Ra = RaStoRa(RaS);
    Ra_list = [Ra_list Ra];
    sig = Data.AR_2.OneOne128.(PrS).(RaS).sigmaodd;
    sig = max(real(sig));
    sigma_list = [sigma_list sig]; 
end
[Ra_list,I] = sort(Ra_list);
sigma_list = sigma_list(I);
[~,I] = min(sigma_list);
subplot(2,3,2)
plot(Ra_list, sigma_list, '-k'), hold on
xlim([3800 4450])
% ylim([-0.2e-3 0.2e-3])
plot([3800 4450], [0 0], 'k--')
xticks([3.88e3 Ra_list(I) 4.39e3])
yticks([-2e-4 0 2e-4 ])
xticklabels(["3.88", "4.12", "4.39"])
yticklabels([])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$Ra/10^3$','FontSize', LabelFS)
title('$Pr = 1.82 \times 10^{-2}$','FontSize', LabelFS)
%% p3
Pr = 0.217;
PrS = PrtoPrS(Pr);
RaS_list = string(fields(Data.AR_2.OneOne152.(PrS)));
Ra_list = [];
sigma_list = [];
for i=1:length(RaS_list)
    RaS = RaS_list(i);
    Ra = RaStoRa(RaS);
    Ra_list = [Ra_list Ra];
    sig = Data.AR_2.OneOne152.(PrS).(RaS).sigmaodd;
    sig = max(real(sig));
    sigma_list = [sigma_list sig]; 
end
[Ra_list,I] = sort(Ra_list);
sigma_list = sigma_list(I);
[~,I] = max(sigma_list);
p = pchip(Ra_list,sigma_list,min(Ra_list):max(Ra_list));
subplot(2,3,3)
%plot(Ra_list, sigma_list, '-ok'), hold on
plot(min(Ra_list):max(Ra_list),p, '-k'), hold on
xlim([2.35e5 2.8e5])
xticks([2.42e5 2.6e5 2.74e5])
yticks([-5e-2 0 5e-2])
yticklabels(["-5" "0" "5"])
xticklabels(["2.42" "2.6" "2.74"])
text(2.35e5,6e-2,"$\times 10^{-2}$",'FontSize',numFS)
plot([2.35e5 2.8e5], [0 0], 'k--')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$Ra/10^5$','FontSize', LabelFS)
%ylabel('max$[\sigma^o]$','FontSize', LabelFS)
title('$Pr = 0.217$','FontSize', LabelFS)
%% p4
xstart = 0.05;
width = 0.28;
height = 0.25;
dif = 0.04;
ystart = 0.2;
subplot(2,3,4)
set(subplot(2,3,4), 'Position', [xstart, ystart, width, height])
markermin = 2;
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
%% p6
subplot(2,3,5)
set(subplot(2,3,5), 'Position', [xstart + width+dif, ystart, width, height])
x_list = [-0.957 -0.161 0.635];
y_list = [6678 6710 6742];
plot(x_list, y_list, '-k'), hold on
plot(x_list, -y_list, '-k')
arrow([x_list(1)*0.7 + x_list(2)*0.3  y_list(1)*0.7 + y_list(2)*0.3],[x_list(1)*0.3 + x_list(2)*0.7  y_list(1)*0.3 + y_list(2)*0.7], 'length', 10, 'width', 0.00001)
arrow([x_list(2)*0.7 + x_list(3)*0.3  y_list(2)*0.7 + y_list(3)*0.3],[x_list(2)*0.3 + x_list(3)*0.7  y_list(2)*0.3 + y_list(3)*0.7], 'length', 10, 'width', 0.00001)
arrow([x_list(1)*0.7 + x_list(2)*0.3  -y_list(1)*0.7 - y_list(2)*0.3],[x_list(1)*0.3 + x_list(2)*0.7  -y_list(1)*0.3 - y_list(2)*0.7], 'length', 10, 'width', 0.00001)
arrow([x_list(2)*0.7 + x_list(3)*0.3  -y_list(2)*0.7 - y_list(3)*0.3],[x_list(2)*0.3 + x_list(3)*0.7  -y_list(2)*0.3 - y_list(3)*0.7], 'length', 10, 'width', 0.00001)
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
%ylabel('$\mathcal{I}(\sigma^o)$','FontSize', LabelFS);
xlabel('$\mathcal{R}(\sigma^o)$','FontSize', LabelFS);
%text(0,-1.5e4, '$\mathcal{R}(\sigma^o)$', 'FontSize',LabelFS, 'Color','k', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
%text(0.3,1.1e4, '$Pr = 8.58$', 'FontSize',numFS, 'Color','k', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
%text(0.15,1.1e4, '$p_4$', 'FontSize',numFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
%text(0.3,3.9e4, '$Pr = 0.2$', 'FontSize',numFS, 'Color','k', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
%text(0.15,3.9e4, '$p_6$', 'FontSize',numFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
title('$Pr = 8.58$','FontSize', LabelFS);

%% p7
subplot(2,3,6)
set(subplot(2,3,6), 'Position', [xstart + 2*(width+dif), ystart, width, height])
Pr = 6.16;
PrS = PrtoPrS(Pr);
ylabel('$\mathcal{I}(\sigma^o)$','FontSize', LabelFS);
xlabel('$\mathcal{R}(\sigma^o)$','FontSize', LabelFS);

% plot line
RaS_list = string(fields((Data.AR_2.OneOne152.(PrS))));
RaS_list = OrderRaS_list(RaS_list);
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
%plt = plot(real(sig_list), abs(imag(sig_list)), 'k'); hold on
y = min(abs(imag(sig_list))):1:max(abs(imag(sig_list)));
p = pchip(abs(imag(sig_list)),real(sig_list),y);
plot(p, y, 'k'), hold on
xlim([-0.05 0.1])
ylim([180 200])

% make arrows
s = 20;
arrow([p(s) y(s)],[p(s+1) y(s+1)], 'length', 10)
s = 28;
arrow([p(s) y(s)],[p(s+1) y(s+1)], 'length', 10)


Ra_list = [5.05e4 5.43e4 5.83e4];
cmap = colormap(winter(length(Ra_list)));
names = ["$5.05$" "$5.43$" "$5.83$"];
for i=1:length(Ra_list)
    Ra = Ra_list(i);
    RaS = RatoRaS(Ra);
    sigs = Data.AR_2.OneOne152.(PrS).(RaS).sigmaodd;
    h(i) = plot(real(sigs), imag(sigs), '*', 'Color',cmap(i,:),'DisplayName', names(i),'MarkerSize',MarkerS-markermin); hold on
end
plot([0 0], [-1e4 1e4],'--k')
lgnd = legend(h(1:length(Ra_list)),'Location', 'Bestoutside', 'FontSize', numFS); title(lgnd,'$Ra/10^4$', 'FontSize', numFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$\mathcal{R}(\sigma^o)$','FontSize', LabelFS);
title('$Pr = 6.16$','FontSize', LabelFS);


% do position stuff
ystart = 0.68;
set(subplot(2,3,1), 'Position', [xstart, ystart, width, height])
set(subplot(2,3,2), 'Position', [xstart + width+dif, ystart, width, height])
set(subplot(2,3,3), 'Position', [xstart + 2*(width+dif), ystart, width, height])
%set(subplot(2,3,4), 'Position', [xstart, ystart, width, height])
%set(subplot(2,3,5), 'Position', [xstart + width+dif, ystart, width, height])
%set(subplot(2,3,6), 'Position', [xstart + 2*(width+dif), ystart, width, height])

saveas(gcf,[figpath 'Track.eps'], 'epsc')

