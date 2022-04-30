run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Ly = 1; Pr = 30; Ra = 1e6;
LyS = normaltoS(Ly,'Ly',1); PrS = normaltoS(Pr,'Pr',1); RaS = normaltoS(Ra,'Ra',1);
GyS = normaltoS(Ly,'Gy',1);
Nx = 128; Ny = 128; 
NS = ['N_' num2str(Nx) 'x' num2str(Ny)];
type = 'NonShearing';
IC = ['IC_' type(1)];
path = AllData.(IC).(NS).(PrS).(RaS).(LyS).path;
kenergy2 = importdata([path '/Checks/kenergy2.txt']);
kenergy = importdata([path '/Checks/kenergy.txt']);
%%
figure('Renderer', 'painters', 'Position', [5 5 540 540])
subplot(2,1,1)
plot(kenergy(:,1), kenergy(:,5))
ylabel('$\widehat \psi_{0,1}$','FontSize',labelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;

subplot(2,1,2)
t = kenergy2(:,1); sig = kenergy2(:,2);
semilogy(t, sig), hold on
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$<(\nabla\psi_{3D})^2>$','FontSize',labelFS)
xlabel('$t\,  (s)$','FontSize',labelFS)
LyT = RatoRaT(Ly); RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
sgtitle(['$\Gamma_y=' LyT ',\, Ra = ' RaT ',\, Pr = ' PrT '$, ' type], 'FontSize',labelFS)
LyS = convertStringsToChars(LyS); PrS = convertStringsToChars(PrS);  RaS = convertStringsToChars(RaS);
alpha = max(real(DataMeanField.(IC).(NS).(PrS).(RaS).(GyS).sigma));
kappa = sqrt((pi)^3/(Ra*Pr));
alpha = 2*alpha*kappa/pi^2; % 2 from that we have energy
plot([0 t(end)],[sig(1) sig(1)*exp(t(end)*alpha)],'--r')
%close all

%plot(kenergy(:,5))
saveas(gcf,[figpath 'EigenComp' LyS '_' RaS  '_' PrS '_' type], 'epsc')