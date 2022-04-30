run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
%%
o1 = 4; o2 = 1;
nu = 1e-18; kappa = 1e-18; f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
nuS = normaltoS(nu, 'nu',1); kappaS = normaltoS(kappa, 'kappa',1);
run SetUp.m
n = 4096/2;
ns = ['n_' num2str(n)];
path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
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
figure()
semilogx(1:length(euuresult),-euuresult, 'g-o', 'Displayname','$-\langle \theta \{\psi,\theta\} \rangle$','MarkerSize',10), hold on
semilogx(1:length(fenresult),fenresult/(2*pi), 'b-o', 'Displayname','$\frac{\Delta T}{2\pi} \langle \theta \psi_x \rangle$','MarkerSize',10)
semilogx(1:length(denresult),-denresult*kappa, 'r-o', 'Displayname','$\kappa \langle \theta\nabla^{2n}\theta \rangle$','MarkerSize',10)
lgnd = legend('Location', 'best');
nuT = RatoRaT(nu);
kappaT = RatoRaT(kappa);
hnuT = RatoRaT(hnu);
title(['$ \nu =' nuT '\, , \kappa = ' kappaT '\, , \mu = ' hnuT '$'  ],'FontSize',labelFS);

%semilogx(k_list,Kresult/fav, 'b-o'), hold on
%ylabel('$  \Pi_E/\overline{\langle  u\cdot f \rangle}$', 'FontSize',labelFS )
%ylabel('$  \Pi_E$', 'FontSize',labelFS )
xlim([1 n/3])

xlabel('$k = \sqrt{k_x^2 + k_y^2}$')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
nuS = convertStringsToChars(nuS);
%title('NV 3', 'FontSize',labelFS)
%saveas(gcf,[figpath 'VODisScales_' nuS], 'epsc')
nuS = convertStringsToChars(nuS); kappaS = convertStringsToChars(kappaS);
fS = convertStringsToChars(fS); hnuS = convertStringsToChars(kappaS);
%saveas(gcf,[figpath 'KSScales_' nuS '_' kappaS '_'  hnuS], 'epsc')


figure()
loglog(1:length(euuresult),abs(euuresult), 'g-o', 'Displayname','$-\langle \theta \{\psi,\theta\} \rangle$','MarkerSize',10), hold on
loglog(1:length(fenresult),abs(fenresult/(2*pi)), 'b-o', 'Displayname','$\frac{\Delta T}{2\pi} \langle \theta \psi_x \rangle$','MarkerSize',10)
loglog(1:length(denresult),abs(-denresult*kappa), 'r-o', 'Displayname','$\kappa \langle \theta\nabla^{2n}\theta \rangle$','MarkerSize',10)
lgnd = legend('Location', 'best');
nuT = RatoRaT(nu);
kappaT = RatoRaT(kappa);
hnuT = RatoRaT(hnu);
title(['$ \nu =' nuT '\, , \kappa = ' kappaT '\, , \mu = ' hnuT '$'  ],'FontSize',labelFS);

%semilogx(k_list,Kresult/fav, 'b-o'), hold on
%ylabel('$  \Pi_E/\overline{\langle  u\cdot f \rangle}$', 'FontSize',labelFS )
%ylabel('$  \Pi_E$', 'FontSize',labelFS )
xlim([1 n/3])

xlabel('$k = \sqrt{k_x^2 + k_y^2}$')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
nuS = convertStringsToChars(nuS);
%title('NV 3', 'FontSize',labelFS)
%saveas(gcf,[figpath 'VODisScales_' nuS], 'epsc')
nuS = convertStringsToChars(nuS); kappaS = convertStringsToChars(kappaS);
fS = convertStringsToChars(fS); hnuS = convertStringsToChars(kappaS);




