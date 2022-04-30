run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Pr_list = [1e3 1e2 10 6 3 2 1.6 1.3 1.1 1 0.9 0.6 0.4 0.3 0.2 0.1 0.06];
Ra = 2e9; type = 'Shearing';
Nx = 1024; Ny = 512;
figure()
for j=1:length(Pr_list)
    Pr = Pr_list(j); PrS = normaltoS(Pr,'Pr',1);
    if Pr == 1
       path = AllData.IC_S.N_1024x512.Pr_1e0.Ra_2e9.Ly_1e_1.path; 
       kenergy2 = importdata([path '/Checks/penergy2.txt']);
       t = kenergy2(:,1); s = kenergy2(:,2);
       [alpha, ~, ~, ~, ~] = Fitslogy(t,s);
       GyC = CritLyPr1(Ra,alpha,0.1);
       semilogx(1 ,GyC/pi,'b.','MarkerSize',MS, 'DisplayName',num2str(1)) 
       %semilogx(1 ,0.1,'.','MarkerSize',MS*3, 'DisplayName',num2str(1)) 
    else
    [GyC,~,~] = CritLyFromData(Ra,Pr,type, Nx,Ny,AllData);
    % add to plot
    semilogx(Pr ,GyC,'b.','MarkerSize',MS, 'DisplayName',num2str(Pr)), hold on
    end
end
%%
% add Inf and Pr = 1 by hand
% path = AllData.IC_S.N_1024x512.Pr_1e0.Ra_2e9.Ly_1e_1.path;
% kenergy2 = importdata([path '/Checks/penergy2.txt']);
% t = kenergy2(:,1); s = kenergy2(:,2);
% [alpha, ~, ~, ~, ~] = Fitslogy(t,s);
% GyC = CritLyPr1(2e9,alpha,0.1);
%semilogx(1 ,0.1,'.','MarkerSize',MS*3, 'DisplayName',num2str(1))
Ra = 2e9; Pr = Inf; type = 'NonShearing';
Nx = 1024; Ny = 512;
[crit,~,~] = CritLyFromData(Ra,Pr,type, Nx,Ny,AllData);
plot([1e3 10], [crit crit], 'r--','HandleVisibility','off');



%lgnd = legend('Location', 'Bestoutside', 'FontSize', numFS);
%title(lgnd,'$Pr$', 'FontSize', numFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('Crit $\Gamma_{y}$','FontSize',labelFS)
xlabel('$Pr$','FontSize',labelFS)
RaT = RatoRaT(Ra); 
title(['$Ra=' RaT '$'], 'FontSize',labelFS)
saveas(gcf,[figpath 'GyC_' RaS  '_manyPr_' type], 'epsc')