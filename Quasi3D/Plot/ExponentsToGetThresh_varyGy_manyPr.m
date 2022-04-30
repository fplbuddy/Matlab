run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Pr_list = [100 10 0.3 0.1];
Ra = 2e9; Pr = 100; type = 'Shearing';
Nx = 1024; Ny = 512;
figure('Renderer', 'painters', 'Position', [5 5 600 250])
for j=1:length(Pr_list)
    Pr = Pr_list(j); PrS = normaltoS(Pr,'Pr',1);
    [~,exponent,Ly_list] = CritLyFromData(Ra,Pr,type, Nx,Ny,AllData);
    % add to plot
    plot(Ly_list ,exponent,'.','MarkerSize',MS*3, 'DisplayName',num2str(Pr)), hold on
end


lgnd = legend('Location', 'Best', 'FontSize', numFS);
title(lgnd,'$Pr$', 'FontSize', numFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('Exponent','FontSize',labelFS)
xlabel('$\Gamma_y$','FontSize',labelFS)
RaT = RatoRaT(Ra); 
title(['$Ra=' RaT '$, ' type], 'FontSize',labelFS)
%saveas(gcf,[figpath 'exponent_' RaS  '_manyPr_' type], 'epsc')


