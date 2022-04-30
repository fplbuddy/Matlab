o1 = 4; o2 = 1;
f = 0; hnu = 1; 
nu = 1e-15; kappa = 1e-14;
n = 1024;
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
nuS = normaltoS(nu, 'nu',1); kappaS =normaltoS(kappa, 'kappa',1); ns = ['n_' num2str(n)];


path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
penergy = importdata([path '/Checks/penergy.txt']);
kenergy = importdata([path '/Checks/kenergy.txt']);
t = penergy(:,1);
dis = penergy(:,3);
fin = kenergy(:,4);

%%
figure()
plot(t,dis*kappa,'DisplayName', '$\kappa\langle \theta\nabla^{2n}\theta\rangle $'), hold on
plot(t,fin/(2*pi),'DisplayName', '$\langle \theta \psi_x \rangle/2\pi$')
%xlim([300 t(end)])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t\,(s)$')
lgnd = legend('Location', 'best', 'FontSize', numFS);
title('Potential Energy Balance', 'FontSize',labelFS)
nuS = convertStringsToChars(nuS); kappaS = convertStringsToChars(kappaS); 
%saveas(gcf,[figpath 'PEnergyBalance_' nuS '_' kappaS], 'epsc')
%close all



