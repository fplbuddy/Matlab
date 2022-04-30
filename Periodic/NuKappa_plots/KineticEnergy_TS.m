close all
o1 = 1; o2 = 1;
nu = 5e-3; kappa = 2e-2; f = 0; hnu = 1; 
fS = normaltoS(f, 'f'); hnuS = normaltoS(hnu, 'hnu');
nuS = nutonuS(nu); kappaS = kappatokappaS(kappa);
o1S = normaltoS(o1, 'o1'); o2S = normaltoS(o2, 'o2');
run /Users/philipwinchester/Dropbox/Matlab/Periodic/Plot/SetUp.m
n = 1024;
ns = ['n_' num2str(n)];
%%
path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
kenergy = importdata([path '/Checks/kenergy.txt']);
penergy = importdata([path '/Checks/penergy.txt']);
ken =  kenergy(:,2);
pen =  penergy(:,2);
t = kenergy(:,1);
%trans = AllData.n_32.(nuS).(kappaS).trans;
%t = t(trans:end); OneZero = OneZero(trans:end);
% non-dim
%OneZero = OneZero/kappa;
%t = t/((2*pi)^2/kappa);
%%
figure('Renderer', 'painters', 'Position', [5 5 540 200])
%semilogy(t,ken,'LineWidth',1), hold on
plot(ken,'LineWidth',1), hold on
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



