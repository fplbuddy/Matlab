run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Ra = 2e9; Pr = Inf; type = 'NonShearing';
Nx = 1024; Ny = 512;
[crit,exponent,Ly_list] = CritLyFromData(Ra,Pr,type, Nx,Ny,AllData);
figure('Renderer', 'painters', 'Position', [5 5 600 250])
plot(Ly_list,exponent,'.','MarkerSize',MS*3)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('Exponent','FontSize',labelFS)
xlabel('$\Gamma_y$','FontSize',labelFS)
RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
title(['$Ra=' RaT ',\, Pr = ' PrT '$, ' type], 'FontSize',labelFS)
%saveas(gcf,[figpath 'exponent_' RaS  '_' PrS '_' type], 'epsc')