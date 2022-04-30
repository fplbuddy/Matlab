%% Get data
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Cluster_v2/Functions/';
addpath(fpath)
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
pathD = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(pathD)
AR = 'AR_2';
types = ["OneOne64" "OneOne88"];
for i =1:length(types)
    type = types(i);
    if i == 1
        PrS_list = string(fieldnames(Data.(AR).(type)));
    else
        PrS_add = string(fieldnames(Data.(AR).(type)));
        for j=1:length(PrS_add)
            PrCheck = PrS_add(j);
            if not(ismember(PrCheck, PrS_list))
                PrS_list = [PrS_list PrCheck];
            end
        end
    end
 end

% Get first odd crossing
FirstOddCrossRa = [];
FirstOddCrossPr = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    M = GetM(Data, PrS, types, AR,1,1, "odd");
    if not(isempty(M))
       [~,Ra] = GetNextRa(M);
       Pr = PrStoPr(PrS);
       FirstOddCrossRa = [FirstOddCrossRa Ra];
       FirstOddCrossPr = [FirstOddCrossPr Pr];      
    end 
end

SecondOddCrossRa = [];
SecondOddCrossPr = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    M = GetM(Data, PrS, types, AR,3,1,"odd");
    if not(isempty(M))
       [~,Ra] = GetNextRa(M);
       Pr = PrStoPr(PrS);
       SecondOddCrossRa = [SecondOddCrossRa Ra];
       SecondOddCrossPr = [SecondOddCrossPr Pr];      
    end 
end

SecondOddCrossBackRa = [];
SecondOddCrossBackPr = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    M = GetM(Data, PrS, types, AR,3,2, "odd");
    if not(isempty(M))
       [~,Ra] = GetNextRa(M);
       Pr = PrStoPr(PrS);
       SecondOddCrossBackRa = [SecondOddCrossBackRa Ra];
       SecondOddCrossBackPr = [SecondOddCrossBackPr Pr];      
    end 
end

FirstOddCrossBackRa = [];
FirstOddCrossBackPr = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    M = GetM(Data, PrS, types, AR,1,2, "odd");
    if not(isempty(M))
       [~,Ra] = GetNextRa(M);
       Pr = PrStoPr(PrS);
       FirstOddCrossBackRa = [FirstOddCrossBackRa Ra];
       FirstOddCrossBackPr = [FirstOddCrossBackPr Pr];      
    end 
end

FirstEvenCrossRa = [];
FirstEvenCrossPr = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    M = GetM(Data, PrS, types, AR,1,1, "even");
    if not(isempty(M))
       [~,Ra] = GetNextRa(M);
       Pr = PrStoPr(PrS);
       FirstEvenCrossRa = [FirstEvenCrossRa Ra];
       FirstEvenCrossPr = [FirstEvenCrossPr Pr];      
    end 
end

SecondEvenCrossRa = [];
SecondEvenCrossPr = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    M = GetM(Data, PrS, types, AR,3,1, "even");
    if not(isempty(M))
       [~,Ra] = GetNextRa(M);
       Pr = PrStoPr(PrS);
       SecondEvenCrossRa = [SecondEvenCrossRa Ra];
       SecondEvenCrossPr = [SecondEvenCrossPr Pr];      
    end 
end

SecondEvenCrossBackRa = [];
SecondEvenCrossBackPr = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    M = GetM(Data, PrS, types, AR,3,2, "even");
    if not(isempty(M))
       [~,Ra] = GetNextRa(M);
       Pr = PrStoPr(PrS);
       SecondEvenCrossBackRa = [SecondEvenCrossBackRa Ra];
       SecondEvenCrossBackPr = [SecondEvenCrossBackPr Pr];      
    end 
end

FirstEvenCrossBackRa = [];
FirstEvenCrossBackPr = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    M = GetM(Data, PrS, types, AR,1,2, "even");
    if not(isempty(M))
       [~,Ra] = GetNextRa(M);
       Pr = PrStoPr(PrS);
       FirstEvenCrossBackRa = [FirstEvenCrossBackRa Ra];
       FirstEvenCrossBackPr = [FirstEvenCrossBackPr Pr];      
    end 
end


%% Plot
ms = 20;
% odd
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(FirstOddCrossPr, FirstOddCrossRa, 'r*', 'DisplayName', 'First Odd Crossing','MarkerSize',ms); hold on
semilogy(SecondOddCrossPr, SecondOddCrossRa, 'rx', 'DisplayName', 'Second Odd Crossing','MarkerSize',ms);
semilogy(SecondOddCrossBackPr, SecondOddCrossBackRa, 'bx', 'DisplayName', 'First Odd re-Crossing','MarkerSize',ms);
semilogy(FirstOddCrossBackPr, FirstOddCrossBackRa, 'b*', 'DisplayName', 'Second Odd re-Crossing','MarkerSize',ms); 

% even
%figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(FirstEvenCrossPr, FirstEvenCrossRa, 'rs', 'DisplayName', 'First Even Crossing','MarkerSize',ms); 
semilogy(SecondEvenCrossPr, SecondEvenCrossRa, 'ro', 'DisplayName', 'Second Even Crossing','MarkerSize',ms); 
semilogy([SecondEvenCrossBackPr FirstEvenCrossBackPr], [SecondEvenCrossBackRa FirstEvenCrossBackRa], 'bs', 'DisplayName', 'First Even re-Crossing','MarkerSize',ms);
lg = legend();
lg.Location = 'bestoutside';


title('Stability Analysis', 'FontSize', 17);
xlabel('Pr', 'FontSize', 25);
ylabel('Ra', 'FontSize', 25);


%% Simple plot
figure('Renderer', 'painters', 'Position', [5 5 540 200])
[SecondOddCrossBackPr, I] = sort(SecondOddCrossBackPr, 'descend');
SecondOddCrossBackRa =  SecondOddCrossBackRa(I);
[FirstOddCrossPr, I] = sort(FirstOddCrossPr);
FirstOddCrossRa = FirstOddCrossRa(I);
semilogy([SecondOddCrossBackPr FirstOddCrossPr], [SecondOddCrossBackRa FirstOddCrossRa ]);
xlim([5 max(FirstOddCrossPr)])
ylim([2e4 max(SecondOddCrossBackRa)])
%%
a = area(FirstOddCrossBackPr,FirstOddCrossBackRa); hold on
a.LineStyle = 'none';
a = area([max(FirstOddCrossBackPr) max(FirstOddCrossPr)], [max(FirstOddCrossBackRa) max(FirstOddCrossBackRa)]);
a.LineStyle = 'none';
a = area(FirstOddCrossPr,FirstOddCrossRa);
a.LineStyle = 'none';
xlim([5 max(FirstOddCrossPr)])
ylim([2e4 max(FirstOddCrossBackRa)])
set(gca,'yscale', 'log')
newcolors = [0 0 1; 0 0 1; 1 1 1];
colororder(newcolors);
