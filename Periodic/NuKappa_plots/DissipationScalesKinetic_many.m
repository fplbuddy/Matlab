run SetUp.m
%%
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Vary = "nu";
o1 = 1; o2 = 1;
f = 0; hnu = 1;
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
%nu = 2e-4; nuS = normaltoS(nu, 'nu',1);
kappa = 2e-4; kappaS = normaltoS(kappa, 'kappa',1);
if Vary == "kappa"
    [kappa_list,n_list] = Getkappa_list(AllData,fS,hnuS,o1S,o2S,nuS);
    nu_list =  ones(1,length(kappa_list))*nu;
else
    [nu_list,n_list] = Getnu_list(AllData,fS,hnuS,o1S,o2S,kappaS);
    kappa_list = ones(1,length(nu_list))*kappa;
end
for i=1:length(n_list)
    n = n_list(i);
    kappa = kappa_list(i); kappaS = normaltoS(kappa, 'kappa',1);
    nu = nu_list(i); nuS = normaltoS(nu, 'nu',1);
    ns = ['n_' num2str(n)];
    path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
    spath = [path '/Spectra/'];
    times = importdata([spath 'spec_times.txt']);
    kenergy = importdata([path '/Checks/kenergy.txt']);
    t = kenergy(:,1);
    trans = 2;
    tcrit = t(trans);
    rem = times(:,2) < tcrit;
    for j=1:length(rem)
        if rem(j)
            times(1,:) = []; % removing outputs which are before tcrit
        end
    end 
    % euu
    for j=1:length(times)
        inst = num2str(times(j,1));
        while length(inst) < 4
            inst = ['0' inst];
        end
        flux  = importdata([spath 'vectrans_euu.' inst '.txt']); % Getting a vectrans instance
        if j == 1
            total = flux; % Initiating total
        else
            total = total + flux; % Added to total
        end
    end
    euuresult = total/length(times); % Take average
    %
    for j=1:length(times)
        inst = num2str(times(j,1));
        while length(inst) < 4
            inst = ['0' inst];
        end
        try
            flux  = importdata([spath 'vectrans_hen.' inst '.txt']); % Getting a vectrans instance
        catch
            flux  = importdata([spath 'vectrans_henktrans.' inst '.txt']);
        end
        if j == 1
            total = flux; % Initiating total
        else
            total = total + flux; % Added to total
        end
    end
    henresult = total/length(times); % Take average
    %
    for j=1:length(times)
        inst = num2str(times(j,1));
        while length(inst) < 4
            inst = ['0' inst];
        end
        try
            flux  = importdata([spath 'vectrans_fen.' inst '.txt']); % Getting a vectrans instance
        catch
            flux  = importdata([spath 'vectrans_fenktrans.' inst '.txt']);
        end
        if j == 1
            total = flux; % Initiating total
        else
            total = total + flux; % Added to total
        end
    end
    fenresult = total/length(times); % Take average
    %
    for j=1:length(times)
        inst = num2str(times(j,1));
        while length(inst) < 4
            inst = ['0' inst];
        end
        try
            flux  = importdata([spath 'vectrans_den.' inst '.txt']); % Getting a vectrans instance
        catch
            flux  = importdata([spath 'vectrans_denktrans.' inst '.txt']); % Getting a vectrans instance
        end
        if j == 1
            total = flux; % Initiating total
        else
            total = total + flux; % Added to total
        end
    end
    denresult = total/length(times); % Take average
    
    % Save data
    data.(nuS).(kappaS).euuresult = euuresult;
    data.(nuS).(kappaS).henresult = henresult;
    data.(nuS).(kappaS).fenresult = fenresult;
    data.(nuS).(kappaS).denresult = denresult;
    
end





%% plot
figure()
for i=1:length(n_list)
    kappa = kappa_list(i); kappaS = normaltoS(kappa, 'kappa',1);
    nu = nu_list(i); nuS = normaltoS(nu, 'nu',1);
    euuresult = data.(nuS).(kappaS).euuresult;
    henresult = data.(nuS).(kappaS).henresult;
    fenresult = data.(nuS).(kappaS).fenresult;
    denresult = data.(nuS).(kappaS).denresult;
    %figure()
    %loglog(1:length(euuresult),abs(euuresult), 'g-o', 'Displayname','$-\langle u \cdot (u \cdot \nabla)u \rangle$','MarkerSize',MS/3), hold on
    %loglog(1:length(fenresult),abs(fenresult), 'b-o', 'Displayname','$\langle u \cdot \theta \underline{j} \rangle$','MarkerSize',MS/3)
    %semilogx(1:length(denresult),abs(denresult)*nu, 'r-o', 'Displayname','$\nu \langle u\cdot\nabla^{2n}u \rangle$','MarkerSize',MS/3)
    %loglog(1:length(henresult),abs(henresult)*hnu, 'm-o', 'Displayname','$\mu \langle u\cdot \nabla^{-1}u \rangle$','MarkerSize',MS/3)
    loglog(nu/kappa,max(abs(denresult(2:10))),'.b'), hold on
    %loglog(nu/kappa,sum(abs(denresult))*nu,'.r')
    %lgnd = legend('Location', 'best', 'FontSize', numFS);
    nuT = RatoRaT(nu);
    kappaT = RatoRaT(kappa);
    hnuT = RatoRaT(hnu);
    %title(['$ \nu =' nuT ',\, \kappa = ' kappaT ',\, \mu = ' hnuT ',\, m = ' num2str(o2) '$'  ],'FontSize',labelFS);
    title(['$ \nu =' nuT '$'  ],'FontSize',labelFS);

    %semilogx(k_list,Kresult/fav, 'b-o'), hold on
    %ylabel('$  \Pi_E/\overline{\langle  u\cdot f \rangle}$', 'FontSize',labelFS )
    %ylabel('$  \Pi_E$', 'FontSize',labelFS )
    %xlim([1 1000])

    xlabel('$k = \sqrt{k_x^2 + k_y^2}$')
    nuS = convertStringsToChars(nuS);
    %title('NV 3', 'FontSize',labelFS)
    %saveas(gcf,[figpath 'VODisScales_' nuS], 'epsc')
    nuS = convertStringsToChars(nuS); kappaS = convertStringsToChars(kappaS);
    fS = convertStringsToChars(fS); hnuS = convertStringsToChars(kappaS);
    %saveas(gcf,[figpath 'KSScales_' nuS '_' kappaS '_'  hnuS '_m_' num2str(o2)], 'epsc')
end




