run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Pr_list = [0.1 1 10 30 100];
% NEED TO CHANGE
RaC_0_25_Shearing = [1.6e6 8e7 8e6 1.7e7 3.5e7];
RaC_0_5_Shearing = [0 1e7 2e6 2e6 2e7];
RaC_1_Shearing = [0 8e5 2e6 2e6 2e7];

RaC_0_25_NonShearing = [0 0 0 0 3.5e7];
RaC_0_5_NonShearing = [0 0 0 3.9e6 3.5e6];
RaC_1_NonShearing = [0 0 0 5e5 8e5];

figure()
loglog(Pr_list,RaC_0_25_Shearing,'b.-', 'MarkerSize',MS*2, 'LineWidth',1,'DisplayName','$0.25$, Shearing'), hold on
loglog(Pr_list,RaC_0_5_Shearing,'r.-', 'MarkerSize',MS*2, 'LineWidth',1,'DisplayName','$0.5$, Shearing')
loglog(Pr_list,RaC_1_Shearing,'g.-', 'MarkerSize',MS*2, 'LineWidth',1,'DisplayName','$1$, Shearing')
loglog(Pr_list,RaC_0_25_NonShearing,'b*-', 'MarkerSize',MS, 'LineWidth',1,'DisplayName','$0.25$, NonShearing')
loglog(Pr_list,RaC_0_5_NonShearing,'r*-', 'MarkerSize',MS, 'LineWidth',1,'DisplayName','$0.5$, NonShearing')
loglog(Pr_list,RaC_1_NonShearing,'g*-', 'MarkerSize',MS, 'LineWidth',1,'DisplayName','$1$, NonShearing')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$Ra$','FontSize',labelFS)
xlabel('$Pr$','FontSize',labelFS)
lgnd = legend('Location', 'Bestoutside', 'FontSize', labelFS); 
title(lgnd,'$\Gamma_y$, FlowType', 'FontSize', labelFS)
saveas(gcf,[figpath 'RaC_Quasi_PrRa'], 'epsc')