AR = "AR_2";
type_list = ["OneOne400" "OneOne320" "OneOne256" "OneOne152" "OneOne128" "OneOne200" "OneOne172" "OneOne100" "OneOne88" "OneOne64"];
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions');
run SetUp.m
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);

%% cleaning
% above we might want to remove for good
% below are just for this bit
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
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_220000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_230000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_260000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_210000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_800000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_600000");

%%
maxPr = 1e6; % defining some max Pr we consider
minPr = 1e2; % defining some min Pr we consider
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


% for i=1:length(PrS_list)
%     PrS = PrS_list(i);
%     Pr = PrStoPr(PrS);
%     M = GetFullM(Data, PrS, AR,"");
%     PlotData.(PrS).v = CrossingVector(M);
% end


%%
Pr_zonal = [];
Ra_zonal = [];
Pr_nonzonal = [];
Ra_nonzonal = [];

% Do until we change method
PrSChange = "Pr_160000";
PrSChangeloc  = find(PrS_list == PrSChange );
for i=1:PrSChangeloc
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,"");
    v = CrossingVector(M);
    Ra_zonal = [Ra_zonal v];
    Pr_zonal = [Pr_zonal Pr*ones(1,length(v))];
end
% get remaining zonal
for i=PrSChangeloc+1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    try
        A = GetFullMZonal(Data, PrS);
        [~,Ra] = GetNextRaNonLinear(A);
        Ra_zonal = [Ra_zonal Ra];
        Pr_zonal = [Pr_zonal Pr];
    catch
    end
end
% get remaining nonzonal
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    try
        A = GetFullMNonZonal(Data, PrS);
        [~,Ra] = GetNextRaNonLinear(A);
        Ra_nonzonal = [Ra_nonzonal Ra];
        Pr_nonzonal = [Pr_nonzonal Pr];
    catch
    end
end
Ra_nonzonal = [Ra_nonzonal 2.54e7];
Pr_nonzonal = [Pr_nonzonal 1e6];

%% making minimum
Pr_list = [];
Ra_list = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    try
        I =  find(Pr_zonal == Pr);
        zonal = Ra_zonal(I);
    catch
        zonal = 1e8; % some large number
    end
    try
        I =  find(Pr_nonzonal == Pr);
        nonzonal = Ra_nonzonal(I);
    catch
        nonzonal = 1e8; % some large number
    end
    Pr_list = [Pr_list Pr];
    Ra_list = [Ra_list min([nonzonal zonal])];
end


%% Make plot
xstart = 0.08;
width = 0.4;
height = 0.24;
dif = 0.06;
ystart = 0.68;
figure('Renderer', 'painters', 'Position', [5 5 700*1.1 300*1.1])
Pr_list = [1e2 Pr_list 1e6];
Ra_list = [1e8 Ra_list 1e8];

set(subplot(2,2,1), 'Position', [xstart, ystart, width, height])
set(gca, 'Layer', 'top')
patch(Pr_list,Ra_list,'blue','EdgeColor','blue'), hold on
set(gca,'yscale', 'log')
set(gca,'xscale', 'log')
xlabel('$Pr$','FontSize', LabelFS)
ylabel('$Ra$','FontSize', LabelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([100 1e6])
ylim([1e5 1e8])
yticks([1e5 1e6 1e7 1e8])
xticks([1e2 1e3 1e4 1e5 1e6])

% US S
text(2e4, 3e5, '$S$', 'FontSize',LabelFS)
text(2e4, 3e7, '$US$', 'FontSize',LabelFS, 'Color','white')
%text(1.1e2, 1e7, '$Ra \propto Pr^{4/5}$', 'FontSize',LabelFS, 'Color','white')

arrow([4e5 1e7],[7e5 2.45e7],5)
text(4e5*0.9,1e7*0.9, '$k_4$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')

% power law
% law = 4/5;
% Pr1 = 1e2;
% Ra1 = 2e5;
% A = Ra1/Pr1^(law);
% Pr2 = 1e4;
% Ra2 = A*Pr2^(law);
% plot([Pr1 Pr2], [Ra1 Ra2], '--white' , 'LineWidth',2)



%axes('Position',[.6 .35 .3 .3])
%box on
set(subplot(2,2,2), 'Position', [xstart+width+dif, ystart, width, height])
patch(Pr_list,Ra_list,'blue','EdgeColor','blue'), hold on
set(gca, 'Layer', 'top')
plot(Pr_zonal,Ra_zonal, '--r', 'LineWidth',2)
plot(Pr_nonzonal,Ra_nonzonal, '--green', 'LineWidth',2)
set(gca,'yscale', 'log')
set(gca,'xscale', 'log')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([1e5 1e6])
ylim([1.5e7 2.7e7])
xlabel('$Pr$','FontSize', LabelFS)
% make text
text(1.2e5,2.2e7,'$E_{nz}$', 'FontSize', LabelFS, 'Color', 'green' )
text(1.4e5,1.6e7,'$E_{z}$', 'FontSize', LabelFS, 'Color', 'r' )
arrow([4e5 1.8e7],[6.7e5 2.5e7],5)
text(4e5*0.9,1.8e7, '$k_4$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')

%%
ystart =  0.18;
set(subplot(2,2,3), 'Position', [xstart, ystart, width, height])
Pr = 6.7e5;
PrS = PrtoPrS(Pr);
Ra_list = 2.53e7:1e5:2.55e7;
names = ["$2.53$" "$2.54$" "$2.55$"];
marker_list = ['s' 'd' 'p'];
for i=1:length(Ra_list)
    Ra = Ra_list(i);
    RaS = RatoRaS(Ra);
    % plot zonal
    sig = Data.AR_2.OneOne400.(PrS).(RaS).sigmaoddZ;
    plot([real(sig) real(sig)], [imag(sig) -imag(sig)], marker_list(i), 'Color','red','MarkerSize',MarkerS-5, 'MarkerFaceColor', 'r'); hold on
    % plot nonzonal
    sig = Data.AR_2.OneOne400.(PrS).(RaS).sigmaoddNZ;
    plot([real(sig) real(sig)], [imag(sig) -imag(sig)], marker_list(i), 'Color','green','MarkerSize',MarkerS-5, 'MarkerFaceColor', 'g'); hold on; hold on
end

% zero line
plot([0 0], [-7000 7000], 'k--')

% for legend
for i=1:length(Ra_list)
    h(i) = plot(1e5, 1e5, marker_list(i), 'Color','k','MarkerSize',MarkerS-5, 'MarkerFaceColor', 'k','DisplayName', names(i)); hold on; hold on
end
%lgnd = legend(h(1:length(Ra_list)),'Location', 'Bestoutside', 'FontSize', numFS); title(lgnd,'$Ra/10^7$', 'FontSize', numFS)

ylim([-7000 7000])
xlim([-0.5 0.5])
yticks([-7000 0 7000])
yticklabels(["-7" "0" "7"])
xticks([-0.5 0 0.5])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
text(-0.5, 9000, '$\times10^3$', 'Fontsize',numFS)
text(-0.35, 10000, '$(c)$', 'Fontsize',LabelFS)
text(-0.5, 39000, '$(a)$', 'Fontsize',LabelFS)
text(0.8, 39000, '$(b)$', 'Fontsize',LabelFS)
title('$Pr = 6.7 \times 10^5$', 'Fontsize',LabelFS)
ylabel('$\mathcal{I}(\sigma^o)$','FontSize', LabelFS);
xlabel('$\mathcal{R}(\sigma^o)$','FontSize', LabelFS);
text(0.35, 5000, '$E_z$', 'Fontsize',LabelFS, 'Color','r')
text(0.35, 0, '$E_{nz}$', 'Fontsize',LabelFS, 'Color','g')
%%
set(subplot(2,2,4), 'Position', [xstart+width+dif, ystart, width, height])
Pr = 7e5;
PrS = PrtoPrS(Pr);
Ra_list = 2.53e7:1e5:2.55e7;
cmap = colormap(winter(length(Ra_list)));
names = ["$2.53$" "$2.54$" "$2.55$"];
for i=1:length(Ra_list)
    Ra = Ra_list(i);
    RaS = RatoRaS(Ra);
    % plot zonal
    sig = Data.AR_2.OneOne400.(PrS).(RaS).sigmaoddZ;
    plot([real(sig) real(sig)], [imag(sig) -imag(sig)], marker_list(i), 'Color','red','MarkerSize',MarkerS-5, 'MarkerFaceColor', 'r'); hold on
    % plot nonzonal
    sig = Data.AR_2.OneOne400.(PrS).(RaS).sigmaoddNZ;
    plot([real(sig) real(sig)], [imag(sig) -imag(sig)], marker_list(i), 'Color','green','MarkerSize',MarkerS-5, 'MarkerFaceColor', 'g'); hold on; hold on
end

% zero line
plot([0 0], [-7000 7000], 'k--')

% for legend
for i=1:length(Ra_list)
    h(i) = plot(1e5, 1e5, marker_list(i), 'Color','k','MarkerSize',MarkerS-5, 'MarkerFaceColor', 'k','DisplayName', names(i)); hold on; hold on
end
lgnd = legend(h(1:length(Ra_list)),'Location', 'Bestoutside', 'FontSize', numFS); title(lgnd,'$Ra/10^7$', 'FontSize', numFS)
ylim([-7000 7000])
xlim([-0.5 0.5])
yticks([])
xticks([-0.5 0 0.5])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
text(-0.5, 10000, '$(d)$', 'Fontsize',LabelFS)
title('$Pr = 7 \times 10^5$', 'Fontsize',LabelFS)
text(0.35, 5000, '$E_z$', 'Fontsize',LabelFS, 'Color','r')
text(0.35, 0, '$E_{nz}$', 'Fontsize',LabelFS, 'Color','g')

xlabel('$\mathcal{R}(\sigma^o)$','FontSize', LabelFS);


saveas(gcf,[figpath 'LargeBlue.eps'], 'epsc')