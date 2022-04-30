Pr_list2 = [3 5 10 50 30 100 200 300]; % 300
% NondimNu  = 0;
% NondimKappa = 0;
AR = 2;
% Setting up exponent lists
ax = [];
ay = [];
aE = [];
Tit1 = 'g';
Ax = [];
Ay = [];
AE = [];
Tit2 = 'G';

for i=1:length(Pr_list2)
    Pr = Pr_list2(i);
    run SomeInputStuff.m
    Ra = [];
    ExShearing = [];
    EyShearing = [];
    Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
    for i=1:length(Ra_list)
        if (isfield(AllData.(ARS).(PrS).(Ra_list(i)),'ICT') && not(isnan(AllData.(ARS).(PrS).(Ra_list(i)).calcs.sExmean))) % Don't want to take bistable regime into account
            Ra = [Ra AllData.(ARS).(PrS).(Ra_list(i)).Ra];
            ExShearingAdd = AllData.(ARS).(PrS).(Ra_list(i)).calcs.sExmean;
            EyShearingAdd = AllData.(ARS).(PrS).(Ra_list(i)).calcs.sEymean;
%             if NondimKappa
%                 ExShearingAdd = ExShearingAdd*pi^2/AllData.(ARS).(PrS).(Ra_list(i)).kappa^2;
%                 EyShearingAdd = EyShearingAdd*pi^2/AllData.(ARS).(PrS).(Ra_list(i)).kappa^2;
%             elseif NondimNu
%                 ExShearingAdd = ExShearingAdd*pi^2/AllData.(ARS).(PrS).(Ra_list(i)).nu^2;
%                 EyShearingAdd = EyShearingAdd*pi^2/AllData.(ARS).(PrS).(Ra_list(i)).nu^2;
%             end
            
            ExShearing = [ExShearing ExShearingAdd];
            EyShearing = [EyShearing EyShearingAdd];
        end
    end
    

    [alphax, AAx, xFitted, yFitted, Rval] = Fitslogx(Ra,ExShearing.^(0.5)); % Note that we use different models to fit Ex and Ey
    [alphay, AAy, xFitted, yFitted, Rval] = FitsPowerLaw(Ra,EyShearing);
    [alphaE, AAE, xFitted, yFitted, Rval] = FitsPowerLaw(Ra,EyShearing+ExShearing);
    
    ax = [ax alphax];
    ay = [ay alphay];
    aE = [aE alphaE];
    Ax = [Ax AAx];
    Ay = [Ay AAy];
    AE = [AE AAE];
    
    clear Ra Ra_list
end
% Now we have the data, now lets fit some plots
%% ax 
figure('Renderer', 'painters', 'Position', [1 50 1080 400])
% get loglog
[alpha, A, xFitted, yFitted, Rval] = FitsPowerLaw(Pr_list2,ax);
subplot(1,3,1), hold on
loglog(Pr_list2,ax, 'red*'), set(gca,'xscale','log'), set(gca,'yscale','log')
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit1 '(Pr) \propto Pr^{\alpha}$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
ylabel(['$' Tit1 '(Pr)$']), xlabel('$Pr$')
% get semilog y
[alpha, A, xFitted, yFitted, Rval] = Fitslogy(Pr_list2,ax);
subplot(1,3,2), hold on
semilogy(Pr_list2,ax, 'red*'), set(gca,'yscale','log')
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit1 '(Pr) \propto e^{(\alpha Pr)}$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
xlabel('$Pr$')
% get semilog x
[alpha, A, xFitted, yFitted, Rval] = Fitslogx(Pr_list2,ax);
subplot(1,3,3), hold on
semilogx(Pr_list2,ax, 'red*'), set(gca,'xscale','log');
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit1 '(Pr) \propto \log(Pr^{\alpha})$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
xlabel('$Pr$')
sgtitle('$E_x^{0.5}$ (dimensional)')
%% Ax 
figure('Renderer', 'painters', 'Position', [1 50 1080 400])
% get loglog
[alpha, A, xFitted, yFitted, Rval] = FitsPowerLaw(Pr_list2,Ax);
subplot(1,3,1), hold on
loglog(Pr_list2,Ax, 'red*'), set(gca,'xscale','log'), set(gca,'yscale','log')
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit2 '(Pr) \propto Pr^{\alpha}$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
ylabel(['$' Tit2 '(Pr)$']), xlabel('$Pr$')
% get semilog y
[alpha, A, xFitted, yFitted, Rval] = Fitslogy(Pr_list2,Ax);
subplot(1,3,2), hold on
semilogy(Pr_list2,Ax, 'red*'), set(gca,'yscale','log')
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit2 '(Pr) \propto e^{(\alpha Pr)}$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
xlabel('$Pr$')
% get semilog x
[alpha, A, xFitted, yFitted, Rval] = Fitslogx(Pr_list2,Ax);
subplot(1,3,3), hold on
semilogx(Pr_list2,Ax, 'red*'), set(gca,'xscale','log')
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit2 '(Pr) \propto \log(Pr^{\alpha})$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
xlabel('$Pr$')
sgtitle('$E_x^{0.5}$ (dimensional)')
%% ay 
figure('Renderer', 'painters', 'Position', [1 50 1080 400])
% get loglog
[alpha, A, xFitted, yFitted, Rval] = FitsPowerLaw(Pr_list2,ay);
subplot(1,3,1), hold on
loglog(Pr_list2,ay, 'red*'), set(gca,'xscale','log'), set(gca,'yscale','log')
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit1 '(Pr) \propto Pr^{\alpha}$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
ylabel(['$' Tit1 '(Pr)$']), xlabel('$Pr$')
% get semilog y
[alpha, A, xFitted, yFitted, Rval] = Fitslogy(Pr_list2,ay);
subplot(1,3,2), hold on
semilogy(Pr_list2,ay, 'red*'), set(gca,'yscale','log')
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit1 '(Pr) \propto e^{(\alpha Pr)}$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
xlabel('$Pr$')
% get semilog x
[alpha, A, xFitted, yFitted, Rval] = Fitslogx(Pr_list2,ay);
subplot(1,3,3), hold on
semilogx(Pr_list2,ay, 'red*'), set(gca,'xscale','log')
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit1 '(Pr) \propto \log(Pr^{\alpha})$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
xlabel('$Pr$')
sgtitle('$E_y$ (dimensional)')
%% Ay 
figure('Renderer', 'painters', 'Position', [1 50 1080 400])
% get loglog
[alpha, A, xFitted, yFitted, Rval] = FitsPowerLaw(Pr_list2,Ay);
subplot(1,3,1), hold on
loglog(Pr_list2,Ay, 'red*'), set(gca,'xscale','log'), set(gca,'yscale','log')
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit2 '(Pr) \propto Pr^{\alpha}$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
ylabel(['$' Tit2 '(Pr)$']), xlabel('$Pr$')
% get semilog y
[alpha, A, xFitted, yFitted, Rval] = Fitslogy(Pr_list2,Ay);
subplot(1,3,2), hold on
semilogy(Pr_list2,Ay, 'red*'), set(gca,'yscale','log')
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit2 '(Pr) \propto e^{(\alpha Pr)}$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
xlabel('$Pr$')
% get semilog x
[alpha, A, xFitted, yFitted, Rval] = Fitslogx(Pr_list2,Ay);
subplot(1,3,3), hold on
semilogx(Pr_list2,Ay, 'red*'), set(gca,'xscale','log')
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit2 '(Pr) \propto \log(Pr^{\alpha})$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
xlabel('$Pr$')
sgtitle('$E_y$ (dimensional)')
%% aE 
figure('Renderer', 'painters', 'Position', [1 50 1080 400])
% get loglog
[alpha, A, xFitted, yFitted, Rval] = FitsPowerLaw(Pr_list2,aE);
subplot(1,3,1), hold on
loglog(Pr_list2,aE, 'red*'), set(gca,'xscale','log'), set(gca,'yscale','log')
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit1 '(Pr) \propto Pr^{\alpha}$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
ylabel(['$' Tit1 '(Pr)$']), xlabel('$Pr$')
% get semilog y
[alpha, A, xFitted, yFitted, Rval] = Fitslogy(Pr_list2,aE);
subplot(1,3,2), hold on
semilogy(Pr_list2,aE, 'red*'), set(gca,'yscale','log')
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit1 '(Pr) \propto e^{(\alpha Pr)}$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
xlabel('$Pr$')
% get semilog x
[alpha, A, xFitted, yFitted, Rval] = Fitslogx(Pr_list2,aE)
subplot(1,3,3), hold on
semilogx(Pr_list2,aE, 'red*'), set(gca,'xscale','log')
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit1 '(Pr) \propto \log(Pr^{\alpha})$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
xlabel('$Pr$')
sgtitle('$E$ (dimensional)')
%% AE
figure('Renderer', 'painters', 'Position', [1 50 1080 400])
% get loglog
[alpha, A, xFitted, yFitted, Rval] = FitsPowerLaw(Pr_list2,AE)
subplot(1,3,1), hold on
loglog(Pr_list2,AE, 'red*'), set(gca,'xscale','log'), set(gca,'yscale','log')
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit2 '(Pr) \propto Pr^{\alpha}$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
ylabel(['$' Tit2 '(Pr)$']), xlabel('$Pr$')
% get semilog y
[alpha, A, xFitted, yFitted, Rval] = Fitslogy(Pr_list2,AE);
subplot(1,3,2), hold on
semilogy(Pr_list2,AE, 'red*'), set(gca,'yscale','log')
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit2 '(Pr) \propto e^{(\alpha Pr)}$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
xlabel('$Pr$')
% get semilog x
[alpha, A, xFitted, yFitted, Rval] = Fitslogx(Pr_list2,AE);
subplot(1,3,3), hold on
semilogx(Pr_list2,AE, 'red*'), set(gca,'xscale','log')
plot(xFitted, yFitted, 'black--'), hold off
title(['$' Tit2 '(Pr) \propto \log(Pr^{\alpha})$, Rval = ' num2str(Rval,3)], 'FontSize', 15)
xlabel('$Pr$')
sgtitle('$E$ (dimensional)')


clearvars -except AllData