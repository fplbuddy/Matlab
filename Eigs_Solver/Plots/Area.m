%% Get data
run SetUp.m
pathD = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(pathD)
AR = 'AR_2';
types = ["OneOne64" "OneOne88"];

% cleaning up, ie removing the ones that do not have data we want
for i =1:length(types)
    type = types(i);
    PrS_list = string(fieldnames(Data.(AR).(type)));
    for j = 1:length(PrS_list)
        PrS = PrS_list(j);
        RaS_list = string(fieldnames(Data.(AR).(type).(PrS)));
        for k = 1:length(RaS_list)
            RaS = RaS_list(k);
            try
                Data.(AR).(type).(PrS).(RaS).sigmaodd;
            catch
                Data.(AR).(type).(PrS) = rmfield(Data.(AR).(type).(PrS),RaS);
            end
        end
    end
 end

for i =1:length(types)
    type = types(i);
    if i == 1
        PrS_list = string(fieldnames(Data.(AR).(type)));
    else
        PrS_add = string(fieldnames(Data.(AR).(type)));
        for j=1:length(PrS_add)
            PrCheck = PrS_add(j);
            if not(ismember(PrCheck, PrS_list))
                PrS_list = [PrS_list; PrCheck];
            end
        end
    end
 end

% Get first odd crossing
FirstOddCrossRa = [];
FirstOddCrossPr = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    try
    M = GetM(Data, PrS, types, AR,1,1, "odd",0);
    catch
    end
    if not(isempty(M))
       [~,Ra] = GetNextRa(M);
       Pr = PrStoPr(PrS);
       FirstOddCrossRa = [FirstOddCrossRa Ra];
       FirstOddCrossPr = [FirstOddCrossPr Pr];      
    end 
end

FirstOddCrossBackRa = [];
FirstOddCrossBackPr = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    M = GetM(Data, PrS, types, AR,1,2, "odd",0);
    if not(isempty(M))
       [~,Ra] = GetNextRa(M);
       Pr = PrStoPr(PrS);
       FirstOddCrossBackRa = [FirstOddCrossBackRa Ra];
       FirstOddCrossBackPr = [FirstOddCrossBackPr Pr];      
    end 
end

%%
figure('Renderer', 'painters', 'Position', [5 5 700 300])
sp = subplot(1,1, 1);
a = area(FirstOddCrossBackPr,FirstOddCrossBackRa); hold on
a.LineStyle = 'none';
a = area([max(FirstOddCrossBackPr) max(FirstOddCrossPr)], [max(FirstOddCrossBackRa) max(FirstOddCrossBackRa)]);
a.LineStyle = 'none';
a = area(FirstOddCrossPr,FirstOddCrossRa);
a.LineStyle = 'none';
xlim([0.1 100])
%ylim([2e4 max(FirstOddCrossBackRa)])
set(gca,'yscale', 'log')
newcolors = [0 0 1; 0 0 1; 1 1 1];
colororder(newcolors);
xlabel('Pr','FontSize', LabelFS)
ylabel('Ra','FontSize', LabelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
sp.Position(2) = sp.Position(2) + 0.05;
sp.Position(4) = sp.Position(4) - 0.05;
sp.TickLength = [0.02 0.02];
ax.LineWidth = 0.7;
text(15, 2.5e4,'$S$', 'FontSize', TitleFS, 'Color', 'k')
text(15, 1e5,'$US$', 'FontSize', TitleFS, 'Color', 'white')
xticks([1 5 10 15 20 25 30])

% 
% x = [1 5 6 7 8 8 1];
% y = [1e6 4e6 2.74e6 1.97e6 1.5e6 1e7 1e7];
% patch(x,y,'blue','EdgeColor','blue')
% x = [8 8 30 30];
% y = [5e5 1e7 1e7 5e5];
% patch(x,y,'blue','EdgeColor','blue')
