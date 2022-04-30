o1 = 4; o2 = 1;
f = 0; hnu = 1; 
nu = 1e-15; kappa = 1e-13;
n = 1024;
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1 = normaltoS(o1, 'o1',1); o2 = normaltoS(o2, 'o2',1);
nuS = normaltoS(nu,'nu',1); kappaS = normaltoS(kappa,'kappa',1);
run SetUp.m
n = 1024;
ns = ['n_' num2str(n)];
path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
kenergy = importdata([path '/Checks/kenergy.txt']);
t = kenergy(:,1);
dis = kenergy(:,3);
fin = kenergy(:,4);
henk = kenergy(:,5);
%%
figure('Renderer', 'painters', 'Position', [5 5 540 300])
plot(t,(dis*nu+hnu*henk),'DisplayName', '$\langle \nu u\cdot\nabla^{2n}u + \mu u\cdot \nabla^{-1}u \rangle $'), hold on
plot(t,fin,'DisplayName', '$\langle \theta \psi_x \rangle$')
%xlim([100 1000])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t\,(s)$')
lgnd = legend('Location', 'best', 'FontSize', numFS);
title('HV Kinetic Energy Balance', 'FontSize',labelFS)
nuS = convertStringsToChars(nuS); kappaS = convertStringsToChars(kappaS); 
%saveas(gcf,[figpath 'KEnergyBalance_' nuS '_' kappaS], 'epsc')

