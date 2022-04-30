run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Ly = 0.5; Pr = 30; Ra = 6e6;
LyS = normaltoS(Ly,'Ly'); PrS = normaltoS(Pr,'Pr'); RaS = normaltoS(Ra,'Ra');
N = 256;
NS = ['N_' num2str(256) 'x' num2str(256)];
type = 'NonShearing';
IC = ['IC_' type(1)];
path = AllData.(IC).(NS).(PrS).(RaS).(LyS).path;
penergy2 = importdata([path '/Checks/penergy2.txt']);
%%



%[alpha2, ~, ~, ~, ~] = Fitslogy(kenergy2(:,1),abs(kenergy2(:,2)-A*exp(alpha1*kenergy2(:,1))));



% subplot(2,1,1)
% plot(kenergy(:,1), kenergy(:,5))
% ylabel('$\widehat \psi_{0,1}$','FontSize',labelFS)
% ax = gca;
% ax.XAxis.FontSize = numFS;
% ax.YAxis.FontSize = numFS;
% 
% subplot(2,1,2)
% semilogy(kenergy2(:,1), kenergy2(:,2))
% ax = gca;
% ax.XAxis.FontSize = numFS;
% ax.YAxis.FontSize = numFS;
% ylabel('$<\psi^2_{3D}>$','FontSize',labelFS)
% xlabel('$t\,  (s)$','FontSize',labelFS)
% LyT = RatoRaT(Ly); RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
% sgtitle(['$\Gamma_y=' LyT ',\, Ra = ' RaT ',\, Pr = ' PrT '$, ' type], 'FontSize',labelFS)
% LyS = convertStringsToChars(LyS); PrS = convertStringsToChars(PrS);  RaS = convertStringsToChars(RaS); 
% 
% 
% 
% [alpha, ~, xFitted, yFitted, ~] = Fitslogy(kenergy2(:,1),kenergy2(:,2));