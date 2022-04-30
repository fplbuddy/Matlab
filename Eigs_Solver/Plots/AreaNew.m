%% Load functions
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');

%% Get data
run SetUp.m
pathD = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(pathD)
AR = "AR_2";

%% Clean data, will probably remove later
if isfield(Data.AR_2.OneOne88.Pr_8,"Ra_3e5")
   Data.AR_2.OneOne88.Pr_8  = rmfield(Data.AR_2.OneOne88.Pr_8,"Ra_3e5");
end
if isfield(Data.AR_2.OneOne172.Pr_8,"Ra_2_83e6")
   Data.AR_2.OneOne172.Pr_8  = rmfield(Data.AR_2.OneOne172.Pr_8,"Ra_2_83e6");
end
if isfield(Data.AR_2.OneOne64.Pr_0_4,"Ra_3e5")
   Data.AR_2.OneOne64.Pr_0_4  = rmfield(Data.AR_2.OneOne64.Pr_0_4,"Ra_3e5");
end

%% Getting all the PrS, will only check 64 and 88
types_list = ["OneOne64" "OneOne88" "OneOne100"];
PrS_list = [];
for i = 1:length(types_list)
    type = types_list(i);
    PrS_list_inst = string(fields(Data.(AR).(type)));
    PrS_list = [PrS_list; PrS_list_inst];
end
PrS_list = RemoveStringDuplicates(PrS_list);
[PrS_list, ~]= OrderPrS_list(PrS_list);

% Some extra ones I want to remove
PrS_list(PrS_list == "Pr_5_5") = [];
PrS_list(PrS_list == "Pr_4_5") = [];
PrS_list(PrS_list == "Pr_7_6") = [];
PrS_list(PrS_list == "Pr_7_8") = [];
PrS_list(PrS_list == "Pr_8_53") = [];
PrS_list(PrS_list == "Pr_8_55") = [];
PrS_list(PrS_list == "Pr_8_58") = [];
PrS_list(PrS_list == "Pr_100000") = [];
PrS_list(PrS_list == "Pr_6000") = [];
PrS_list(PrS_list == "Pr_200000") = [];
PrS_list(PrS_list == "Pr_300000") = [];
PrS_list(PrS_list == "Pr_600000") = [];
PrS_list(PrS_list == "Pr_1000000") = [];

PrS_list(PrS_list == "Pr_20000") = [];
PrS_list(PrS_list == "Pr_30000") = [];
PrS_list(PrS_list == "Pr_60000") = [];

for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR);
    PlotData.(PrS).v = CrossingVector(M);
%      if length(PlotData.(PrS).v)>1 && not(exist('PrSStart','var'))
%          PrSStart = PrS;
%      end
%     if exist('PrSStart','var') && length(PlotData.(PrS).v) < 3 && not(exist('PrSEnd','var'))
%         PrSEnd = PrSOld;
%     end  
%     PrSOld = PrS;
end
PrSEnd = "Pr_8_61";
PrSStart = "Pr_6_17";
PrSEndloc = find(PrS_list == PrSEnd);
PrSStartloc = find(PrS_list == PrSStart);

%% 
Pr_list1 = [];
Ra_list1 = [];
% Get first top line, 1 or 3
for i=1:PrSEndloc
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

%% Get power law in Pr -> inf limit
Pr_power = Pr_list1;
Ra_power = Ra_list1;
Ra_power(Pr_power > 1e4) = [];
Pr_power(Pr_power > 1e4) = [];
Ra_power(Pr_power < 2e2) = [];
Pr_power(Pr_power < 2e2) = [];

[alpha, ~, ~, ~, ~] = FitsPowerLaw(Pr_power,Ra_power);


%% Make plot
figure('Renderer', 'painters', 'Position', [5 5 700 300])
Pr_list1 = [0.1 Pr_list1 10000];
Ra_list1 = [1e7 Ra_list1 1e7];
patch(Pr_list1,Ra_list1,'blue','EdgeColor','blue')
set(gca,'yscale', 'log')
set(gca,'xscale', 'log')
xlabel('Pr','FontSize', LabelFS)
ylabel('Ra','FontSize', LabelFS)
title('$\Gamma =2$','FontSize', LabelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([1e-1 1e4])
hold on
% power
x1 = 1e2;
x2 = 1e4;
y1 = 2e5;
alpha = 0.809;
y2 = y1*(x2/x1)^alpha;
plot([x1 x2], [y1 y2], 'white--', 'LineWidth',3)
text(1e2, 2e6, 'Ra $\propto$ Pr$^{0.809}$', 'color','white', 'fontsize', LabelFS)


