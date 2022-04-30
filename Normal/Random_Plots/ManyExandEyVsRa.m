% Inputs
AR = 2;
Pr_list2 = [3 5 10 30 50 100 150 200 250 300]; %[3 5 30 50 100]; %3, 5, 30, 100, 50, 300, 200
PFD = 0;
% Setting up figures
figure(1); % Will plot Ex here
set(gcf, 'Position',  [5 5 540 200])
figure(2); % Will plot Ey here
set(gcf, 'Position',  [5 5 540 200])
figure(3); % Will plot E here
set(gcf, 'Position',  [5 5 540 200])
% Setting up colours
cmap = colormap(lines(length(Pr_list2)));
%%
for i=1:length(Pr_list2)
    Pr = Pr_list2(i);
    run SomeInputStuff.m
    RaShearing = [];
    ExShearing = [];
    EyShearing = [];
    ExNonShearing = [];
    EyNonShearing = [];
    RaNonShearing = [];
    
    Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
    for j=1:length(Ra_list)
        if (isfield(AllData.(ARS).(PrS).(Ra_list(j)),'ICT') && not(isnan(AllData.(ARS).(PrS).(Ra_list(j)).calcs.sExmean)))
            RaShearing = [RaShearing AllData.(ARS).(PrS).(Ra_list(j)).Ra];
            ExShearing = [ExShearing AllData.(ARS).(PrS).(Ra_list(j)).calcs.sExmean];
            EyShearing = [EyShearing AllData.(ARS).(PrS).(Ra_list(j)).calcs.sEymean];
        end
        if (isfield(AllData.(ARS).(PrS).(Ra_list(j)),'ICT') && not(isnan(AllData.(ARS).(PrS).(Ra_list(j)).calcs.zExmean)))
            RaNonShearing = [RaNonShearing AllData.(ARS).(PrS).(Ra_list(j)).Ra];
            ExNonShearing = [ExNonShearing AllData.(ARS).(PrS).(Ra_list(j)).calcs.zExmean];
            EyNonShearing = [EyNonShearing AllData.(ARS).(PrS).(Ra_list(j)).calcs.zEymean];       
        end
    end
    % Sorting
    [RaShearing, I] = sort(RaShearing);
    ExShearing = ExShearing(I);
    EyShearing = EyShearing(I);
    [RaNonShearing, I] = sort(RaNonShearing);
    ExNonShearing = ExNonShearing(I);
    EyNonShearing = EyNonShearing(I);
    
    % Ex
    figure(1)
    p1 = loglog(RaShearing, ExShearing, '*', 'Color',cmap(i,:),'DisplayName', num2str(Pr)); hold on
    p2 = plot(RaNonShearing, ExNonShearing, '.', 'MarkerSize',12, 'Color',cmap(i,:),'DisplayName', num2str(Pr));
    set(get(get(p1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
    set(get(get(p2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
    % Ey
    figure(2)
    p1 = loglog(RaShearing, EyShearing, '*',  'Color',cmap(i,:),'DisplayName', num2str(Pr)); hold on
    p2 = loglog(RaNonShearing, EyNonShearing, '.', 'MarkerSize',12, 'Color',cmap(i,:),'DisplayName', num2str(Pr))
    set(get(get(p1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
    set(get(get(p2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
    % E
    figure(3)
    p1 = loglog(RaShearing, EyShearing+ExShearing, '*', 'Color',cmap(i,:), 'DisplayName', num2str(Pr)); hold on
    p2 = loglog(RaNonShearing, EyNonShearing+ExNonShearing, '.', 'MarkerSize',12,  'Color',cmap(i,:),'DisplayName', num2str(Pr))
    set(get(get(p1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
    set(get(get(p2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
    clear Ra Ra_list
end
% Ex
figure(1)
xlabel('$Ra$', 'FontSize',13)
ylabel('$E_x$ (Dimensional)', 'FontSize',13)
% Making the legend
LC = [];
for i=1:length(Pr_list2)
    dummy = line(nan, nan, 'Linestyle', '-','Linewidth',3  ,'Marker', 'none', 'Color', cmap(i,:));
    LC = [LC convertCharsToStrings(num2str(Pr_list2(i)))];
end
legend(LC)
lgnd = legend('Location', 'BestOutside'); title(lgnd,'$Pr$');
hold off
% Ey
figure(2)
xlabel('$Ra$', 'FontSize',13)
ylabel('$E_y$ (Dimensional)', 'FontSize',13)
% Making the legend
LC = [];
for i=1:length(Pr_list2)
    dummy = line(nan, nan, 'Linestyle', '-','Linewidth',3  ,'Marker', 'none', 'Color', cmap(i,:));
    LC = [LC convertCharsToStrings(num2str(Pr_list2(i)))];
end
legend(LC)
lgnd = legend('Location', 'BestOutside'); title(lgnd,'$Pr$');
hold off
% E
figure(3)
xlabel('$Ra$', 'FontSize',13)
ylabel('$E$ (Dimensional)', 'FontSize',13)
% Making the legend
LC = [];
for i=1:length(Pr_list2)
    dummy = line(nan, nan, 'Linestyle', '-','Linewidth',3  ,'Marker', 'none', 'Color', cmap(i,:));
    LC = [LC convertCharsToStrings(num2str(Pr_list2(i)))];
end
legend(LC)
lgnd = legend('Location', 'BestOutside'); title(lgnd,'$Pr$');
hold off

clearvars -except AllData


