run SetUp.m
AR = "AR_2";
type_list = ["OneOne400" "OneOne320" "OneOne256" "OneOne152" "OneOne128" "OneOne200" "OneOne172" "OneOne100" "OneOne88" "OneOne64"];
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions');
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);

%% cleaning

% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_1");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_0_1");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_1");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_2");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_0_2");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_2");
% Data.AR_2.OneOne128 = rmfield(Data.AR_2.OneOne128, "Pr_0_3");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_3");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_0_3");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_3");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_4");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_0_4");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_4");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_5");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_6");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_0_6");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_6");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_0_7");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_7");
% Data.AR_2.OneOne152 = rmfield(Data.AR_2.OneOne152, "Pr_0_8");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_0_8");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_8");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_9");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_0_9");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_9");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_1");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_1");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_2");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_2");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_3");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_3");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_4");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_4");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_5");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_5");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_6");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_6");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_7");
% Data.AR_2.OneOne152 = rmfield(Data.AR_2.OneOne152, "Pr_7");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_8");
% Data.AR_2.OneOne200 = rmfield(Data.AR_2.OneOne200, "Pr_30000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_30000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_60000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_100000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_200000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_300000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_600000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_1000000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_31");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_311");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_312");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_313");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_314");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_315");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_319");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_32");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_33");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_35");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_38");
% Data.AR_2.OneOne172 = rmfield(Data.AR_2.OneOne172, "Pr_0_8");
% Data.AR_2.OneOne172 = rmfield(Data.AR_2.OneOne172, "Pr_0_9");
% Data.AR_2.OneOne172 = rmfield(Data.AR_2.OneOne172, "Pr_1");
% Data.AR_2.OneOne172 = rmfield(Data.AR_2.OneOne172, "Pr_60000");
% Data.AR_2.OneOne172 = rmfield(Data.AR_2.OneOne172, "Pr_30000");
% Data.AR_2.OneOne172 = rmfield(Data.AR_2.OneOne172, "Pr_20000");
% Data.AR_2.OneOne172 = rmfield(Data.AR_2.OneOne172, "Pr_10000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_20000");
% 
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_100000000");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_10000000000");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_100000000000");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_1000000000000");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_10000000000000");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_100000000000000");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_1000000000000000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_10_317");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_6000");
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
% above we might want to remove for good
% below are just for this bit
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_30000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_60000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_100000");


% FOR NOW ONLY
%%
PrS_list = [];
for i = 1:length(type_list)
    type = type_list(i);
    try
    PrS_list_inst = string(fields(Data.(AR).(type)));
    PrS_list = [PrS_list; PrS_list_inst];
    catch
    end
end
PrS_list = RemoveStringDuplicates(PrS_list);
[PrS_list, ~]= OrderPrS_list(PrS_list); % Now we have all of our PrS;

%% checking duplicates
% for i=1:length(PrS_list)
%     PrS = PrS_list(i);
%     types = [];
%     for j=1:length(type_list)
%         type = type_list(j);
%         try
%         if isfield(Data.(AR).(type), PrS)
%             types = [types type];
%         end
%         catch
%         end
%     end
%     if length(types) > 1
%        PrS 
%        types
%     end  
% end


%% get crossings

for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,"");
    PlotData.(PrS).v = CrossingVector(M);
end
PrSEnd = "Pr_8_61";
PrSStart = "Pr_6_17";
PrLower = "Pr_1";
PrSEndloc = find(PrS_list == PrSEnd);
PrSStartloc = find(PrS_list == PrSStart);
PrLowerloc = find(PrS_list == PrLower);


%% 
Pr_list1 = [];
Ra_list1 = [];
% fist weird bit
for i=1:PrLowerloc
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,"");
    v = CrossingVector(M);
    Ra_list1 = [Ra_list1 v];
    if length(v) == 3
        Pr_list1 = [Pr_list1 Pr*ones(1,3)];
    elseif length(v) == 1
       Pr_list1 = [Pr_list1 Pr*ones(1,1)]; 
    elseif isempty(v)
        continue
    else
        error
    end 
end
[Ra_list1, I] = sort(Ra_list1);
Pr_list1 = Pr_list1(I);

% Get first top line, 1 or 3
for i=PrLowerloc:PrSEndloc
    PrS = PrS_list(i);
    v =  PlotData.(PrS).v;
    if length(v) == 3 || length(v) == 1
        Pr = PrStoPr(PrS);
        Ra = v(end);
        Pr_list1 = [Pr_list1 Pr];
        Ra_list1 = [Ra_list1 Ra];
    end
end
% Getting intermidiate
for i=PrSEndloc:-1:PrSStartloc
    PrS = PrS_list(i);
    v =  PlotData.(PrS).v;
    if length(v) == 3 || length(v) == 2
        Pr = PrStoPr(PrS);
        Ra = v(2);
        Pr_list1 = [Pr_list1 Pr];
        Ra_list1 = [Ra_list1 Ra];
    end
    
end
% Getting end
for i=PrSStartloc:length(PrS_list)
    PrS = PrS_list(i);
    v =  PlotData.(PrS).v;
    Pr = PrStoPr(PrS);
    Ra = v(1);
    Pr_list1 = [Pr_list1 Pr];
    Ra_list1 = [Ra_list1 Ra];  
end

%%
% check = PrS_list(8:53);
% type_check = ["OneOne200" "OneOne172" "OneOne100" "OneOne88" "OneOne64"];
% for i=1:length(check)
%     PrS = check(i);
%     types = [];
%     for j=1:length(type_check)
%         type = type_check(j);
%         if isfield(Data.(AR).(type), PrS)
%              types = [types type];
%         end
%      end
%      if ~isempty(types)
%         PrS 
%         types
%      end 
%         
% end

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
Pr_list = [Pr_list2 Pr_list1];
RaA_list = [RaA_list2 Ra_list1-RaC];

%% make plot
figure('Renderer', 'painters', 'Position', [5 5 700 300])
xlim([1e-4 1e-1])
ylim([1e-4 1e5])
Pr_list = [1e-4 Pr_list 1e-1];
RaA_list = [1e5 RaA_list 1e5];
patch(Pr_list,RaA_list,'blue','EdgeColor','blue')
set(gca,'yscale', 'log')
set(gca,'xscale', 'log')
xlabel('$Pr$','FontSize', LabelFS)
ylabel('$\delta Ra$','FontSize', LabelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
yticks([1e-4 1e-2 1 1e2 1e4])
hold on

% other fig points
p1 = 10.7;
p2 = 2.2e3;
plot([1e-2 1e-2], [p1 p2],'white*', 'Markersize', MarkerS-5)
text(1e-2*0.65,p1,'(b)', 'FontSize',numFS, 'Color', 'white')
text(1e-2*0.65,p2,'(c)', 'FontSize',numFS, 'Color', 'white')


% make power law
% Pr1 = 2e-4;
% Pr2 = 3e-3;
% RaA1 =  1e-2;
% A = RaA1/Pr1^2;
% RaA2 = A*Pr2^2;
% plot([Pr1 Pr2], [RaA1 RaA2], '--white', 'linewidth', 2)
Pr1 = 1e-4;
Pr2 = 5e-3;
A = 6.35e4;
RaA1 = A*Pr1^2;
RaA2 = A*Pr2^2;
plot([Pr1 Pr2], [RaA1 RaA2], '--red', 'linewidth', 2)

% points
p1 = [0.0548 378];
p2 = [0.0186 3200];
plot([p1(1) p2(1)], [p1(2) p2(2)], '*r', 'MarkerSize',MarkerS)

% text
%text(3e-4, 1, '$\delta Ra \propto Pr^2$', 'FontSize',LabelFS, 'Color','white')
text(1.1e-4, 1, '$\delta Ra = 6.35 \times 10^4 Pr^2$', 'FontSize',LabelFS, 'Color','red')
text(3e-4, 2e3, '$US$', 'FontSize',LabelFS, 'Color','white')
text(3e-4, 4e-4, '$S$', 'FontSize',LabelFS, 'Color','black')
text(p1(1)+0.01, p1(2), '$p_1$', 'FontSize',LabelFS, 'Color','r')
text(p2(1)-0.006, p2(2), '$p_2$', 'FontSize',LabelFS, 'Color','r')
text(0.06, 4e-4, '$\mathcal{R}(\sigma^m)$', 'FontSize',LabelFS-5, 'Color','k')
RaA2_list = [6 6.13 6.14 6.25];
cmap = colormap(winter(length(RaA2_list)));
h = zeros(1,length(RaA2_list));
for i=1:length(RaA2_list)
    RaA = RaA2_list(i);
    h(i) = plot(1e10, 1e10, '*', 'Color',cmap(length(RaA2_list)-i+1,:),'DisplayName', num2str(RaA),'MarkerSize',MarkerS); hold on
end
lgnd = legend(h,'Location', 'northeastoutside', 'FontSize', numFS); title(lgnd,'$\delta Ra$', 'FontSize', numFS)
% insert
type = 'N_32';
PrS = 'Pr_1e_2';
%RaAS_list = string(fields(PrZeroData.(type).(PrS)));
%[RaAS_list_order, ~]= OrderRaAS_list(RaAS_list);
set(0,'DefaultFigureColormap',feval('winter'));
axes('Position',[.72 .32 .2 .17])
box on
for i=1:length(RaA2_list)
    RaA = RaA2_list(i);
    RaAS = RaAtoRaAS(RaA);
    sigma = PrZeroData.(type).(PrS).(RaAS).sigmaodd;
    plot(real(sigma), imag(sigma), '*', 'Color',cmap(length(RaA2_list)-i+1,:),'DisplayName', num2str(RaA),'MarkerSize',MarkerS); hold on
    xlim([-5e-4 5e-4]) 
    ylim([-4e-4 4e-4]) 
end
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
%xlabel('$\mathcal{R}(\sigma^o)$','FontSize', LabelFS-5)
ylabel('$\mathcal{I}(\sigma^m)$','FontSize', LabelFS-5)
yticks([-4e-4 0 4e-4])
xticks([-4e-4 0 4e-4])
% black line
plot([max(real(PrZeroData.N_32.Pr_1e_2.RaA_6e0.sigmaodd)) max(real(PrZeroData.N_32.Pr_1e_2.RaA_6_25e0.sigmaodd))], [0 0], 'k')
% arrows
p1 = [-3e-4 0];                         % First Point
p2 = [-2e-4 0];                         % Second Point
arrow(p1,p2,'Length',10)
p1 = [1e-4 0];                         % First Point
p2 = [2e-4 0];                         % Second Point
arrow(p1,p2,'Length',10)


saveas(gcf,[figpath 'SmallPr.eps'], 'epsc')
