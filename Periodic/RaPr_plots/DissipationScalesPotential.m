addpath('/Users/philipwinchester/Dropbox/Matlab/Periodic/Plot')
%%
o1 = 8; o2 = 1; 
Pr = 1; Ra = 7e91; f = 0; hnu = 1; 
[nu,kappa] = nukappa(o1,Ra,Pr);
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
PrS =normaltoS(Pr, 'Pr',1); RaS =normaltoS(Ra, 'Ra',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
n = 512;
ns = ['n_' num2str(n)];
path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(PrS).(RaS).path;
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
    flux  = importdata([spath 'vectrans_puu.' inst '.txt']); % Getting a vectrans instance
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
    flux  = importdata([spath 'vectrans_fenktrans.' inst '.txt']); % Getting a vectrans instance
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
    flux  = importdata([spath 'vectrans_denptrans.' inst '.txt']); % Getting a vectrans instance
    if i == 1
        total = flux; % Initiating total
    else
       total = total + flux; % Added to total
    end
end

denresult = total/length(times); % Take average 

%% plot
figure('Renderer', 'painters', 'Position', [5 5 540 300])
semilogx(1:length(euuresult),-euuresult, 'g-o', 'Displayname','$-\langle \theta \{\psi,\theta\} \rangle$'), hold on
semilogx(1:length(fenresult),fenresult/(2*pi), 'b-o', 'Displayname','$\frac{\Delta T}{2\pi} \langle \theta \psi_x \rangle$')
semilogx(1:length(denresult),-denresult*kappa, 'r-o', 'Displayname','$\kappa \langle \theta\nabla^{2n}\theta \rangle$')
lgnd = legend('Location', 'best', 'FontSize', numFS);
RaT = RatoRaT(Ra);
PrT = RatoRaT(Pr);
hnuT = RatoRaT(hnu);
title(['$ Ra =' RaT '\, , Pr = ' PrT '\, , \mu = ' hnuT '$'  ],'FontSize',labelFS);

%semilogx(k_list,Kresult/fav, 'b-o'), hold on
%ylabel('$  \Pi_E/\overline{\langle  u\cdot f \rangle}$', 'FontSize',labelFS )
%ylabel('$  \Pi_E$', 'FontSize',labelFS )
xlim([1 100])

xlabel('$k = \sqrt{k_x^2 + k_y^2}$')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;

%title('NV 3', 'FontSize',labelFS)
%saveas(gcf,[figpath 'VODisScales_' nuS], 'epsc')
%saveas(gcf,[figpath 'KSScales_' nuS '_' kappaS '_'  hnuS], 'epsc')




