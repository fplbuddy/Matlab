%% Input
AR = 2;
Ra = 2e7; %2e6, 1e7, 2e7, 5e8
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
s = loglog(Pr, 1-Shearing, 'r*', 'DisplayName', 'Shearing'); hold on
ns = loglog(Pr, 1-NonShearing, 'b*', 'DisplayName', 'Non-Shearing');
ylabel('$1-\frac{E_x}{E}$','FontSize', 13)
xlabel('$Pr$','FontSize', 13)
% Getting Ra for title
RaT = RatoRaT(Ra);
title(['$Ra = ' RaT '$'], 'FontSize', 14)
% model 
mdl = fitlm(log(Pr), log(1-Shearing));
A = exp(mdl.Coefficients.Estimate(1));
alpha = mdl.Coefficients.Estimate(2);
PrFit = logspace(floor(log10(min(Pr))), ceil(log10(max(Pr))),100); % Need to fit the lower bound to when we have sheaing
FittedData = A*PrFit.^alpha;
plot(PrFit, FittedData, 'black--');
legend([s ns], 'Shearing', 'Non-Shearing')
legend('Location', 'NorthEast')
%gtext(['$1-\frac{E_x}{E} \propto Pr^{'  num2str(alpha,3) '}$'],'FontSize',13,'color', 'black')
hold off
%% Plot Ex/E
figure('Renderer', 'painters', 'Position', [5 5 540 200])
s = loglog(Pr, Shearing, 'r*'); hold on
ns = loglog(Pr, NonShearing, 'b*');
ylabel('$\frac{E_x}{E}$','FontSize', 13)
xlabel('$Pr$','FontSize', 13)
title(['$Ra = ' RaT '$'], 'FontSize', 14)
plot(PrFit, 1-FittedData, 'black--');
hold off
legend([s ns], 'Shearing', 'Non-Shearing')
legend('Location', 'NorthEast')
ylim([0.5 1.05])
clearvars -except AllData