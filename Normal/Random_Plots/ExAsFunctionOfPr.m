%% Input
AR = 2;
Ra = 1e8; %2e6, 1e7, 2e7, 5e8
run SomeInputStuff.m
NondimNu  = 0;
NondimKappa = 0;
Other = 0;

if (NondimNu && NondimKappa)
   error 
end
%% Get data
Pr = [];
ExShearing = [];
EyShearing = [];

Pr_list = string(fieldnames(AllData.(ARS)));
for i=1:length(Pr_list)
    try
        if isfield(AllData.(ARS).(Pr_list(i)).(RaS),'ICT')
            Pr = [Pr AllData.(ARS).(Pr_list(i)).(RaS).Pr];
            ExShearingAdd = AllData.(ARS).(Pr_list(i)).(RaS).calcs.sExmean;
            EyShearingAdd = AllData.(ARS).(Pr_list(i)).(RaS).calcs.sEymean;
            
            if NondimNu
                ExShearingAdd = ExShearingAdd*pi^2/AllData.(ARS).(Pr_list(i)).(RaS).nu^2;
                EyShearingAdd = EyShearingAdd*pi^2/AllData.(ARS).(Pr_list(i)).(RaS).nu^2;
            elseif NondimKappa
                ExShearingAdd = ExShearingAdd*pi^2/AllData.(ARS).(Pr_list(i)).(RaS).kappa^2;
                EyShearingAdd = EyShearingAdd*pi^2/AllData.(ARS).(Pr_list(i)).(RaS).kappa^2;
            elseif Other
                ExShearingAdd = ExShearingAdd*AllData.(ARS).(Pr_list(i)).(RaS).Pr^(-2)*pi^2/AllData.(ARS).(Pr_list(i)).(RaS).kappa^2;
                EyShearingAdd = EyShearingAdd*AllData.(ARS).(Pr_list(i)).(RaS).Pr^(-2)*5*pi^2/AllData.(ARS).(Pr_list(i)).(RaS).kappa^2;
            end
            ExShearing = [ExShearing ExShearingAdd];
            EyShearing = [EyShearing EyShearingAdd];
        end
    catch
    end
end

%% Plot Ey
figure('Renderer', 'painters', 'Position', [5 5 540 200])
s = loglog(Pr, EyShearing, 'r*', 'DisplayName', 'Shearing');
hold on
if NondimNu
    ylabel('$E_y (\nu^2/d^2)$','FontSize', 13)
elseif NondimKappa
    ylabel('$E_y (\kappa^2/d^2)$','FontSize', 13)
elseif Other
    ylabel('$E_x (Other)$','FontSize', 13)
else
    ylabel('$E_y$ (dimensional)','FontSize', 13)
end
xlabel('$Pr$','FontSize', 13)
% Getting Ra for title
RaT = RatoRaT(Ra);
title(['$Ra = ' RaT '$'], 'FontSize', 14)
%% model
mdl = fitlm(log(Pr), log(EyShearing));
A = exp(mdl.Coefficients.Estimate(1));
alpha = mdl.Coefficients.Estimate(2);
PrFit = logspace(floor(log10(min(Pr))), ceil(log10(max(Pr))),100); % Need to fit the lower bound to when we have sheaing
FittedData = A*PrFit.^alpha;
plot(PrFit, FittedData, 'black--');
legend(s, 'Shearing')
legend('Location', 'Best')
%gtext(['$E_y \propto Pr^{'  num2str(alpha,3) '}$'],'FontSize',20,'color', 'black')
hold off
%% Plot Ex
figure('Renderer', 'painters', 'Position', [5 5 540 200])
s = loglog(Pr, ExShearing, 'r*');
hold on
if NondimNu
    ylabel('$E_x (\nu^2/d^2)$','FontSize', 13)
elseif NondimKappa
    ylabel('$E_x (\kappa^2/d^2)$','FontSize', 13)
elseif Other
    ylabel('$E_x (Other)$','FontSize', 13)
else
    ylabel('$E_x$ (dimensional)','FontSize', 13)
end
xlabel('$Pr$','FontSize', 13)
title(['$Ra = ' RaT '$'], 'FontSize', 14)
% Model
mdl = fitlm(log(Pr), log(ExShearing));
A = exp(mdl.Coefficients.Estimate(1));
alpha = mdl.Coefficients.Estimate(2);
PrFit = logspace(floor(log10(min(Pr))), ceil(log10(max(Pr))),100); % Need to fit the lower bound to when we have sheaing
FittedData = A*PrFit.^alpha;
plot(PrFit, FittedData, 'black--');
legend(s, 'Shearing')
legend('Location', 'Best')
%gtext(['$E_x \propto Pr^{'  num2str(alpha,3) '}$'],'FontSize',20,'color', 'black')
clearvars -except AllData