AR = "AR_2";
type_list = ["OneOne400" "OneOne320" "OneOne256" "OneOne152" "OneOne128" "OneOne200" "OneOne172" "OneOne100" "OneOne88" "OneOne64"];
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions');
run SetUp.m
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
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_8_58");


% FOR NOW ONLY
% Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_4_6");
% Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_4_7");
% Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_4_8");
% Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_4_9");
% Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_5_1");
% Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_5_2");
% Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_5_3");
% Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_5_4");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_210000");

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
Pr_list = [];
Ra_list = [];
% fist weird bit
for i=1:PrLowerloc
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,"");
    v = CrossingVector(M);
    Ra_list = [Ra_list v];
    if length(v) == 3
        Pr_list = [Pr_list Pr*ones(1,3)];
    elseif length(v) == 1
       Pr_list = [Pr_list Pr*ones(1,1)]; 
    elseif isempty(v)
        continue
    else
        error
    end 
end
[Ra_list, I] = sort(Ra_list);
Pr_list = Pr_list(I);

% Get first top line, 1 or 3
for i=PrLowerloc:PrSEndloc
    PrS = PrS_list(i);
    v =  PlotData.(PrS).v;
    if length(v) == 3 || length(v) == 1
        Pr = PrStoPr(PrS);
        Ra = v(end);
        Pr_list = [Pr_list Pr];
        Ra_list = [Ra_list Ra];
    end
end
% Getting intermidiate
for i=PrSEndloc:-1:PrSStartloc
    PrS = PrS_list(i);
    v =  PlotData.(PrS).v;
    if length(v) == 3 || length(v) == 2
        Pr = PrStoPr(PrS);
        Ra = v(2);
        Pr_list = [Pr_list Pr];
        Ra_list = [Ra_list Ra];
    end
    
end
% Getting end
for i=PrSStartloc:length(PrS_list)
    PrS = PrS_list(i);
    v =  PlotData.(PrS).v;
    Pr = PrStoPr(PrS);
    Ra = v(1);
    Pr_list = [Pr_list Pr];
    Ra_list = [Ra_list Ra];  
end


%% Make plot 
figure('Renderer', 'painters', 'Position', [5 5 700 300])
Pr_list = [1e-6 Pr_list 1e6];
Ra_list = [1e8 Ra_list 1e8];
hej = subplot(1,3,[1,2]);
patch(Pr_list,Ra_list,'blue','EdgeColor','blue'), hold on
set(gca,'yscale', 'log')
set(gca,'xscale', 'log')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([1e-1 1e2])
ylim([1e4 5e6])
xlabel('$Pr$','FontSize', LabelFS)
ylabel('$Ra$','FontSize', LabelFS)

% maka red points
p3 = [0.217 1e5*(2.42+2.74)/2];
p4 = [0.2 1e5*(3.33+3.34)/2];
p5 = [5 4e6]; % Not accurate yet
p6 = [8.61 1e6*(1.24+1.25)/2];
p7 = [6.17 1e4*(6.02+4.96)/2];
p8 = [8.6 3.26e4]; % Not accurate yet

plot([p3(1) p4(1) p5(1) p6(1) p7(1) p8(1)], [p3(2) p4(2) p5(2) p6(2) p7(2) p8(2)], '*r', 'MarkerSize',MarkerS)
left = 0.7;
right = 1/left;
down = 0.7;
up = 1/down;
text(p3(1)*right,p3(2), '$p_3$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center')
text(p4(1)*left,p4(2), '$p_4$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(p5(1),p5(2)*down, '$p_5$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(p6(1)*right,p6(2), '$p_6$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(p7(1)*left,p7(2), '$p_7$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
text(p8(1),p8(2)*down, '$p_8$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')

text(0.11, 7e6, '(a)', 'FontSize', LabelFS)
text(3e3, 7e6, '(b)', 'FontSize', LabelFS)




% plot other box
Prl = 1.99e-1;
Pru = 2.18e-1;
Ral = 1.5e5;
Rau = 3.6e5;
% plot([Prl Pru], [Ral Ral], '-k')
% plot([Prl Pru], [Rau Rau], '-k')
% plot([Prl Prl], [Ral Rau], '-k')
% plot([Pru Pru], [Ral Rau], '-k')
hej.Position(2) = hej.Position(2) + 0.06;
hej.Position(4) = hej.Position(4) - 0.06;

subplot(1,3,3)
%axes('Position',[.42 .25 .15 .42])
%box on
patch(Pr_list,Ra_list,'blue','EdgeColor','blue'), hold on
%set(gca,'yscale', 'log')
%set(gca,'xscale', 'log')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([Prl Pru])
ylim([Ral Rau])

% get hopf
Pr_listh = [];
Ra_listh = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    try 
    A = hofp(Data, PrS, AR,"OneOne152");
    [Ra,~] = GetNextHopf(A, 1e-5);
    if length(Ra) == 1
        Ra_listh = [Ra_listh Ra];
        Pr_listh = [Pr_listh Pr];
    end
    catch
    end
end
[Ra_listh, I] = sort(Ra_listh);
Pr_listh = Pr_listh(I);
plot(Pr_listh, Ra_listh, '--r','LineWidth',3)
xticks([0.2 0.217])
yticks([2.58e5 3.34e5])
yticklabels(["2.58" "3.34"])

% lower
Pr_l = Pr_list;
Ra_l = Ra_list;
Pr_l(Ra_l > 2.58e5 | Ra_l < 1.5e5) = [];
Ra_l(Ra_l > 2.58e5 | Ra_l < 1.5e5) = [];
Ra_l(Pr_l > 2.18e-1 | Pr_l < 1.9e-1) = [];
Pr_l(Pr_l > 2.18e-1 | Pr_l < 1.9e-1) = [];
plot([Pr_l 0.217], [Ra_l 2.58e5], '--','LineWidth',3,'Color', [0 0.7 0.4])

% midele
Pr_l = Pr_list;
Ra_l = Ra_list;
Pr_l(Ra_l > 3.35e5 | Ra_l < 2.58e5) = [];
Ra_l(Ra_l > 3.35e5 | Ra_l < 2.58e5) = [];
Ra_l(Pr_l > 2.18e-1 | Pr_l < 1.9e-1) = [];
Pr_l(Pr_l > 2.18e-1 | Pr_l < 1.9e-1) = [];
plot([0.217 Pr_l], [2.58e5 Ra_l], '--','LineWidth',3,  'Color', [139/255 69/255 19/255])

% upper
Pr_l = Pr_list;
Ra_l = Ra_list;
Pr_l(Ra_l > 3.6e5 | Ra_l < 3.35e5) = [];
Ra_l(Ra_l > 3.6e5 | Ra_l < 3.35e5) = [];
Ra_l(Pr_l > 2.18e-1 | Pr_l < 1.9e-1) = [];
Pr_l(Pr_l > 2.18e-1 | Pr_l < 1.9e-1) = [];
plot([0.2 Pr_l], [3.35e5 Ra_l], '--','LineWidth',3, 'Color', [199/255,21/255,133/255])
xlabel('$Pr$','FontSize', LabelFS)
%ylabel('$Ra$','FontSize', LabelFS)

text(0.1995, 3.7e5, '$\times 10^5$', 'FontSize', numFS)
text(0.22, 3.5e5, '$Ra_e$', 'FontSize', LabelFS, 'Color', [199/255,21/255,133/255])
text(0.22, 3.25e5, '$Ra_d$', 'FontSize', LabelFS, 'Color', 'r')
text(0.22, 3.0e5, '$Ra_c$', 'FontSize', LabelFS, 'Color', [139/255 69/255 19/255])
text(0.22, 2.75e5, '$Ra_a$', 'FontSize', LabelFS, 'Color', [0 0.7 0.4])

saveas(gcf,[figpath 'ModeratBlue.eps'], 'epsc')
