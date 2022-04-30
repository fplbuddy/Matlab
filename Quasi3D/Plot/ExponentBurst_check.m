nu = sqrt(pi^3/6e6);
comp = (nu*(2*pi)^2)*2;
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
%% 0.25
Ly = 0.25; Pr = 1; Ra = 6e6;
LyS = normaltoS(Ly,'Ly',1); PrS = normaltoS(Pr,'Pr',1); RaS = normaltoS(Ra,'Ra',1);
N = 256;
NS = ['N_' num2str(N) 'x' num2str(N)];
type = 'Shearing';
IC = ['IC_' type(1)];
path = AllData.(IC).(NS).(PrS).(RaS).(LyS).path;
penergy2 = importdata([path '/Checks/penergy2.txt']);
%alpha0_25 = BurstExponent(AllData,Ly,Pr,Ra,N,type,50);
alpha0_25 = -0.234;
figure()
semilogy(penergy2(:,1), penergy2(:,2),'b-','LineWidth',1), hold on
y = penergy2(:,2); y1 = y(1);
x = penergy2(:,1); x1 = x(1); x2 = 2e3; %x2 = x(end);
A = y1/exp(alpha0_25*x1);
y2 = A*exp(alpha0_25*x2);
plot([x1 x2],[y1 y2],'r-','LineWidth',1);

ylabel('$<\theta^2_{\perp}>$','FontSize',labelFS)
xlabel('$t\,  (s)$','FontSize',labelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
LyT = RatoRaT(Ly); RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
sgtitle(['$\Gamma_y=' LyT ',\, Ra = ' RaT ',\, Pr = ' PrT '$, ' type], 'FontSize',labelFS)
saveas(gcf,[figpath 'PertWithFit_' LyS '_' RaS  '_' PrS '_' type], 'epsc')


%% 0.5
Ly = 0.5; Pr = 1; Ra = 6e6;
LyS = normaltoS(Ly,'Ly',1); PrS = normaltoS(Pr,'Pr',1); RaS = normaltoS(Ra,'Ra',1);
N = 256;
NS = ['N_' num2str(N) 'x' num2str(N)];
type = 'Shearing';
IC = ['IC_' type(1)];
path = AllData.(IC).(NS).(PrS).(RaS).(LyS).path;
penergy2 = importdata([path '/Checks/penergy2.txt']);
%alpha0_5 = BurstExponent(AllData,Ly,Pr,Ra,N,type,50);
alpha0_5 = alpha0_25 + comp/(pi/4)^2-comp/(pi/2)^2;
figure()
semilogy(penergy2(:,1), penergy2(:,2),'b-','LineWidth',1), hold on
y = penergy2(:,2); y1 = y(1);
x = penergy2(:,1); x1 = x(1); x2 = 7e3; %x2 = x(end);
A = y1/exp(alpha0_5*x1);
y2 = A*exp(alpha0_5*x2);
plot([x1 x2],[y1 y2],'r-','LineWidth',1);

ylabel('$<\theta^2_{\perp}>$','FontSize',labelFS)
xlabel('$t\,  (s)$','FontSize',labelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
LyT = RatoRaT(Ly); RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
sgtitle(['$\Gamma_y=' LyT ',\, Ra = ' RaT ',\, Pr = ' PrT '$, ' type], 'FontSize',labelFS)
saveas(gcf,[figpath 'PertWithFit_' LyS '_' RaS  '_' PrS '_' type], 'epsc')

%% 1
Ly = 1; Pr = 1; Ra = 6e6;
LyS = normaltoS(Ly,'Ly',1); PrS = normaltoS(Pr,'Pr',1); RaS = normaltoS(Ra,'Ra',1);
N = 256;
NS = ['N_' num2str(N) 'x' num2str(N)];
type = 'Shearing';
IC = ['IC_' type(1)];
path = AllData.(IC).(NS).(PrS).(RaS).(LyS).path;
penergy2 = importdata([path '/Checks/penergy2.txt']);
%alpha1 = BurstExponent(AllData,Ly,Pr,Ra,N,type,50);
alpha1 = alpha0_25 + comp/(pi/4)^2-comp/(pi)^2;
figure()
semilogy(penergy2(:,1), penergy2(:,2),'b-','LineWidth',1), hold on
y = penergy2(:,2); y1 = y(1);
x = penergy2(:,1); x1 = x(1); x2 = 8e3; %x2 = x(end);
A = y1/exp(alpha1*x1);
y2 = A*exp(alpha1*x2);
plot([x1 x2],[y1 y2],'r-','LineWidth',1);

ylabel('$<\theta^2_{\perp}>$','FontSize',labelFS)
xlabel('$t\,  (s)$','FontSize',labelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
LyT = RatoRaT(Ly); RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
sgtitle(['$\Gamma_y=' LyT ',\, Ra = ' RaT ',\, Pr = ' PrT '$, ' type], 'FontSize',labelFS)
saveas(gcf,[figpath 'PertWithFit_' LyS '_' RaS  '_' PrS '_' type], 'epsc')

%% compare
check0_25 = alpha0_25 + comp/(0.25*pi)^2;
check0_5 = alpha0_5 + comp/(0.5*pi)^2;
check1 = alpha1 + comp/pi^2;

