%% Load data
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
IC = 'IC_S';
res = 'N_256x256';
Pr = 10; PrS = normaltoS(Pr,'Pr',1);
Ra = 8e6; RaS =  normaltoS(Ra,'Ra',1);
Gy = 0.25; GyS = normaltoS(Gy,'Gy',1);
%% plot the steps
figure()
set(subplot(1,1,1), 'Position', [0.13, 0.15, 0.8, 0.68])
pm_list = [2e2 1e3 1e4];
for i=1:length(pm_list)
    pm = pm_list(i);
    pmS = normaltoS(pm,'pm',1);
    path = ['/Volumes/Samsung_T5/Quasi_filtering/' IC '/' res '/' PrS '/' RaS '/' GyS '/' pmS ];
    kenergy2 = importdata([path '/Checks/kenergy2.txt']);
    semilogy(kenergy2(:,1), kenergy2(:,2),'DisplayName',num2str(pm)), hold on
end
%% now add the one with no random bit
dt = 5e-3; dtS = normaltoS(dt,'dt',1);
GyS = normaltoS(Gy,'Ly',1);
path = ['/Volumes/Samsung_T5/ForDist/IC_S/N_256x256/' PrS '/' RaS '/'  GyS '/' dtS];
kenergy2 = importdata([path '/Checks/kenergy2.txt']);
semilogy(kenergy2(:,1), kenergy2(:,2),'DisplayName','$28900$'), hold on
%% make figure
ylabel('$<(\nabla\psi^{\perp})^2>$')
xlabel('$t\,  (s)$','FontSize',labelFS)
GyT = RatoRaT(Gy); RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
ylim([1e-100 1e50])
lgnd = legend();
title(lgnd,'$k^2_{max}$')
sgtitle({['$\Gamma_y=' GyT ',\, Ra = ' RaT ',\, Pr = ' PrT '$'],'$k^2 = (2\pi k_x/L_x)^2 + (\pi k_y/L_y)^2,\, L_x = 2\pi,\, L_y = \pi$'}, 'FontSize',labelFS)
saveas(gcf,[figpath 'Filtering'], 'epsc')