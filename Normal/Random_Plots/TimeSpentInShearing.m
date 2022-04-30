%% Input
AR = 2;
Pr = 30;
run SomeInputStuff.m
%% Get data
Ra = [];
Ratio = [];

Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
for i=1:length(Ra_list)
    if isfield(AllData.(ARS).(PrS).(Ra_list(i)),'ICT')
       Ra = [Ra AllData.(ARS).(PrS).(Ra_list(i)).Ra];
       Add = (AllData.(ARS).(PrS).(Ra_list(i)).calcs.posT + AllData.(ARS).(PrS).(Ra_list(i)).calcs.negT)/...
           (AllData.(ARS).(PrS).(Ra_list(i)).calcs.posT + AllData.(ARS).(PrS).(Ra_list(i)).calcs.negT + AllData.(ARS).(PrS).(Ra_list(i)).calcs.zeroT);
       Ratio = [Ratio Add];
    end
end
%% Plot
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogx(Ra, Ratio, 'r*')
ylabel('Prop of time spent shearing','FontSize', 13)
xlabel('$Ra$','FontSize', 13)
title(['$Pr = ' num2str(Pr) '$'], 'FontSize', 14)
clearvars -except AllData