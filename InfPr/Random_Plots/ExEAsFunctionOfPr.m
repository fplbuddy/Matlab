%% Input
AR = 2;
Ra = 5e8;
run SomeInputStuff.m

%% Get data
Pr = [];
Shearing = [];
NonShearing = [];

Pr_list = string(fieldnames(AllData.(ARS)));
for i=1:length(Pr_list)
    try
        if isfield(AllData.(ARS).(Pr_list(i)).(RaS),'ICT')
           Pr = [Pr AllData.(ARS).(Pr_list(i)).(RaS).Pr];
           Shearing = [Shearing AllData.(ARS).(Pr_list(i)).(RaS).calcs.sExEmean];
           NonShearing = [NonShearing AllData.(ARS).(Pr_list(i)).(RaS).calcs.zExEmean];
        end
    catch
    end
end
%% Plots 
figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(Pr, 1-Shearing, 'r*', 'DisplayName', 'Shearing')
hold on
loglog([300 3], [max(1-Shearing) min(1-Shearing)])
%legend('Location', 'SouthWest')
ylabel('$1-\frac{E_x}{E}$','FontSize', 13)
xlabel('$Pr$','FontSize', 13)
%xlim([1.4 10.1])

% Getting Ra for title
RaT = RatoRaT(Ra);
title(['$Ra = ' RaT '$'], 'FontSize', 14)
hold off
clearvars -except AllData