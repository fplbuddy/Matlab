run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Gy_list = [0.25 0.5 1];
% Shearing
RaC_1S = [8e7 1e7 8e5]; % NEED TO CHANGE
RaC_0_1S = [1.5e6 0 0]; % NEED TO CHANGE
% Pr = 10 list
RaC_10S = [8e6 2e6 2e6];
% Pr = 30 list
RaC_30S = [1.7e7 2e6 2e6];
% Non-Shearing
% Pr = 10 list
%RaC_10N = [8e6 2e6 2e6]; always stable
% Pr = 30 list
RaC_30N = [0 3.9e6 5e5]; % aleasy stable for 0.25
RaC_100N = [3.5e7 3.5e6 8e5]; % NEED TO CHANGE


figure()
loglog(RaC_10S,Gy_list,'.-', 'MarkerSize',MS*2, 'LineWidth',1,'DisplayName','$10$, Shearing'), hold on
loglog(RaC_30S,Gy_list,'.-', 'MarkerSize',MS*2, 'LineWidth',1,'DisplayName','$30$, Shearing')
loglog(RaC_1S,Gy_list,'.-', 'MarkerSize',MS*2, 'LineWidth',1,'DisplayName','$1$, Shearing')
loglog(RaC_0_1S,Gy_list,'.-', 'MarkerSize',MS*2, 'LineWidth',1,'DisplayName','$0.1$, Shearing')
loglog(RaC_30N,Gy_list,'*-', 'MarkerSize',MS, 'LineWidth',1,'DisplayName','$30$, NonShearing')
loglog(RaC_100N,Gy_list,'*-', 'MarkerSize',MS, 'LineWidth',1,'DisplayName','$100$, NonShearing')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$\Gamma_y$','FontSize',labelFS)
xlabel('$Ra$','FontSize',labelFS)
lgnd = legend('Location', 'Bestoutside', 'FontSize', labelFS); 
title(lgnd,'$Pr$, FlowType', 'FontSize', labelFS)
saveas(gcf,[figpath 'RaC_Quasi'], 'epsc')