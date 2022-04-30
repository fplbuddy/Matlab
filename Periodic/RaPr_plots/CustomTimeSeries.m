% set up
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
path = '/Volumes/Samsung_T5/Periodic/n_1024/o1_1e0/o2_1e0/f_0e1/hnu_1e0/nu_5e_3/kappa_5e_3/Checks/kenergy.txt';
data = importdata(path);
xloc = 1;
yloc = 4;
%ylab = '$<\theta^2>$';
%xlab = '$t (s)$';
%Pr = inf; 
%PrS = normaltoS(Pr, 'Pr',1); PrT = RatoRaT(Pr);
%PrT = '\infty'; PrS = 'Pr_inf';
%Ra = 1e7; RaS = normaltoS(Ra, 'Ra',1); RaT = RatoRaT(Ra);

%%
figure('Renderer', 'painters', 'Position', [5 5 600 250])
plot(data(:,xloc), data(:,yloc), 'LineWidth',1)
xlabel(xlab,'FontSize',labelFS);
ylabel(ylab,'FontSize',labelFS);
ax = gca;
ax.FontSize = numFS;
title(['$Ra = ' RaT ',\, Pr = ' PrT '$'],'FontSize',labelFS)
ylabclean = Myerase(ylab,["$", "<", ">", "\" "^"]);
saveas(gcf,[figpath RaS PrS ylabclean], 'epsc')

