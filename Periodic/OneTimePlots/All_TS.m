close all
o1 = 1; o2 = 1;
f = 0; hnu = 0.2; 
fS = normaltoS(f, 'f'); hnuS = normaltoS(hnu, 'hnu');
nuS = nutonuS(nu); kappaS = kappatokappaS(kappa);
o1 = normaltoS(o1, 'o1'); o2 = normaltoS(o2, 'o2');
run /Users/philipwinchester/Dropbox/Matlab/Periodic/Plot/SetUp.m
%%
% _1
n = 256;
ns = ['n_' num2str(n)];
nu = 7e-3; kappa = 7e-2;
nuS = nutonuS(nu); kappaS = kappatokappaS(kappa);
path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
kenergy_1 = importdata([path '/Checks/kenergy.txt']);
penergy_1 = importdata([path '/Checks/penergy.txt']);
ken_1 =  kenergy_1(:,2);
t_1 = kenergy_1(:,1);
denk_1 =  kenergy_1(:,3); 
fenk_1 =  kenergy_1(:,4); % injection
henk_1 =  kenergy_1(:,5);
pen_1=  penergy_1(:,2);
denp_1 =  penergy_1(:,3);
% 1
kappa = 7e-3;
kappaS = kappatokappaS(kappa);
path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
kenergy1 = importdata([path '/Checks/kenergy.txt']);
penergy1 = importdata([path '/Checks/penergy.txt']);
ken1 =  kenergy1(:,2);
t1 = kenergy1(:,1);
denk1 =  kenergy1(:,3); 
fenk1 =  kenergy1(:,4); % injection
henk1 =  kenergy1(:,5);
pen1 =  penergy1(:,2);
denp1 =  penergy1(:,3);
% 10
n = 512;
ns = ['n_' num2str(n)];
kappa = 7e-4;
kappaS = kappatokappaS(kappa);
path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
kenergy10 = importdata([path '/Checks/kenergy.txt']);
penergy10 = importdata([path '/Checks/penergy.txt']);
ken10 =  kenergy10(:,2);
t10 = kenergy10(:,1);
denk10 =  kenergy10(:,3); 
fenk10 =  kenergy10(:,4); % injection
henk10 =  kenergy10(:,5);
pen10 =  penergy10(:,2);
denp10 =  penergy10(:,3);


%% 1 Kinetic Energy
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(t_1,ken_1,'LineWidth',1, 'DisplayName', '0.1'), hold on
semilogy(t1,ken1,'LineWidth',1, 'DisplayName', '1'), hold on
semilogy(t10,ken10,'LineWidth',1, 'DisplayName', '10'), hold on

ylabel('Kinetic Energy', 'FontSize', labelFS);
xlabel('$t\,(s)$', 'FontSize', labelFS);
lgnd = legend('Location', 'Best', 'FontSize', numFS);
title(lgnd,'$Pr$', 'FontSize', numFS)
saveas(gcf,[figpath 'KETS_PrComp'], 'epsc')

%% 2 Potential Energy
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(t_1,pen_1,'LineWidth',1, 'DisplayName', '0.1'), hold on
semilogy(t1,pen1,'LineWidth',1, 'DisplayName', '1'), hold on
semilogy(t10,pen10,'LineWidth',1, 'DisplayName', '10'), hold on
ylabel('Potential Energy', 'FontSize', labelFS);
xlabel('$t\,(s)$', 'FontSize', labelFS);
lgnd = legend('Location', 'Best', 'FontSize', numFS);
title(lgnd,'$Pr$', 'FontSize', numFS)
saveas(gcf,[figpath 'PETS_PrComp'], 'epsc')

%% 3 Small scal diss kinetic
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(t_1,-nu*denk_1./fenk_1,'LineWidth',1, 'DisplayName', '0.1'), hold on
plot(t1,-nu*denk1./fenk1,'LineWidth',1, 'DisplayName', '1'), hold on
plot(t10,-nu*denk10./fenk10,'LineWidth',1, 'DisplayName', '10'), hold on

ylabel('$\frac{\nu <\underline{u} \cdot \nabla^2\underline{u}>}{g \alpha<\psi_x \theta> }$', 'FontSize', labelFS);
xlabel('$t\,(s)$', 'FontSize', labelFS);
lgnd = legend('Location', 'Best', 'FontSize', numFS);
title(lgnd,'$Pr$', 'FontSize', numFS)
saveas(gcf,[figpath 'KESSDTS_PrComp'], 'epsc')

%% 4 large scal diss kinetic
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(t_1,-hnu*henk_1./fenk_1,'LineWidth',1, 'DisplayName', '0.1'), hold on
plot(t1,-hnu*henk1./fenk1,'LineWidth',1, 'DisplayName', '1'), hold on
plot(t10,-hnu*henk10./fenk10,'LineWidth',1, 'DisplayName', '10'), hold on

ylabel('$\frac{\mu <\underline{u} \cdot \nabla^{-2}\underline{u}>}{g \alpha<\psi_x \theta> }$', 'FontSize', labelFS);
xlabel('$t\,(s)$', 'FontSize', labelFS);
lgnd = legend('Location', 'Best', 'FontSize', numFS);
title(lgnd,'$Pr$', 'FontSize', numFS)
saveas(gcf,[figpath 'KELSDTS_PrComp'], 'epsc')

%% 5 large scal diss potential
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(t_1,-kappa*denp_1./(fenk_1/pi),'LineWidth',1, 'DisplayName', '0.1'), hold on
plot(t1,-kappa*denp1./(fenk1/pi),'LineWidth',1, 'DisplayName', '1'), hold on
plot(t10,-kappa*denp10./(fenk10/pi),'LineWidth',1, 'DisplayName', '10'), hold on

ylabel('$\frac{\pi \kappa <\theta \nabla^{2}\theta>}{\Delta T<\psi_x \theta> }$', 'FontSize', labelFS);
xlabel('$t\,(s)$', 'FontSize', labelFS);
lgnd = legend('Location', 'Best', 'FontSize', numFS);
title(lgnd,'$Pr$', 'FontSize', numFS)
saveas(gcf,[figpath 'PELSDTS_PrComp'], 'epsc')



