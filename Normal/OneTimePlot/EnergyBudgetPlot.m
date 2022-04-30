run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Pr_list = [100 10 1 0.1];
Ra_list = [2e9 2e8 2e7 2e6];
kappa_list = (sqrt((Pr_list.*Ra_list)/pi^3)).^(-1);
nu_list = kappa_list.*Pr_list;
quantities = ["fenk" "ken" "pen" "denk" "denp"];
ARS = 'AR_2';
err = 50;
% boulding data
for i=1:length(Pr_list)
    Pr = Pr_list(i); Ra = Ra_list(i);
    PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
    for j=1:length(quantities)
        quant = convertStringsToChars(quantities(j));
        data.(quant)(i) = AllData.(ARS).(PrS).(RaS).calcs.(quant);
        data.([quant 'err'])(i) = abs(AllData.(ARS).(PrS).(RaS).calcs.(quant) - AllData.(ARS).(PrS).(RaS).calcs.([quant 'err' num2str(err)]));
    end
end
%% figure
% energies
figure()
errorbar(Pr_list,data.ken,data.kenerr,'*','DisplayName','$\overline{<\psi_x^2+ \psi_y^2>}$','MarkerSize',MS/2), hold on
errorbar(Pr_list,data.pen,data.penerr,'*','DisplayName','$\overline{<\theta^2>}$','MarkerSize',MS/2)
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
xlabel('$Pr$')
title({'Energies', '$\nu = \sqrt{\pi^3/(2\times10^7)}\approx 1.2 \times 10^{-3}$'})
legend('Location','bestoutside');
saveas(gcf,[figpath 'EnergiesFreeSlip'], 'epsc')

% kinetic energy budget
figure()
errorbar(Pr_list,data.fenk,data.fenkerr,'*','DisplayName','$\overline{<\psi \theta_x>}$','MarkerSize',MS/2), hold on
errorbar(Pr_list,nu_list.*data.denk,nu_list.*data.denkerr,'*','DisplayName','$\nu\overline{<\psi \nabla^4 \psi>}$','MarkerSize',MS/2), hold on
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
xlabel('$Pr$')
title({'KE Budget', '$\nu = \sqrt{\pi^3/(2\times10^7)}\approx 1.2 \times 10^{-3}$'})
legend('Location','bestoutside');
saveas(gcf,[figpath 'KineticEnergyBudgetFreeSlip'], 'epsc')

% Potential Energy Budget
figure()
errorbar(Pr_list,data.fenk/pi,data.fenkerr/pi,'*','DisplayName','$\overline{<\psi_x \theta>}/\pi$','MarkerSize',MS/2), hold on
errorbar(Pr_list,kappa_list.*data.denp,kappa_list.*data.denperr,'*','DisplayName','$\kappa\overline{<\theta \nabla^2 \psi>}$','MarkerSize',MS/2), hold on
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
xlabel('$Pr$')
title({'PE Budget', '$\nu = \sqrt{\pi^3/(2\times10^7)}\approx 1.2 \times 10^{-3}$'})
legend('Location','bestoutside');
saveas(gcf,[figpath 'PotentialEnergyBudgetFreeSlip'], 'epsc')