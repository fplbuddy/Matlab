run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Ly = 0.25; Pr = 10; Ra = 8e6;
LyS = normaltoS(Ly,'Ly',1); PrS = normaltoS(Pr,'Pr',1); RaS = normaltoS(Ra,'Ra',1);
%Nx = 256; Ny = 256; 
%NS = ['N_' num2str(Nx) 'x' num2str(Ny)];
%type = 'Shearing';
%IC = ['IC_' type(1)];
%path = AllData.(IC).(NS).(PrS).(RaS).(LyS).path;
dt = 2.5e-1;
dtS = normaltoS(dt, 'dt',1);
path = ['/Volumes/Samsung_T5/ForDist/IC_S/N_256x256/Pr_1e1/Ra_8e6/Ly_2_5e_1/' dtS];
kenergy2 = importdata([path '/Checks/kenergy2.txt']);
kenergy = importdata([path '/Checks/kenergy.txt']);
%%
figure()
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
sgtitle(['$dt = ' RatoRaT(dt) '$'])
LyS = convertStringsToChars(LyS); PrS = convertStringsToChars(PrS);  RaS = convertStringsToChars(RaS);
%close all

%plot(kenergy(:,5))
%saveas(gcf,[figpath LyS '_' RaS  '_' PrS '_' type], 'epsc')