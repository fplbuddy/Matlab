%% Load data
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
IC = 'IC_S';
res = 'N_256x256';
Pr = 10; PrS = normaltoS(Pr,'Pr',1);
Ra = 8e6; RaS =  normaltoS(Ra,'Ra',1);
Gy = 0.25; GyS = normaltoS(Gy,'Gy',1);
dt = 5e-3; dtS = normaltoS(dt,'dt',1);
%% Make plots for where we have rstep
step_list = [2];
for i=1:length(step_list)
    rstep = step_list(i);
    rstepS = normaltoS(rstep,'rstep',1);
    path = ['/Volumes/Samsung_T5/Coherance/' IC '/' res '/' PrS '/' RaS '/' GyS '/' dtS '/' rstepS];
    kenergy2 = importdata([path '/Checks/kenergy2.txt']);
    t = kenergy2(:,1);
    S = kenergy2(:,2);
    clear kenergy2
    w = zeros(1,length(t)-1);
    for j=1:length(w)
        w(j) = log(S(j+1)/S(j));
    end
    figure()
    histogram(w)
    xlabel('$\log({\frac{(<\nabla\psi_{\perp})^2>(t+d t)}{<(\nabla\psi_{\perp})^2>(t)}})$')
    title(['$ dt = ' num2str(dt) ',\, N =' num2str(rstep) '$'])
    %saveas(gcf,[figpath 'Dist_N_' num2str(rstep)], 'epsc')
    % make CDF
    cdfplot(w), hold on
    plot([-3e-3 5e-3], [0.75 0.75], '--r')
    ylabel('Empirical CDF')
    xlabel('$\log({\frac{(<\nabla\psi_{\perp})^2>(t+d t)}{<(\nabla\psi_{\perp})^2>(t)}})$')
    title(['$ dt = ' num2str(dt) ',\, N =' num2str(rstep) '$'])
    saveas(gcf,[figpath 'CDF_N_' num2str(rstep)], 'epsc')
end

%% Make plots with no random
GyS = normaltoS(Gy,'Ly',1);
path = ['/Volumes/Samsung_T5/ForDist/IC_S/N_256x256/' PrS '/' RaS '/'  GyS '/' dtS];
kenergy2 = importdata([path '/Checks/kenergy2.txt']);
t = kenergy2(:,1);
S = kenergy2(:,2);
clear kenergy2
w = zeros(1,length(t)-1);
for j=1:length(w)
    w(j) = log(S(j+1)/S(j));
end
figure()
histogram(w)
xlabel('$\log({\frac{(<\nabla\psi_{\perp})^2>(t+d t)}{<(\nabla\psi_{\perp})^2>(t)}})$')
title(['$ dt = ' num2str(dt) ',\, N =\infty $'])
saveas(gcf,[figpath 'Dist_N_inf'], 'epsc')

