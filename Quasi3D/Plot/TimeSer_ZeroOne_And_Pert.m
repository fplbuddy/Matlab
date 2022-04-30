run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Ly = 0.03; Pr = 0.06; Ra = 2e9;
LyS = normaltoS(Ly,'Ly',1); PrS = normaltoS(Pr,'Pr',1); RaS = normaltoS(Ra,'Ra',1);
Nx = 1024; Ny = 512; 
NS = ['N_' num2str(Nx) 'x' num2str(Ny)];
type = 'Shearing';
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
semilogy(kenergy2(:,1), kenergy2(:,2))
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$<(\nabla\psi_{3D})^2>$','FontSize',labelFS)
xlabel('$t\,  (s)$','FontSize',labelFS)
LyT = RatoRaT(Ly); RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
sgtitle(['$\Gamma_y=' LyT ',\, Ra = ' RaT ',\, Pr = ' PrT '$, ' type], 'FontSize',labelFS)
LyS = convertStringsToChars(LyS); PrS = convertStringsToChars(PrS);  RaS = convertStringsToChars(RaS);

%close all
% figure()
% semilogy(kenergy2(:,2))
%saveas(gcf,[figpath LyS '_' RaS  '_' PrS '_' type], 'epsc')