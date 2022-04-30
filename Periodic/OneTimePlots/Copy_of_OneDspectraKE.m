o1 = 1; o2 = 1;
nu = 7e-3; f = 0; hnu = 0.2;
fS = normaltoS(f, 'f'); hnuS = normaltoS(hnu, 'hnu');
nuS = nutonuS(nu);
o1 = normaltoS(o1, 'o1'); o2 = normaltoS(o2, 'o2');
run /Users/philipwinchester/Dropbox/Matlab/Periodic/Plot/SetUp.m
figure('Renderer', 'painters', 'Position', [5 5 540 300])
kappa_list = [7e-2 7e-3 7e-4];
n_list = [256 256 512];
Pr_list = ["0.1" "1" "10" ];
for i=1:length(kappa_list)
    kappa = kappa_list(i); kappaS = kappatokappaS(kappa);
    n = n_list(i); nS = ['n_' num2str(n)];
    path = AllData.(nS).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
    spath = [path '/Spectra/'];
    times = importdata([spath 'spec_times.txt']);
    kenergy = importdata([path '/Checks/kenergy.txt']);
    t = kenergy(:,1);
    trans = AllData.(nS).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).trans;
    tcrit = t(trans);
    rem = times(:,2) < tcrit;
    for j=1:length(rem)
        if rem(j)
            times(1,:) = []; % removing outputs which are before tcrit
        end
    end
    
    for j=1:length(times)
        inst = num2str(times(j,1));
        while length(inst) < 4
            inst = ['0' inst];
        end
        flux  = importdata([spath 'KEspec' inst '.txt']);
        if j == 1
            total= flux;
        else
            total = total + flux;
        end
    end
    % take average
    Ktotal = total/length(times);
    loglog(Ktotal, '-o','LineWidth',1,'DisplayName',Pr_list(i)), hold on
end
lgnd = legend('Location', 'Best', 'FontSize', numFS);
title(lgnd,'$Pr$', 'FontSize', numFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
saveas(gcf,[figpath 'KESpec_PrComp'], 'epsc')





