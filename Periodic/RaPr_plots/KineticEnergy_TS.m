close all
o1 = 1; o2 = 1;
Ra = 6e6; Pr = 100; f = 0; hnu = 1; 
fS = normaltoS(f, 'f'); hnuS = normaltoS(hnu, 'hnu');
PrS =normaltoS(Pr, 'Pr'); RaS =normaltoS(Ra, 'Ra');
o1S = normaltoS(o1, 'o1'); o2S = normaltoS(o2, 'o2');
run SetUp.m
n = 512;
ns = ['n_' num2str(n)];
%%
path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(PrS).(RaS).path;
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
loglog(ken,'LineWidth',1), hold on
%plot(t, ken,'LineWidth',1), hold on
%figure('Renderer', 'painters', 'Position', [5 5 540 200])
%semilogy(t,ken,'LineWidth',1), hold on
%plot(t, pen,'LineWidth',1), hold on
PrT = RatoRaT(Pr);
RaT = RatoRaT(Ra);
hnuT = RatoRaT(hnu);
title(['$ Pr =' PrT '\, , Ra = ' RaT '\, , \mu = ' hnuT '$'  ],'FontSize',labelFS);
ylabel('Kinetic Energy', 'FontSize', labelFS);
xlabel('$t\,(s)$', 'FontSize', labelFS);
%[alpha1, ~, ~, ~, ~] = Fitslogy(t,OneZero)
PrS = convertStringsToChars(PrS);
RaS = convertStringsToChars(RaS);
hnuS = convertStringsToChars(hnuS);
%saveas(gcf,[figpath 'KETS_' PrS '_' RaS '_'  hnuS], 'epsc')



