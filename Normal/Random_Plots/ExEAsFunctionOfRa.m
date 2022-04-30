%% Input
AR = 2;
Pr = 30; %3, 5, 30, 100, 50, 300, 200
run SomeInputStuff.m
%% Get data
Ra = [];
Shearing = [];
NonShearing = [];

Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
for i=1:length(Ra_list)
    if isfield(AllData.(ARS).(PrS).(Ra_list(i)),'ICT')
       Ra = [Ra AllData.(ARS).(PrS).(Ra_list(i)).Ra];
       Shearing = [Shearing AllData.(ARS).(PrS).(Ra_list(i)).calcs.sExEmean];
       NonShearing = [NonShearing AllData.(ARS).(PrS).(Ra_list(i)).calcs.zExEmean];
    end
end
%% Plot
figure('Renderer', 'painters', 'Position', [5 5 540 200])
NS = loglog(Ra, 1-NonShearing, 'b*');
hold on
s = loglog(Ra, 1-Shearing, 'r*');
ylabel('$1-\frac{E_x}{E}$','FontSize', 13)
xlabel('$Ra$','FontSize', 13)
title(['$Pr = ' num2str(Pr) '$'], 'FontSize', 14)
%% Fit data
mdl = fitlm(log(Ra), log(1-Shearing));
A = exp(mdl.Coefficients.Estimate(1));
alpha = mdl.Coefficients.Estimate(2);
RaFit = logspace(floor(log10(min(Ra./not(isnan(Shearing))))), ceil(log10(max(Ra.*not(isnan(Shearing))))),100); % Need to fit the lower bound to when we have sheaing
FittedData = A*RaFit.^alpha;
plot(RaFit, FittedData, 'black--');
legend([NS s], 'Non-Shearing', 'Shearing')
legend('Location', 'NorthEast')
gtext(['$1-\frac{E_x}{E} \propto Ra^{'  num2str(alpha,3) '}$'],'FontSize',13,'color', 'black')
hold off
%% Plot Ex/E
figure('Renderer', 'painters', 'Position', [5 5 540 200])
NS = loglog(Ra, NonShearing, 'b*');
hold on
s = loglog(Ra, Shearing, 'r*');
ylabel('$\frac{E_x}{E}$','FontSize', 13)
xlabel('$Ra$','FontSize', 13)
title(['$Pr = ' num2str(Pr) '$'], 'FontSize', 14)
plot(RaFit, 1-FittedData, 'black--');
legend([NS s], 'Non-Shearing', 'Shearing')
legend('Location', 'SouthEast')
ylim([0.45 1.05])
clearvars -except AllData a