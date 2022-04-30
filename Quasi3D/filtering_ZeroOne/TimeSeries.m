%% Load data
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
IC = 'IC_S';
res = 'N_256x256';
Pr = 10; PrS = normaltoS(Pr,'Pr',1);
Ra = 8e6; RaS =  normaltoS(Ra,'Ra',1);
Gy = 0.25; GyS = normaltoS(Gy,'Gy',1);
%% plot the steps
figure()
%set(subplot(1,1,1), 'Position', [0.13, 0.15, 0.8, 0.68])
filter_list = [0 0.25 0.5 0.75 0.9 0.99];
for i=1:length(filter_list)
    filter = filter_list(i);
    filterS = normaltoS(filter,'frac',1);
    path = ['/Volumes/Samsung_T5/FilterZeroOne/' IC '/' res '/' PrS '/' RaS '/' GyS '/' filterS ];
    kenergy2 = importdata([path '/Checks/kenergy2.txt']);
    semilogy(kenergy2(:,1), kenergy2(:,2),'DisplayName',num2str(filter)), hold on
end
%% now add the one with no random bit
dt = 5e-3; dtS = normaltoS(dt,'dt',1);
GyS = normaltoS(Gy,'Ly',1);
path = ['/Volumes/Samsung_T5/ForDist/IC_S/N_256x256/' PrS '/' RaS '/'  GyS '/' dtS];
kenergy2 = importdata([path '/Checks/kenergy2.txt']);
semilogy(kenergy2(:,1), kenergy2(:,2),'DisplayName','$1$'), hold on
%% make figure
ylabel('$<(\nabla\psi^{\perp})^2>$')
xlabel('$t\,  (s)$','FontSize',labelFS)
GyT = RatoRaT(Gy); RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
ylim([1e-100 1e50])
lgnd = legend();
title(lgnd,'$f$')
sgtitle(['$\Gamma_y=' GyT ',\, Ra = ' RaT ',\, Pr = ' PrT '$'], 'FontSize',labelFS)
saveas(gcf,[figpath 'Frac_filtering'], 'epsc')