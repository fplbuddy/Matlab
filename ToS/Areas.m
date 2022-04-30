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
    try
    M = GetM(Data, PrS, types, AR,1,1, "odd");
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
    M = GetM(Data, PrS, types, AR,1,2, "odd");
    if not(isempty(M))
       [~,Ra] = GetNextRa(M);
       Pr = PrStoPr(PrS);
       FirstOddCrossBackRa = [FirstOddCrossBackRa Ra];
       FirstOddCrossBackPr = [FirstOddCrossBackPr Pr];      
    end 
end

%%
figure('Renderer', 'painters', 'Position', [5 5 700 300])
sp = subplot(1,2, 1);
a = area(FirstOddCrossBackPr,FirstOddCrossBackRa); hold on
a.LineStyle = 'none';
a = area([max(FirstOddCrossBackPr) max(FirstOddCrossPr)], [max(FirstOddCrossBackRa) max(FirstOddCrossBackRa)]);
a.LineStyle = 'none';
a = area(FirstOddCrossPr,FirstOddCrossRa);
a.LineStyle = 'none';
xlim([5 30])
ylim([2e4 max(FirstOddCrossBackRa)])
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
plot([6.2 6.2], [2e4 max(FirstOddCrossBackRa)], 'black--')
xticks([6.2 10 15 20 25 30])
text(27, 3.8e5,'(a)', 'FontSize', LabelFS, 'Color', 'white')

% sp = subplot(1,3, 3);
% a = area(FirstOddCrossBackPr,FirstOddCrossBackRa); hold on
% a.LineStyle = 'none';
% a = area([max(FirstOddCrossBackPr) max(FirstOddCrossPr)], [max(FirstOddCrossBackRa) max(FirstOddCrossBackRa)]);
% a.LineStyle = 'none';
% a = area(FirstOddCrossPr,FirstOddCrossRa);
% a.LineStyle = 'none';
% a.EdgeColor = [1 1 1];
% xlim([6 11])
% ylim([2e4 max(FirstOddCrossBackRa)])
% set(gca,'yscale', 'log')
% yticklabels('')
% newcolors = [0 0 1; 0 0 1; 1 1 1];
% colororder(newcolors);
% xlabel('Pr','FontSize', LabelFS)
% ax = gca;
% ax.XAxis.FontSize = numFS;
% ax.YAxis.FontSize = numFS;
% sp.TickLength = [0.03 0.03];
% ax.LineWidth = 0.7;
% text(8.2, 2.5e4,'$S$', 'FontSize', TitleFS, 'Color', 'k')
% text(8.2, 1e5,'$US$', 'FontSize', TitleFS, 'Color', 'white')

sp = subplot(1,2, 2);
Pr = 6.2;
type = "OneOne64";
AR = 'AR_2';
PrS = PrtoPrS(Pr);
Ra_listOne = [4.6e4 4.7e4 5.5e4 6.4e4 6.5e4];
Ra_listTwo = 4.6e4:1e3:6.6e4;
rem = [Ra_listOne 5.7e4 5.4e4 5.6e4];
for i=1:length(rem)
    r = rem(i);
    Ra_listTwo(Ra_listTwo == r) = [];
end
set(0,'DefaultFigureColormap',feval('cool'));
WhichSigma = 'sigmaodd';
ms = 13;
num = 5;
cmap = colormap(cool(num));
plot([-0.2 0.5], [0 0], 'black--', 'HandleVisibility','off'); hold on
plot([0 0], [-250 20], 'black--', 'HandleVisibility','off');
plot([0 0], [90 250], 'black--', 'HandleVisibility','off');
for i = 1:length(Ra_listTwo)
     RaS = RatoRaS(Ra_listTwo(i));
     sigma = Data.(AR).(type).(PrS).(RaS).(WhichSigma);
     %p = plot(real(sigma), imag(sigma), 'black*','HandleVisibility','off','MarkerSize',ms); hold on
     p = scatter(real(sigma), imag(sigma), 60, 'k*','HandleVisibility','off');
     alpha(p,0.5)
end

for i = 1:length(Ra_listOne)
    Ra = Ra_listOne(i);
    RaS = RatoRaS(Ra);
    sigma = Data.(AR).(type).(PrS).(RaS).(WhichSigma);
    plot(real(sigma), imag(sigma), '*','Color',cmap(i,:),'DisplayName', num2str(Ra),'MarkerSize',ms), hold on
end
lgnd = legend('Location', 'east', 'FontSize', numFS); title(lgnd,'Ra', 'FontSize', numFS)
ax = gca;
ylim([-250 250])
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([-0.2 0.5])
xlabel('$\mathcal{R}(\sigma)$', 'FontSize', LabelFS)
ylabel('$\mathcal{I}(\sigma)$', 'FontSize', LabelFS)
sp.Position(2) = sp.Position(2) + 0.05;
sp.Position(4) = sp.Position(4) - 0.05;
text(-0.15,50,'Pr $= 6.2$', 'FontSize', LabelFS)
text(-0.19, 210,'(b)', 'FontSize', LabelFS, 'Color', 'k')

%%



cmap = colormap(cool(num));
for i=1:length(Ra_list)
    figure('Renderer', 'painters', 'Position', [5 5 540 200])
    %subplot(1,2,1)
    for j=i:i+num-1
        RaS = Ra_list(j);
        Ra = RaStoRa(RaS);
        sigma = Data.(AR).(type).(PrS).(RaS).(WhichSigma);
        %plot(real(sigma), imag(sigma), '*', 'Color',cmap((length(Ra_list)-i+1),:),'DisplayName', num2str(Ra)), hold on
        plot(real(sigma), imag(sigma), '*', 'Color',cmap(j-i+1,:),'DisplayName', num2str(Ra),'MarkerSize',ms), hold on
        %x = real(sigma); y = imag(sigma); z = Ra*ones(length(sigma),1);
        %scatter(x,y,10,z, 'filled', 'DisplayName', num2str(Ra)), %hold on
        xlim([-0.2 0.4])
        %ylim([-220 -180])
        %colorbar()
        lgnd = legend('Location', 'Bestoutside'); title(lgnd,'$Ra$')
    end
    %p = plot([0 0], [-400 400], 'black--' );
    %set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    xlabel('$Real(\sigma)$', 'FontSize', 14)
    ylabel('$Imag(\sigma)$', 'FontSize', 14)
    pause
    
    hold off
end

