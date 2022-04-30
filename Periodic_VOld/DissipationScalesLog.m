addpath('/Users/philipwinchester/Dropbox/Matlab/Periodic/Plot')
run SetUp.m
%%
nu = 3e-3; nuS = nutonuS(nu);
hmu = 2;
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
%% euu
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    flux  = importdata([spath 'vectrans_euu.' inst '.txt']); % Getting a vectrans instance
    if i == 1
        total = flux; % Initiating total
    else
       total = total + flux; % Added to total
    end
end

euuresult = total/length(times); % Take average 


%%
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    flux  = importdata([spath 'vectrans_hen.' inst '.txt']); % Getting a vectrans instance
    if i == 1
        total = flux; % Initiating total
    else
       total = total + flux; % Added to total
    end
end

henresult = total/length(times); % Take average 


%%
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    flux  = importdata([spath 'vectrans_fen.' inst '.txt']); % Getting a vectrans instance
    if i == 1
        total = flux; % Initiating total
    else
       total = total + flux; % Added to total
    end
end

fenresult = total/length(times); % Take average 

%%
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    flux  = importdata([spath 'vectrans_den.' inst '.txt']); % Getting a vectrans instance
    if i == 1
        total = flux; % Initiating total
    else
       total = total + flux; % Added to total
    end
end

denresult = total/length(times); % Take average 

%% plot
figure('Renderer', 'painters', 'Position', [5 5 540 300])
loglog(1:length(euuresult),abs(euuresult), 'g-o', 'Displayname','$|\langle u \cdot (u \cdot \nabla)u \rangle|$'), hold on
loglog(1:length(fenresult),abs(fenresult), 'b-o', 'Displayname','$|\langle u \cdot F \rangle|$')
loglog(1:length(denresult),abs(denresult*nu), 'r-o', 'Displayname','$\nu |\langle u\cdot\nabla^{2n}u \rangle|$')
loglog(1:length(henresult),abs(henresult*hmu), 'm-o', 'Displayname','$\mu |\langle u\cdot \nabla^{-1}u \rangle|$')
lgnd = legend('Location', 'best', 'FontSize', numFS);



%semilogx(k_list,Kresult/fav, 'b-o'), hold on
%ylabel('$  \Pi_E/\overline{\langle  u\cdot f \rangle}$', 'FontSize',labelFS )
%ylabel('$  \Pi_E$', 'FontSize',labelFS )
xlim([1 100])
ylim([1e-6 1e0])
xlabel('$k = \sqrt{k_x^2 + k_y^2}$')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
nuS = convertStringsToChars(nuS);
title('NV 3', 'FontSize',labelFS)
saveas(gcf,[figpath 'VODisScalesLog_' nuS], 'epsc')




