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
xstart = 0.07;
width = 0.26;
height = 0.25;
dif = 0.06;
ystart = 0.14;
dify = 0.25;

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
set(subplot(3,2,1), 'Position', [xstart, ystart+(dify+height), width, height])
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
text(1.131e3,1.5e-4, '(a)', 'FontSize', LabelFS)
text(1.185e3,2.6e-4, '$p_1$', 'FontSize', LabelFS, 'Color', 'r')
text(1.258e3,2.6e-4, '$p_2$', 'FontSize', LabelFS, 'Color', 'r')
text((1.258e3-1.185e3)*2+1.185e3,2.6e-4, '$p_3$', 'FontSize', LabelFS, 'Color', 'r')
text((1.258e3-1.185e3)*2+1.185e3,-5.2e-4, '$p_5$', 'FontSize', LabelFS, 'Color', 'r')
text(1.221e3,-5.2e-4, '$p_4$', 'FontSize', LabelFS, 'Color', 'r')
%add = 0.06e3;
% p2
% text(1.14e3 + add,2.6e-4, '(b)', 'FontSize', LabelFS)
% text(1.185e3+add+8,2.6e-4, '$p_2$', 'FontSize', LabelFS, 'Color', 'r')
% 
% % p3
% text(1.14e3 + 2*add+17,2.6e-4, '(c)', 'FontSize', LabelFS)
% text(1.185e3+2*add+17,2.6e-4, '$p_3$', 'FontSize', LabelFS, 'Color', 'r')
% 
% % p4
% text(1.131e3,-5e-4, '(d)', 'FontSize', LabelFS)
% text(1.185e3,-5e-4, '$p_4$', 'FontSize', LabelFS, 'Color', 'r')
% 
% % p6
% text(1.133e3+add+14,-5e-4, '(e)', 'FontSize', LabelFS)
% text(1.185e3+add+8,-5e-4, '$p_6$', 'FontSize', LabelFS, 'Color', 'r')
% 
% % p7
% text(1.14e3 + 2*add+8,-5e-4, '(f)', 'FontSize', LabelFS)
% text(1.185e3+2*add+17,-5e-4, '$p_7$', 'FontSize', LabelFS, 'Color', 'r')

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
set(subplot(3,2,2), 'Position', [xstart+dif+width, ystart+(dify+height), width, height])
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
text(3.82e3,1.5e-4, '(b)', 'FontSize', LabelFS)

%% p3
Pr = 0.2175;
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
set(subplot(3,2,3), 'Position', [xstart+2*(dif+width), ystart+(dify+height), width, height])
%plot(Ra_list, sigma_list, '-ok'), hold on
plot(min(Ra_list):max(Ra_list),p, '-k'), hold on
xlim([2.5e5 2.67e5])
ylim([-6e-3 6e-3])
xticks([2.53e5 2.59e5 2.64e5])
yticks([-6e-3 0 6e-3])
yticklabels(["-6" "0" "6"])
xticklabels(["2.53" "2.59" "2.64"])
text(2.5e5,7e-3,"$\times 10^{-3}$",'FontSize',numFS)
plot([2.35e5 2.8e5], [0 0], 'k--')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$Ra/10^5$','FontSize', LabelFS)
%ylabel('max$[\sigma^o]$','FontSize', LabelFS)
title('$Pr = 0.2175$','FontSize', LabelFS)
text(2.505e5,4.5e-3, '(c)', 'FontSize', LabelFS)
%% p4
width = 0.421;
%dif = ;
set(subplot(3,2,4), 'Position', [xstart, ystart, width, height])
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
ylabel('$\mathcal{I}(\sigma^o)$','FontSize', LabelFS);
title('$Pr = 6.16$','FontSize', LabelFS);
text(0.07,197, '(d)', 'FontSize', LabelFS)
%% p5
set(subplot(3,2,6), 'Position', [xstart + (width+dif), ystart, width, height])
Ra = 3.24e4;
RaS = RatoRaS(Ra);


Pr_list = 8.9:0.01:10.2;
Pr_list2 = [];
sig_list = [];
for i=1:length(Pr_list)
    Pr = round(Pr_list(i),3);
    PrS = PrtoPrS(Pr);
    try
        sigs = Data.AR_2.OneOne152.(PrS).(RaS).sigmaodd;
        [~,I] = max(real(sigs));
        sig_list = [sig_list sigs(I)];
    catch
    end
end
y = min(abs(imag(sig_list))):0.01:max(abs(imag(sig_list)));
p = pchip(abs(imag(sig_list)),real(sig_list),y);
plot(p, y, 'k'), hold on
% make arrows
s = 33;
arrow([p(s) y(s)],[p(s+1) y(s+1)], 'length', 10)
s = 98;
arrow([p(s) y(s)],[p(s+1) y(s+1)], 'length', 10)
plot([0 0], [-1e4 1e4],'--k')
names = ["$9.11$" "$9.53$" "$10$"];
Pr_list = [9.11 9.53 10];
cmap = colormap(winter(length(Pr_list)));
for i=1:length(Pr_list)
   Pr = Pr_list(i);
   PrS = PrtoPrS(Pr);
   sigs = Data.AR_2.OneOne152.(PrS).(RaS).sigmaodd; 
   h(i) = plot(real(sigs),imag(sigs), '*', 'Color',cmap(i,:),'DisplayName', names(i),'MarkerSize',MarkerS-markermin);
end
lgnd = legend(h(1:length(Pr_list)),'Location', 'Bestoutside', 'FontSize', numFS); title(lgnd,'$Pr$', 'FontSize', numFS)
xlim([-0.02 0.04])
ylim([153.5 155.5])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
yticks([153.5 154.5 155.5])
xlabel('$\mathcal{R}(\sigma^o)$','FontSize', LabelFS);
title('$Ra = 3.24 \times 10^4$','FontSize', LabelFS);
text(0.028,155.2, '(e)', 'FontSize', LabelFS)

saveas(gcf,[figpath 'Ppoints.eps'], 'epsc')
% 
