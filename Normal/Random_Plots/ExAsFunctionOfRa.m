%% Input
AR = 2;
Pr = 200; %3, 5, 10, 30,50, 100, 300, 200
run SomeInputStuff.m
NondimNu  = 0;
NondimKappa = 0;
Other = 0;
PT = 0; % Text?

if (NondimNu && NondimKappa)
   error 
end
%% Get data
Ra = [];
ExShearing = [];
%ExNonShearing = [];
EyShearing = [];
%EyNonShearing = [];
EShearing = [];

Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
for i=1:length(Ra_list)
    if (isfield(AllData.(ARS).(PrS).(Ra_list(i)),'ICT') && isnan(AllData.(ARS).(PrS).(Ra_list(i)).calcs.zExmean))
       Ra = [Ra AllData.(ARS).(PrS).(Ra_list(i)).Ra];
       ExShearingAdd = AllData.(ARS).(PrS).(Ra_list(i)).calcs.sExmean;
       %ExNonShearingAdd = AllData.(ARS).(PrS).(Ra_list(i)).calcs.zExmean;
       EyShearingAdd = AllData.(ARS).(PrS).(Ra_list(i)).calcs.sEymean;
       %EyNonShearingAdd = AllData.(ARS).(PrS).(Ra_list(i)).calcs.zEymean;
       
       if NondimKappa
           ExShearingAdd = ExShearingAdd*pi^2/AllData.(ARS).(PrS).(Ra_list(i)).kappa^2;
           %ExNonShearingAdd = ExNonShearingAdd*pi^2/AllData.(ARS).(PrS).(Ra_list(i)).kappa^2;
           EyShearingAdd = EyShearingAdd*pi^2/AllData.(ARS).(PrS).(Ra_list(i)).kappa^2;
           %EyNonShearingAdd = EyNonShearingAdd*pi^2/AllData.(ARS).(PrS).(Ra_list(i)).kappa^2;
       elseif NondimNu
           ExShearingAdd = ExShearingAdd*pi^2/AllData.(ARS).(PrS).(Ra_list(i)).nu^2;
           %ExNonShearingAdd = ExNonShearingAdd*pi^2/AllData.(ARS).(PrS).(Ra_list(i)).nu^2;
           EyShearingAdd = EyShearingAdd*pi^2/AllData.(ARS).(PrS).(Ra_list(i)).nu^2;
           %EyNonShearingAdd = EyNonShearingAdd*pi^2/AllData.(ARS).(PrS).(Ra_list(i)).nu^2;
       end
        
       ExShearing = [ExShearing ExShearingAdd];
       %ExNonShearing = [ExNonShearing ExNonShearingAdd];
       EyShearing = [EyShearing EyShearingAdd];
       %EyNonShearing = [EyNonShearing EyNonShearingAdd];
       EShearing = [EShearing EyShearingAdd + ExShearingAdd];
    end
end

%% Plot Ey
figure('Renderer', 'painters', 'Position', [5 5 540 200])
%NS = loglog(Ra, EyNonShearing, 'b*'); hold on
s = loglog(Ra, EyShearing, 'r*'); hold on
if NondimNu
    ylabel('$E_y (\nu^2/d^2)$','FontSize', 13)
elseif NondimKappa
    ylabel('$E_y (\kappa^2/d^2)$','FontSize', 13)
else
    ylabel('$E_y$ (dimensional)','FontSize', 13)
end
xlabel('$Ra$','FontSize', 13)
title(['$Pr = ' num2str(Pr) '$'], 'FontSize', 14)
%% Fit data
[alpha, A, xFitted, yFitted, Rval] = FitsPowerLaw(Ra,EyShearing);
plot(xFitted, yFitted, 'black--');
%legend([NS s], 'Non-Shearing', 'Shearing')
legend(s, 'Shearing')
legend('Location', 'Best')
if PT
    gtext(['$E_y \propto Ra^{'  num2str(alpha,3) '}$'],'FontSize',15,'color', 'black')
end
hold off

%% Plot E
figure('Renderer', 'painters', 'Position', [5 5 540 200])
%NS = loglog(Ra, ExNonShearing, 'b*'); hold on
s = loglog(Ra, (ExShearing + EyShearing), 'r*'); hold on
if NondimNu 
    ylabel('$E (\nu^2/d^2)$','FontSize', 13)
elseif NondimKappa
    ylabel('$E (\kappa^2/d^2)$','FontSize', 13)
else 
    ylabel('$E$ (dimensional)','FontSize', 13)
end
xlabel('$Ra$','FontSize', 13)
title(['$Pr = ' num2str(Pr) '$'], 'FontSize', 14)
%% Fit data
[alpha, A, xFitted, yFitted, Rval] = FitsPowerLaw(Ra,ExShearing);
plot(xFitted, yFitted, 'black--');
%legend([NS s], 'Non-Shearing', 'Shearing')
legend(s, 'Shearing')
legend('Location', 'Best')
if PT
    gtext(['$E_x \propto Ra^{'  num2str(alpha,3) '}$'],'FontSize',15,'color', 'black')
end

hold off

clearvars -except AllData 