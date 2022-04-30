%% Load data
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
IC = 'IC_S';
res = 'N_256x256';
Pr = 10; PrS = normaltoS(Pr,'Pr',1);
Ra = 8e6; RaS =  normaltoS(Ra,'Ra',1);
Gy = 0.25; GyS = normaltoS(Gy,'Gy',1);
dt = 5e-3; dtS = normaltoS(dt,'dt',1);
%% plot the steps
figure()
step_list = [2 4 8 16 32 64];
for i=1:length(step_list)
    rstep = step_list(i)
    rstepS = normaltoS(rstep,'rstep',1);
    path = ['/Volumes/Samsung_T5/Coherance/' IC '/' res '/' PrS '/' RaS '/' GyS '/' dtS '/' rstepS];
    kenergy2 = importdata([path '/Checks/kenergy2.txt']);
    semilogy(kenergy2(:,1), kenergy2(:,2),'DisplayName',num2str(rstep)), hold on
end
%% now add the one with no random bit
GyS = normaltoS(Gy,'Ly',1);
path = ['/Volumes/Samsung_T5/ForDist/IC_S/N_256x256/' PrS '/' RaS '/'  GyS '/' dtS];
kenergy2 = importdata([path '/Checks/kenergy2.txt']);
semilogy(kenergy2(:,1), kenergy2(:,2),'DisplayName','$\infty$'), hold on
ylabel('$<(\nabla\psi^{\perp})^2>$')
xlabel('$t\,  (s)$','FontSize',labelFS)
GyT = RatoRaT(Gy); RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
sgtitle(['$\Gamma_y=' GyT ',\, Ra = ' RaT ',\, Pr = ' PrT '$'], 'FontSize',labelFS)
ylim([1e-100 1e-30])
lgnd = legend();
title(lgnd,'$N$')
%saveas(gcf,[figpath 'RanFieldTSComp'], 'epsc')