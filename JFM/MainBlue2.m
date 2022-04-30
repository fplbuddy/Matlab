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
%Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_5");
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


PrS_list = [string(fields(PrZeroData.G_2.N_32)); string(fields(PrZeroData.G_2.N_64))];
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
    D = GetFullMZero(PrZeroData,"G_2",PrS,"Odd",["N_32" "N_64"]);
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

%% now add large Pr stuff
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
[PrS_list] = OrderPrS_list(PrS_list); % Now we have all of our PrS;


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
Pr_list2 = [];
Ra_list2 = [];
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
    Pr_list2 = [Pr_list2 Pr];
    if length(min([nonzonal zonal])) == 0
        Pr
        PrS
    end
    Ra_list2 = [Ra_list2 min([nonzonal zonal])];
end

%% combining
Pr_list = [Pr_list Pr_list2];
Ra_list = [Ra_list Ra_list2];

%% Make plot 
figure('Renderer', 'painters', 'Position', [5 5 850 350])
set(gca, 'Layer', 'top')
Pr_list = [1e-6 Pr_list 1e6];
Ra_list = [1e8 Ra_list 1e8];
patch(Pr_list,Ra_list,'blue','EdgeColor','blue'), hold on
patch([1e-6 1e6 1e6 1e-6],[400 400 RaC RaC],'red','EdgeColor','red','FaceAlpha', 0.3,'EdgeAlpha', 0.3)
set(gca,'yscale', 'log')
set(gca,'xscale', 'log')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([1e-6 1e6])
ylim([400 1e8])
xlabel('$Pr$','FontSize', LabelFS)
ylabel('$Ra$','FontSize', LabelFS)
%text(1,2.5e2, '$Pr$', 'FontSize',LabelFS, 'Color','k', 'HorizontalAlignment', 'center')
text(1,2.5e5, '$S$', 'FontSize',LabelFS, 'Color','k', 'HorizontalAlignment', 'center')
text(1e-1,1e7, '$US$', 'FontSize',LabelFS, 'Color','white', 'HorizontalAlignment', 'center')
yticks([RaC 1e4 1e5 1e6 1e7 1e8])
yticklabels({'$Ra_c$' '$10^4$' '$10^5$' '$10^6$' '$10^7$' '$10^8$'})
xticks([1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1 10 1e2 1e3 1e4 1e5 1e6])

% Make Rac
plot([1e-6 2e-1], [RaC RaC], 'k--', 'LineWidth',1)
%text(4e-1 ,RaC, '$Ra_c$', 'FontSize',LabelFS, 'Color','k', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')


% maka red points
p1 = [0.0548 378+RaC];
p2 = [0.0186 3200+RaC];
p3 = [0.2175 1e5*(2.42+2.74)/2];
p4 = [0.2 1e5*(3.33+3.34)/2];
p5 = [5 4e6]; % Not accurate yet
p6 = [8.61 1e6*(1.24+1.25)/2];
p7 = [6.17 1e4*(6.02+4.96)/2];
p8 = [8.6 3.26e4]; % Not accurate yet

plot([p1(1) p2(1) p5(1) p6(1) p7(1) p8(1)], [p1(2) p2(2)  p5(2) p6(2) p7(2) p8(2)], '*r', 'MarkerSize',MarkerS)
left = 0.5;
right = 1/left;
down = 0.6;
up = 1/down;
text(p1(1)*right,p1(2), '$p_1$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center')
text(p2(1),p2(2)*down, '$p_2$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(p5(1),p5(2)*down, '$q_2$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(p6(1)*right,p6(2), '$q_3$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(p7(1)*left,p7(2), '$p_4$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(p8(1),p8(2)*down, '$p_5$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
arrow([4e5 1e7],[7e5 2.45e7],5)
text(4e5*0.9,1e7*0.9, '$q_4$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')


Prl = 1.99e-1;
Pru = 2.18e-1;
Ral = 1.5e5;
Rau = 3.6e5;
% plot([Prl Pru], [Ral Ral], '-r','LineWidth',1)
% plot([Prl Pru], [Rau Rau], '-r','LineWidth',1)
% plot([Prl Prl], [Ral Rau], '-r','LineWidth',1)
% plot([Pru Pru], [Ral Rau], '-r','LineWidth',1)
plot([Prl 5.2e-3],[Ral 2.25e3], '-r')
plot([Prl 5.2e-3],[Rau 1.6e7], '-r')

% make insert
axes('Position',[.18 .26 .19 .55])
col = [0 0 0];
set(gca,'xcolor','r') 
set(gca,'ycolor','r') 
box on
patch(Pr_list,Ra_list,'blue','EdgeColor','blue'), hold on
set(gca, 'Layer', 'top')
set(gca,'yscale', 'log')
set(gca,'xscale', 'log')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([Prl Pru])
ylim([Ral Rau])
xticks([0.2 0.2175])
yticks([2.58e5 3.34e5])
yticklabels(["2.58" "3.34"])
text(0.1995, 3.9e5, '$\times 10^5$', 'FontSize', numFS, 'color','r')
plot([p3(1) p4(1)], [p3(2) p4(2)], '*r', 'MarkerSize',MarkerS)
left = 0.9;
right = 1/left;
down = left;
up = 1/down;
text(p4(1),p4(2)*down, '$q_1$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(p3(1)*0.99,p3(2), '$p_3$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
%
%
%% make final plot


%saveas(gcf,[figpath 'MainBlue.eps'], 'epsc')
