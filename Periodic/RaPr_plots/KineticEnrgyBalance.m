o1 = 8; o2 = 1; 
Pr = 0.1; Ra = 7e91; f = 0; hnu = 1; 
[nu,kappa] = nukappa(o1,Ra,Pr);
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
PrS =normaltoS(Pr, 'Pr',1); RaS =normaltoS(Ra, 'Ra',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
n = 512;
ns = ['n_' num2str(n)];
path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(PrS).(RaS).path;
kenergy = importdata([path '/Checks/kenergy.txt']);
t = kenergy(:,1);
dis = kenergy(:,3);
fin = kenergy(:,4);
henk = kenergy(:,5);
%%
figure('Renderer', 'painters', 'Position', [5 5 540 300])
plot(t,(dis*nu+hnu*henk),'DisplayName', '$\langle \nu u\cdot\nabla^{2n}u + \mu u\cdot \nabla^{-1}u \rangle $'), hold on
plot(t,fin,'DisplayName', '$\langle \theta \psi_x \rangle$')
xlim([100 1000])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t\,(s)$')
lgnd = legend('Location', 'best', 'FontSize', numFS);
title(['$ Ra = ' RaT ',\, Pr = ' PrT '$' ', Kinetic Energy Balance'], 'FontSize',labelFS)
%nuS = convertStringsToChars(nuS); kappaS = convertStringsToChars(kappaS); 
saveas(gcf,[figpath 'KEnergyBalance_' PrS '_' RaS], 'epsc')

