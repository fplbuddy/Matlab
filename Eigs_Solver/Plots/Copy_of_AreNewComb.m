%% Load functions
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');

%% Get data
run SetUp.m
pathD = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(pathD)
AR = "AR_2";
type = "OneOne152";

%% Getting all the PrS, will only check 64 and 88
PrS_list = string(fields(Data.(AR).(type)));
PrS_list = RemoveStringDuplicates(PrS_list);
[PrS_list, ~]= OrderPrS_list(PrS_list);
PrS_list(PrS_list == "Pr_100") = [];
PrS_list(PrS_list == "Pr_1000") = [];
Pr_list = [];
Ra_list = [];

for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,type);
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
% loglog(Pr_list, Ra_list,"-o")
Prmin = min(Pr_list); Prmax = max(Pr_list);
figure('Renderer', 'painters', 'Position', [5 5 700 300])
Pr_list = [1e-6 Pr_list 3e4];
Ra_list = [1e7 Ra_list 1e7];
patch(Pr_list,Ra_list,'blue','EdgeColor','blue'), hold on
set(gca,'yscale', 'log')
set(gca,'xscale', 'log')
xlim([Prmin, 0.3])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;

% get hopf
Pr_list = [];
Ra_list = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    try 
    A = hofp(Data, PrS, AR,type);
    [Ra,~] = GetNextHopf(A, 1e-5);
    Ra_list = [Ra_list Ra];
    Pr_list = [Pr_list Pr];
    catch
    end
end
[Ra_list, I] = sort(Ra_list);
Pr_list = Pr_list(I);
plot(Pr_list, Ra_list, 'r--','LineWidth',2)
ylabel('Ra', 'FontSize',numFS);
xlabel('Pr', 'FontSize',numFS);

Pr_list = [0.2 0.2 0.2 7 7 7 10 1e2 1e3 1e4];
Ra_list = [1.63e5 3.32e5 3.35e5 4e4 1e5 2e6 4e4 2e5 7e5 5e6];
plot(Pr_list, Ra_list, 'r*', 'MarkerSize',7)