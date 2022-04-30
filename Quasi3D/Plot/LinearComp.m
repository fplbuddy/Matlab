dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
%spath = [pwd '/NewData.mat'];
load(dpath);
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Ly = 0.5; Pr = 10; Ra = 1e7;
LyS = normaltoS(Ly,'Ly'); PrS = normaltoS(Pr,'Pr'); RaS = normaltoS(Ra,'Ra');
N = 256;
NS = ['N_' num2str(256) 'x' num2str(256)];
type = 'NonShearing';
IC = ['IC_' type(1)];
path = AllData.(IC).(NS).(PrS).(RaS).(LyS).path;
kenergy2 = importdata([path '/Checks/kenergy2.txt']);

%% Getting from data
GyS = normaltoS(Ly,'Gy');
decay = max(real(Data.AR_2.OneOne256.Pr_10.(RaS).Gy_0_5.sigmaodd));
kappa =sqrt((pi)^3/(Pr*Ra));
decay = decay*kappa*2/pi^2;
%%
figure('Renderer', 'painters', 'Position', [5 5 540 540])
semilogy(kenergy2(:,1), kenergy2(:,2),'b','LineWidth',1), hold on
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$<\psi^2_{3D}>$','FontSize',labelFS)
xlabel('$t\,  (s)$','FontSize',labelFS)
LyT = RatoRaT(Ly); RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
sgtitle(['$\Gamma_y=' LyT ',\, Ra = ' RaT ',\, Pr = ' PrT '$, ' type], 'FontSize',labelFS)
LyS = convertStringsToChars(LyS); PrS = convertStringsToChars(PrS);  RaS = convertStringsToChars(RaS);
%% make thing on top
t = kenergy2(:,1);
s = kenergy2(:,2);
start = round(length(s)/10);
en = round(length(s)/3);
y1 = s(start);
x1 = t(start);
A = y1/(exp(x1*decay));
x2 = t(en);
y2 = A*exp(x2*decay);
plot([x1 x2], [y1 y2], 'red','LineWidth',1)


%close all

%plot(kenergy(:,5))
saveas(gcf,[figpath 'EigenComp' LyS '_' RaS  '_' PrS '_' type], 'epsc')