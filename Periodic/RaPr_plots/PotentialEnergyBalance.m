o1 = 8; o2 = 1; 
Pr = 1; Ra = 7e91; f = 0; hnu = 1; 
[nu,kappa] = nukappa(o1,Ra,Pr);
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
PrS =normaltoS(Pr, 'Pr',1); RaS =normaltoS(Ra, 'Ra',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
n = 512;
ns = ['n_' num2str(n)];
path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(PrS).(RaS).path;
penergy = importdata([path '/Checks/penergy.txt']);
kenergy = importdata([path '/Checks/kenergy.txt']);
t = penergy(:,1);
dis = penergy(:,3);
fin = kenergy(:,4);

%%
figure('Renderer', 'painters', 'Position', [5 5 540 300])
plot(t,dis*kappa,'DisplayName', '$\kappa\langle \theta \cdot\nabla^{2n}\theta\rangle $'), hold on
plot(t,fin/(2*pi),'DisplayName', '$\langle \theta \psi_x \rangle/2\pi$')
xlim([100 1000])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t\,(s)$')
lgnd = legend('Location', 'best', 'FontSize', numFS);
title(['$ Ra = ' RaT ',\, Pr = ' PrT '$' ', Potential Energy Balance'], 'FontSize',labelFS)
RaS = convertStringsToChars(RaS); PrS = convertStringsToChars(PrS); 
%saveas(gcf,[figpath 'PEnergyBalance_' PrS '_' RaS], 'epsc')



