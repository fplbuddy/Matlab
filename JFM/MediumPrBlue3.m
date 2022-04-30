AR = "AR_2";
type_list = ["OneOne400" "OneOne320" "OneOne256" "OneOne152" "OneOne128" "OneOne200" "OneOne172" "OneOne100" "OneOne88" "OneOne64"];
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions');
run SetUp.m
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);

%% cleaning
Data.AR_2.OneOne152 = rmfield(Data.AR_2.OneOne152, "Pr_0_7");
Data.AR_2.OneOne152 = rmfield(Data.AR_2.OneOne152, "Pr_0_6");
Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_7_6");
Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_7_8");
Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_8_55");
Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_8_53");
Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_8_58");
Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_8_55");
Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_8_53");
Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_8_58");
Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_8_6");
Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_8_61");
% above we might want to remove for good
% below are just for this bit
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_30000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_60000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_100000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_8_59");
Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_01");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_30000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_60000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_100000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_110000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_120000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_130000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_160000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_200000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_210000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_220000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_230000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_260000");


% FOR NOW ONLY
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_5");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_220000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_230000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_260000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_210000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_800000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_600000");

%%
maxPr = 100; % defining some max Pr we consider
minPr = 0.01; % defining some min Pr we consider
PrS_list = [];
for i = 1:length(type_list)
    type = type_list(i);
    try
    PrS_list_inst = string(fields(Data.(AR).(type)));
    PrS_list = [PrS_list; PrS_list_inst];
    catch
    end
end
PrS_list = RemoveStringDuplicatesPr(PrS_list, maxPr, minPr);
[PrS_list, ~]= OrderPrS_list(PrS_list); % Now we have all of our PrS;



%% get crossings

for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,"");
    PlotData.(PrS).v = CrossingVector(M);
end

PrSmax = "Pr_4_9"; % will change 
PrSmin = "Pr_9_53"; 
PrSmaxloc = find(PrS_list == PrSmax);
PrSminloc = find(PrS_list == PrSmin);

%%
Pr_list = [];
Ra_list = [];
% first monotonically increasing bit until PrSmax
for i=1:PrSmaxloc
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,"");
    v = CrossingVector(M);
    Ra_list = [Ra_list v];
    Pr_list = [Pr_list Pr*ones(1,length(v))];
end
[Ra_list, I] = sort(Ra_list);
Pr_list = Pr_list(I);
% monotonically decreasing bit
Pr_listinst = [];
Ra_listinst = [];
for i=PrSmaxloc:PrSminloc
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,"");
    v = CrossingVector(M);
    Ra_listinst = [Ra_listinst v];
    Pr_listinst = [Pr_listinst Pr*ones(1,length(v))];
end
[Ra_listinst, I] = sort(Ra_listinst,'descend');
Pr_listinst = Pr_listinst(I);
Ra_list = [Ra_list Ra_listinst];
Pr_list = [Pr_list Pr_listinst];
% second monotonically increasing bit
Pr_listinst = [];
Ra_listinst = [];
for i=PrSminloc:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,"");
    v = CrossingVector(M);
    Ra_listinst = [Ra_listinst v];
    Pr_listinst = [Pr_listinst Pr*ones(1,length(v))];
end
[Ra_listinst, I] = sort(Ra_listinst);
Pr_listinst = Pr_listinst(I);
Ra_list = [Ra_list Ra_listinst];
Pr_list = [Pr_list Pr_listinst];

%% do zero stuff
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
fpath4 = '/Users/philipwinchester/Dropbox/Matlab/Normal/Functions/';
addpath(fpath)
addpath(fpath2)
addpath(fpath4)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
load(dpath);
RaC = 8*pi^4;


PrS_list = [string(fields(PrZeroData.N_32)); string(fields(PrZeroData.N_64))];
PrS_list(PrS_list == "Pr_2_6e_2") = [];
PrS_list(PrS_list == "Pr_2_5e_2") = [];
PrS_list(PrS_list == "Pr_2_4e_2") = [];
PrS_list(PrS_list == "Pr_2_3e_2") = [];
PrS_list(PrS_list == "Pr_3e_2") = [];
PrS_list(PrS_list == "Pr_1e14") = [];

Pr_list2 = [];
RaA_list2 = [];





for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPrZero(PrS);
    D = GetFullMZero(PrZeroData,PrS);
    RaA_add = GetCrossings(D);
    Pr_add = ones(1,length(RaA_add))*Pr;
    Pr_list2 = [Pr_list2 Pr_add];
    RaA_list2 = [RaA_list2 RaA_add];
end


[RaA_list2, I] = sort(RaA_list2);
Pr_list2 = Pr_list2(I);

%% combining
Pr_list = [Pr_list2 Pr_list];
Ra_list2 = RaA_list2 + RaC;
Ra_list = [Ra_list2 Ra_list];


%% Make plot 
figure('Renderer', 'painters', 'Position', [5 5 850 400])
Pr_list = [1e-6 Pr_list 1e6];
Ra_list = [1e8 Ra_list 1e8];
hej = subplot(2,2,[1,3]);
patch(Pr_list,Ra_list,'blue','EdgeColor','blue'), hold on
set(gca,'yscale', 'log')
set(gca,'xscale', 'log')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([1e-2 1e2])
ylim([700 5e6])
%xlabel('$Pr$','FontSize', LabelFS)
ylabel('$Ra$','FontSize', LabelFS)
text(1,2.5e2, '$Pr$', 'FontSize',LabelFS, 'Color','k', 'HorizontalAlignment', 'center')
text(1,2.5e5, '$S$', 'FontSize',LabelFS, 'Color','k', 'HorizontalAlignment', 'center')
text(1e-1,7e5, '$US$', 'FontSize',LabelFS, 'Color','white', 'HorizontalAlignment', 'center')


% maka red points
p1 = [0.0548 378+RaC];
p2 = [0.0186 3200+RaC];
p3 = [0.217 1e5*(2.42+2.74)/2];
p4 = [0.2 1e5*(3.33+3.34)/2];
p5 = [5 4e6]; % Not accurate yet
p6 = [8.61 1e6*(1.24+1.25)/2];
p7 = [6.17 1e4*(6.02+4.96)/2];
p8 = [8.6 3.26e4]; % Not accurate yet

plot([p1(1) p2(1) p5(1) p6(1) p7(1) p8(1)], [p1(2) p2(2)  p5(2) p6(2) p7(2) p8(2)], '*r', 'MarkerSize',MarkerS)
left = 0.6;
right = 1/left;
down = 0.7;
up = 1/down;
text(p1(1)*right,p1(2), '$p_1$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center')
text(p2(1),p2(2)*down, '$p_2$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(p5(1),p5(2)*down, '$p_5$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(p6(1)*right,p6(2), '$p_6$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(p7(1)*left,p7(2), '$p_7$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(p8(1),p8(2)*down, '$p_8$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
Prl = 1.99e-1;
Pru = 2.18e-1;
Ral = 1.5e5;
Rau = 3.6e5;
plot([Prl Pru], [Ral Ral], '-r')
plot([Prl Pru], [Rau Rau], '-r')
plot([Prl Prl], [Ral Rau], '-r')
plot([Pru Pru], [Ral Rau], '-r')

% make insert
axes('Position',[.25 .2 .2 .17])
box on
patch(Pr_list,Ra_list,'blue','EdgeColor','blue'), hold on
set(gca,'yscale', 'log')
set(gca,'xscale', 'log')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([Prl Pru])
ylim([Ral Rau])
xticks([0.2 0.217])
yticks([2.58e5 3.34e5])
yticklabels(["2.58" "3.34"])
text(0.1995, 3.9e5, '$\times 10^5$', 'FontSize', numFS)
plot([p3(1) p4(1)], [p3(2) p4(2)], '*r', 'MarkerSize',MarkerS)
left = 0.8;
right = 1/left;
down = left;
up = 1/down;
text(p4(1),p4(2)*down, '$p_4$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(p3(1)*0.99,p3(2), '$p_3$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
%
%
subplot(2,2,2)
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
xticks([-0.05 0 0.05 0.1 0.15 0.2])
yticks([-0.4 -0.2 0 0.2 0.4])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$\mathcal{I}(\sigma^o)$','FontSize', LabelFS);
%xlabel('$\mathcal{R}(\sigma^o)$','FontSize', LabelFS);
%
%%
subplot(2,2,4)
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
%%
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
ylabel('$\mathcal{I}(\sigma^o)$','FontSize', LabelFS);
%xlabel('$\mathcal{R}(\sigma^o)$','FontSize', LabelFS);
text(0,-1.5e4, '$\mathcal{R}(\sigma^o)$', 'FontSize',LabelFS, 'Color','k', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(0.3,1.1e4, '$Pr = 8.58$', 'FontSize',numFS, 'Color','k', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(0.15,1.1e4, '$p_4$', 'FontSize',numFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(0.3,3.9e4, '$Pr = 0.2$', 'FontSize',numFS, 'Color','k', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(0.15,3.9e4, '$p_6$', 'FontSize',numFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')



%% make final plot


saveas(gcf,[figpath 'MediumBlue.eps'], 'epsc')
