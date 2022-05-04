run SetUp.m
%%
o1 = 1; o2 = 1; 
nu = 2e-5; kappa = 2e-5; f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
nuS = normaltoS(nu,'nu',1); kappaS = normaltoS(kappa,'kappa',1);
run SetUp.m
n = 1024*8;
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
    try
        flux  = importdata([spath 'vectrans_hen.' inst '.txt']); % Getting a vectrans instance
    catch
        flux  = importdata([spath 'vectrans_henktrans.' inst '.txt']);
    end
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
    try 
        flux  = importdata([spath 'vectrans_fen.' inst '.txt']); % Getting a vectrans instance
    catch
        flux  = importdata([spath 'vectrans_fenktrans.' inst '.txt']);
    end
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
    try
    flux  = importdata([spath 'vectrans_den.' inst '.txt']); % Getting a vectrans instance
    catch
            flux  = importdata([spath 'vectrans_denktrans.' inst '.txt']); % Getting a vectrans instance
    end
    if i == 1
        total = flux; % Initiating total
    else
       total = total + flux; % Added to total
    end
end

denresult = total/length(times); % Take average 

%% plot
figure()
semilogx(1:length(euuresult),euuresult, 'g-o', 'Displayname','$-\langle u \cdot (u \cdot \nabla)u \rangle$','MarkerSize',MS/3), hold on
semilogx(1:length(fenresult),fenresult, 'b-o', 'Displayname','$\langle u \cdot \theta \underline{j} \rangle$','MarkerSize',MS/3)
semilogx(1:length(denresult),-denresult*nu, 'r-o', 'Displayname','$\nu \langle u\cdot\nabla^{2n}u \rangle$','MarkerSize',MS/3)
semilogx(1:length(henresult),-henresult*hnu, 'm-o', 'Displayname','$\mu \langle u\cdot \nabla^{-1}u \rangle$','MarkerSize',MS/3)
lgnd = legend('Location', 'best', 'FontSize', numFS);
nuT = RatoRaT(nu);
kappaT = RatoRaT(kappa);
hnuT = RatoRaT(hnu);
title(['$ \nu =' nuT ',\, \kappa = ' kappaT ',\, \mu = ' hnuT ',\, m = ' num2str(o2) '$'  ],'FontSize',labelFS);

%semilogx(k_list,Kresult/fav, 'b-o'), hold on
%ylabel('$  \Pi_E/\overline{\langle  u\cdot f \rangle}$', 'FontSize',labelFS )
%ylabel('$  \Pi_E$', 'FontSize',labelFS )
xlim([1 100])

xlabel('$k = \sqrt{k_x^2 + k_y^2}$')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
nuS = convertStringsToChars(nuS);
%title('NV 3', 'FontSize',labelFS)
%saveas(gcf,[figpath 'VODisScales_' nuS], 'epsc')
nuS = convertStringsToChars(nuS); kappaS = convertStringsToChars(kappaS);
fS = convertStringsToChars(fS); hnuS = convertStringsToChars(kappaS);
%saveas(gcf,[figpath 'KSScales_' nuS '_' kappaS '_'  hnuS '_m_' num2str(o2)], 'epsc')




