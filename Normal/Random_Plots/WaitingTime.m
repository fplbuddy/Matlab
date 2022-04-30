%% Input
AR = 2;
Pr = 30;
run SomeInputStuff.m
%% Get data
Ra = [];
ZeroWT = [];
ShearingWT = [];

Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
for i=1:length(Ra_list)
    if isfield(AllData.(ARS).(PrS).(Ra_list(i)),'ICT')
       Ra = [Ra AllData.(ARS).(PrS).(Ra_list(i)).Ra];
       posT = AllData.(ARS).(PrS).(Ra_list(i)).calcs.posT;
       negT = AllData.(ARS).(PrS).(Ra_list(i)).calcs.negT;
       zeroT = AllData.(ARS).(PrS).(Ra_list(i)).calcs.zeroT;
       TIN = AllData.(ARS).(PrS).(Ra_list(i)).calcs.TIN;
       TIP = AllData.(ARS).(PrS).(Ra_list(i)).calcs.TIP;
       TIZ = AllData.(ARS).(PrS).(Ra_list(i)).calcs.TIZ;
       ZeroWT = [ZeroWT zeroT/TIZ];
       ShearingWT = [ShearingWT (posT + negT)/(TIP + TIN)];
    end
end
%% Plots
figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(Ra, ZeroWT, 'b*', 'DisplayName', 'Non-Shearing')
hold on
loglog(Ra, ShearingWT, 'r*', 'DisplayName', 'Shearing')
hold off
legend show
legend('Location', 'NorthWest')
ylabel('Waiting Time $(s)$','FontSize', 13)
xlabel('$Ra$','FontSize', 13)
title(['$Pr = ' num2str(Pr) '$'], 'FontSize', 14)
clearvars -except AllData