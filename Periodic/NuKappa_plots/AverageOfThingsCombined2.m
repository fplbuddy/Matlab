run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Vary = "nu";
o1 = 1; o2 = 1;
f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
%nu = 2e-4; nuS = normaltoS(nu, 'nu',1);
kappa = 2e-4; kappaS = normaltoS(kappa, 'kappa',1);
if Vary == "kappa"
    [kappa_list,n_list] = Getkappa_list(AllData,fS,hnuS,o1S,o2S,nuS);
    nu_list =  ones(1,length(kappa_list))*nu;
    Vary = kappa_list;
    constnumS = normaltoS(nu_list(end),'nu',1);
    tit = ['Varykappa_'  constnumS '_m_' num2str(o2)];
    xlab = '$\kappa$';
    nuT = RatoRaT(nu);
    overtit = ['$\nu = ' nuT ',\, m = ' num2str(o2) '$'];
    nu_list = ones(1,length(kappa_list))*nu;
else
    [nu_list,n_list] = Getnu_list(AllData,fS,hnuS,o1S,o2S,kappaS);
    kappa_list = ones(1,length(nu_list))*kappa;
    Vary = nu_list;
    constnumS = normaltoS(kappa_list(end),'kappa',1);
    tit = ['Varynu_kappa' constnumS '_m_' num2str(o2)];
    xlab = '$\nu$';
    kappaT = RatoRaT(kappa);
    overtit = ['$\kappa = ' kappaT ',\, m = ' num2str(o2) '$'];
end
Pr_list = nu_list./kappa_list;
quantities = ["fenk" "ken" "pen" "denk" "denp" "henk"];
err = 50;
% boulding data
clear data
for i=1:length(kappa_list)
    nu = nu_list(i); kappa = kappa_list(i); n = n_list(i);
    nuS =normaltoS(nu, 'nu',1); kappaS =normaltoS(kappa, 'kappa',1); ns = ['n_' num2str(n)];
    for j=1:length(quantities)
        quant = convertStringsToChars(quantities(j));
        data.(quant)(i) = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).calcs.(quant);
        data.([quant 'err'])(i) = abs(AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).calcs.(quant) - AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).calcs.([quant 'err' num2str(err)]));
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
title({'Energies', overtit})
legend('Location','bestoutside');
%saveas(gcf,[figpath 'EnergiesPeriodic_' tit], 'epsc')

% kinetic energy budget
figure()
errorbar(Pr_list,data.fenk,data.fenkerr,'*','DisplayName','$\overline{<\psi \theta_x>}$','MarkerSize',MS/2), hold on
errorbar(Pr_list,nu_list.*data.denk,nu_list.*data.denkerr,'*','DisplayName','$\nu\overline{<\psi \nabla^4 \psi>}$','MarkerSize',MS/2)
errorbar(Pr_list,hnu*data.henk,hnu*data.henkerr,'*','DisplayName','$\mu\overline{<\psi \nabla^{2(1-m)} \psi>}$','MarkerSize',MS/2)
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
xlabel('$Pr$')
title({'KE Budget', overtit})
legend('Location','bestoutside');
%saveas(gcf,[figpath 'KineticEnergyBudgetPeriodic_' tit], 'epsc')

% Potential Energy Budget
figure()
errorbar(Pr_list,data.fenk/(2*pi),data.fenkerr/(2*pi),'*','DisplayName','$\overline{<\psi_x \theta>}/2\pi$','MarkerSize',MS/2), hold on
errorbar(Pr_list,kappa_list.*data.denp,kappa_list.*data.denperr,'*','DisplayName','$\kappa\overline{<\theta \nabla^2 \psi>}$','MarkerSize',MS/2), hold on
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
xlabel('$Pr$')
title({'PE Budget', overtit})
legend('Location','bestoutside');
%saveas(gcf,[figpath 'PotentialEnergyBudgetPeriodic_' tit], 'epsc')

%% play
semilogx(Pr_list, data.pen,'.')
