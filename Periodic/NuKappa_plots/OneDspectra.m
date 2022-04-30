run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
o1 = 1; o2 = 0; 
nu = 5e-5; kappa = 5e-3; f = 0; hnu = 0.7; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
nuS = normaltoS(nu,'nu',1); kappaS = normaltoS(kappa,'kappa',1);
o1S= normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
n = 1024;
nS = ['n_' num2str(n)];
path = AllData.(nS).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
spath = [path '/Spectra/'];
times = importdata([spath 'spec_times.txt']);
kenergy = importdata([path '/Checks/kenergy.txt']);
t = kenergy(:,1);
trans = AllData.(nS).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).trans;
tcrit = t(trans);
rem = times(:,2) < tcrit;
for i=1:length(rem)
   if rem(i)
       times(1,:) = []; % removing outputs which are before tcrit
   end
end
%% Energy flux firsts
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    flux  = importdata([spath 'KEspec' inst '.txt']);
    if i == 1
        total= flux;
    else
       total = total + flux; 
    end
end
% take average
Ktotal = total/length(times);


%% entropy flux
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    flux  = importdata([spath 'PEspec' inst '.txt']);
    if i == 1
        total = flux;
    else
       total = total + flux; 
    end
end
% take average
Ptotal = total/length(times);
%%
figure('Renderer', 'painters', 'Position', [5 5 540 300])
loglog(Ktotal, 'b-o','LineWidth',1,'DisplayName','Kinetic Energy Spec'), hold on
loglog(Ptotal, 'r-o','LineWidth',1,'DisplayName', 'Potential Energy Spec')
nuT = RatoRaT(nu);
kappaT = RatoRaT(kappa);
hnuT = RatoRaT(hnu);
title(['$ \nu =' nuT '\, , \kappa = ' kappaT '\, , \mu = ' hnuT '$'  ],'FontSize',labelFS);
% make power-law for comparions
% -11/5
% power = -11/5;
% x1 = 6; x2 = 15;
% y1 = Ktotal(x1)*200; A = y1/(x1^power); y2 = A*x2^power;
% plot([x1 x2], [y1 y2], 'b--' ,'LineWidth',1,'DisplayName','$k^{-11/5}$')
% % -7/5
% power = -7/5;
% x1 = 6; x2 = 15;
% y1 = Ptotal(x1)*2; A = y1/(x1^power); y2 = A*x2^power;
% plot([x1 x2], [y1 y2], 'r--' ,'LineWidth',1,'DisplayName','$k^{-7/5}$')
lgnd = legend('Location', 'best', 'FontSize', numFS);
% xlabel('$k = \sqrt{k_x^2 + k_y^2}$')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
nuS = convertStringsToChars(nuS); kappaS = convertStringsToChars(kappaS);
fS = convertStringsToChars(fS); hnuS = convertStringsToChars(kappaS);
%title('NV 3', 'FontSize',labelFS)
ylim([1e-6 2])
saveas(gcf,[figpath 'Spec_' nuS '_' kappaS '_'  hnuS], 'epsc')





