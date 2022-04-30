addpath('/Users/philipwinchester/Dropbox/Matlab/Periodic/Plot')
run SetUp.m
%%
o1 = 1; o2 = 1; 
Pr = 1; Ra = 6e6; f = 0; hnu = 1; 
[nu,kappa] = nukappa(o1,Ra,Pr);
fS = normaltoS(f, 'f'); hnuS = normaltoS(hnu, 'hnu');
PrS =normaltoS(Pr, 'Pr'); RaS =normaltoS(Ra, 'Ra');
o1S = normaltoS(o1, 'o1'); o2S = normaltoS(o2, 'o2');
run SetUp.m
n = 256;
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
    flux  = importdata([spath 'vectrans_henktrans.' inst '.txt']); % Getting a vectrans instance
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
    flux  = importdata([spath 'vectrans_denktrans.' inst '.txt']); % Getting a vectrans instance
    if i == 1
        total = flux; % Initiating total
    else
       total = total + flux; % Added to total
    end
end

denresult = total/length(times); % Take average 

%% plot
figure('Renderer', 'painters', 'Position', [5 5 540 300])
semilogx(1:length(euuresult),euuresult, 'g-o', 'Displayname','$-\langle u \cdot (u \cdot \nabla)u \rangle$'), hold on
semilogx(1:length(fenresult),fenresult, 'b-o', 'Displayname','$\langle u \cdot \theta \underline{j} \rangle$')
semilogx(1:length(denresult),-denresult*nu, 'r-o', 'Displayname','$\nu \langle u\cdot\nabla^{2n}u \rangle$')
semilogx(1:length(henresult),-henresult*hnu, 'm-o', 'Displayname','$\mu \langle u\cdot \nabla^{-1}u \rangle$')
lgnd = legend('Location', 'bestoutside', 'FontSize', numFS);
RaT = RatoRaT(Ra);
PrT = RatoRaT(Pr);
hnuT = RatoRaT(hnu);
title(['$ Ra =' RaT '\, , Pr = ' PrT '\, , \mu = ' hnuT '$'  ],'FontSize',labelFS);

%semilogx(k_list,Kresult/fav, 'b-o'), hold on
%ylabel('$  \Pi_E/\overline{\langle  u\cdot f \rangle}$', 'FontSize',labelFS )
%ylabel('$  \Pi_E$', 'FontSize',labelFS )
xlim([1 100])
%saveas(gcf,[figpath 'KSScales_' nuS '_' kappaS '_'  hnuS], 'epsc')




