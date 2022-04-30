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
PrS_list(PrS_list == "Pr_10_317") = [];
PrS_list(PrS_list == "Pr_100000000") = [];
PrS_list(PrS_list == "Pr_10000000000") = [];
PrS_list(PrS_list == "Pr_100000000000") = [];
PrS_list(PrS_list == "Pr_1000000000000") = [];
PrS_list(PrS_list == "Pr_10000000000000") = [];
PrS_list(PrS_list == "Pr_100000000000000") = [];
PrS_list(PrS_list == "Pr_1000000000000000") = [];

PrS_list(PrS_list == "Pr_60000") = [];

PrS_list(PrS_list == "Pr_0_7") = [];
PrS_list(PrS_list == "Pr_0_8") = [];
PrS_list(PrS_list == "Pr_0_4") = [];
PrS_list(PrS_list == "Pr_0_35") = [];
PrS_list(PrS_list == "Pr_0_38") = [];
PrS_list(PrS_list == "Pr_0_32") = [];
PrS_list(PrS_list == "Pr_0_315") = [];
PrS_list(PrS_list == "Pr_0_319") = [];
PrS_list(PrS_list == "Pr_0_313") = [];

for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,"");
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



%% Pr -> 0


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
Ra_list2 = RaA_list2 + RaC;
Ra_list = [Ra_list2 Ra_list1];

%% Make plot
figure('Renderer', 'painters', 'Position', [5 5 700 300])
Pr_list = [1e-6 Pr_list 3e4];
Ra_list = [1e7 Ra_list 1e7];
patch(Pr_list,Ra_list,'blue','EdgeColor','blue')
set(gca,'yscale', 'log')
set(gca,'xscale', 'log')
xlabel('Pr','FontSize', LabelFS)
ylabel('Ra','FontSize', LabelFS)
title('$\Gamma =2$','FontSize', LabelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([1e-4 3e4])
hold on

%% Some dots
Pr_list = [0.2 0.2 0.2 7 7 7 10 1e2 1e3 1e4];
Ra_list = [1.63e5 3.32e5 3.35e5 4e4 1e5 2e6 4e4 2e5 7e5 5e6];
plot(Pr_list, Ra_list, 'r*', 'MarkerSize',7)

%% power
x1 = 1e2;
x2 = 1e4;
y1 = 2e5;
alpha = 4/5;
y2 = y1*(x2/x1)^alpha;
plot([x1 x2], [y1 y2], 'white--', 'LineWidth',3)
text(2e1, 2e6, 'Ra $\propto$ Pr$^{4/5}$', 'color','white', 'fontsize', LabelFS)
ylim([1e2 1e7])

%% plot RaC
plot([1e-4 1e-1], [RaC RaC], 'k--', 'LineWidth',1)
text(1.5e-1,RaC, 'Ra$_c = 8\pi^4$', 'color','k', 'fontsize', LabelFS)

