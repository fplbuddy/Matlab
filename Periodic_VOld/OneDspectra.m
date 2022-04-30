addpath('/Users/philipwinchester/Dropbox/Matlab/Periodic/Plot')
run SetUp.m
%%
nu = 3e-3; nuS = nutonuS(nu);
path = '/Volumes/Samsung_T5/Periodic_Vold/n_256/NV3';
spath = [path '/Spectra/'];
times = importdata([spath 'spec_times.txt']);
kenergy = importdata([path '/Checks/kenergy.txt']);
t = kenergy(:,1);
trans = 2;
tcrit = t(trans);
rem = times(:,2) < tcrit;
for i=1:length(rem)
   if rem(i)
       times(1,:) = []; % removing outputs which are before tcrit
   end
end
%% spectra
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    flux  = importdata([spath 'spectrum_kk.' inst '.txt']);
    if i == 1
        total= flux;
    else
       total = total + flux; 
    end
end
% take average
Ktotal = total/length(times);

%%
figure('Renderer', 'painters', 'Position', [5 5 540 300])
loglog(Ktotal, 'b-o','LineWidth',1,'DisplayName','Kinetic Energy Spec'), hold on
% make power-law for comparions
% -11/5
% power = -2.47;
% x1 = 5; x2 = 13;
% y1 = Ktotal(x1)*200; A = y1/(x1^power); y2 = A*x2^power;
% plot([x1 x2], [y1 y2], 'b--' ,'LineWidth',1,'DisplayName','$k^{-2.47}$')
% % -7/5
% power = -1.19;
% x1 = 5; x2 = 13;
% y1 = Ptotal(x1)*2; A = y1/(x1^power); y2 = A*x2^power;
% plot([x1 x2], [y1 y2], 'r--' ,'LineWidth',1,'DisplayName','$k^{-1.19}$')
% lgnd = legend('Location', 'bestoutside', 'FontSize', numFS);
xlabel('$k = \sqrt{k_x^2 + k_y^2}$')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
nuS = convertStringsToChars(nuS);
title('NV 3', 'FontSize',labelFS)
saveas(gcf,[figpath 'VOSpec_' nuS], 'epsc')





