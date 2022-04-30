close all
o1 = 1; o2 = 1; 
nu = 2e-4; kappa = 2e-6; f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
nuS = normaltoS(nu, 'nu',1); kappaS = normaltoS(kappa, 'kappa',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
run SetUp.m
n = 4096;
ns = ['n_' num2str(n)];
%%
path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
kenergy = importdata([path '/Checks/kenergy.txt']);
penergy = importdata([path '/Checks/penergy.txt']);
ken =  kenergy(:,2);
t = kenergy(:,1);
denk =  kenergy(:,3); 
fenk =  kenergy(:,4); % injection
henk =  kenergy(:,5);

pen =  penergy(:,2);
denp =  penergy(:,3);
fav = mean(fenk);
trans = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).trans;
%t = t(trans:end); OneZero = OneZero(trans:end);
% non-dim
%OneZero = OneZero/kappa;
%t = t/((2*pi)^2/kappa);
%% 1 Kinetic Energy
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(t(trans:end),ken(trans:end)), hold on
%loglog(ken,'LineWidth',1), hold on
nuT = RatoRaT(nu);
kappaT = RatoRaT(kappa);
hnuT = RatoRaT(hnu);
title(['$ \nu =' nuT '\, , \kappa = ' kappaT '\, , \mu = ' hnuT '$'  ],'FontSize',labelFS);
ylabel('Kinetic Energy', 'FontSize', labelFS);
xlabel('$t\,(s)$', 'FontSize', labelFS);
%[alpha1, ~, ~, ~, ~] = Fitslogy(t,OneZero)
nuS = convertStringsToChars(nuS);
kappaS = convertStringsToChars(kappaS);
hnuS = convertStringsToChars(hnuS);
%saveas(gcf,[figpath 'KETS_' nuS '_' kappaS '_'  hnuS], 'epsc')

%% 2 Potential Energy
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(t(trans:end),pen(trans:end),'LineWidth',1), hold on
title(['$ \nu =' nuT '\, , \kappa = ' kappaT '\, , \mu = ' hnuT '$'  ],'FontSize',labelFS);
ylabel('Potential Energy', 'FontSize', labelFS);
xlabel('$t\,(s)$', 'FontSize', labelFS);
%[alpha1, ~, ~, ~, ~] = Fitslogy(t,OneZero)
%saveas(gcf,[figpath 'PETS_' nuS '_' kappaS '_'  hnuS], 'epsc')

%% 3 Small scal diss kinetic
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(t(trans:end),denk(trans:end),'LineWidth',1), hold on
title(['$ \nu =' nuT '\, , \kappa = ' kappaT '\, , \mu = ' hnuT '$'  ],'FontSize',labelFS);
ylabel('$<\underline{u} \cdot \nabla^2\underline{u}>$', 'FontSize', labelFS);
xlabel('$t\,(s)$', 'FontSize', labelFS);
%[alpha1, ~, ~, ~, ~] = Fitslogy(t,OneZero)
%saveas(gcf,[figpath 'KESSDTS_' nuS '_' kappaS '_'  hnuS], 'epsc')

%% 4 large scal diss kinetic
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(t(trans:end),henk(trans:end),'LineWidth',1), hold on
title(['$ \nu =' nuT '\, , \kappa = ' kappaT '\, , \mu = ' hnuT '$'  ],'FontSize',labelFS);
ylabel('$<\underline{u} \cdot \nabla^{-2}\underline{u}>$', 'FontSize', labelFS);
xlabel('$t\,(s)$', 'FontSize', labelFS);
%saveas(gcf,[figpath 'KELSDTS_' nuS '_' kappaS '_'  hnuS], 'epsc')

%% 5 large scal diss potential
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(t(trans:end),denp(trans:end),'LineWidth',1), hold on
title(['$ \nu =' nuT '\, , \kappa = ' kappaT '\, , \mu = ' hnuT '$'  ],'FontSize',labelFS);
ylabel('$ <\theta \nabla^{2}\theta>$', 'FontSize', labelFS);
xlabel('$t\,(s)$', 'FontSize', labelFS);
%saveas(gcf,[figpath 'PELSDTS_' nuS '_' kappaS '_'  hnuS], 'epsc')

%%
figure()
plot(t(trans:end),fenk(trans:end),'LineWidth',1)




