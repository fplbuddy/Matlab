close all
o1 = 1; o2 = 0; 
nu = 5e-3; kappa = 5e-4; f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
nuS = normaltoS(nu, 'nu',1); kappaS = normaltoS(kappa, 'kappa',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
run SetUp.m
n = 1024;
ns = ['n_' num2str(n)];
%% Data
path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
kenergy = importdata([path '/Checks/kenergy.txt']);
ken =  kenergy(:,2);
t = kenergy(:,1);
denk =  kenergy(:,3); 
fenk =  kenergy(:,4); % injection
henk =  kenergy(:,5);

trans = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).trans;


%% figure
figure()
plot(t(trans:end),ken(trans:end),'DisplayName','$<\psi_x^2 + \psi_y^2>$'), hold on
plot(t(trans:end),fenk(trans:end),'DisplayName','$<\psi \theta_x>$')
plot(t(trans:end),nu*denk(trans:end),'DisplayName','$\nu<\psi \nabla^4 \psi>$')
plot(t(trans:end),hnu*henk(trans:end),'DisplayName','$\mu<\psi \nabla^{2(1-m)} \psi>$')
lgnd = legend();
xlabel('$t\,(s)$');
title(['$ \nu = ' RatoRaT(nu) ',\, \kappa = ' RatoRaT(kappa) ',\, \mu = ' RatoRaT(hnu) ',\, m=' num2str(o2) '$'])
saveas(gcf,[figpath 'KEBudget_' nuS '_' kappaS '_m_' num2str(o2)], 'epsc')



