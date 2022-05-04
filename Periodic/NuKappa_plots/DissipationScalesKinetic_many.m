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
[nu_list,I] = sort(nu_list);
n_list = n_list(I);
Pr_list = nu_list./kappa_list;

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

%% plot 1
figure()
cut = 0.96; % cuts of tail, not really sure if needed
% plots densresult for different Pr, with k2 (from model) added
for i=1:length(n_list)
    n = n_list(i);
    kappa = kappa_list(i); kappaS = normaltoS(kappa, 'kappa',1);
    nu = nu_list(i); nuS = normaltoS(nu, 'nu',1);
    denresult = data.(nuS).(kappaS).denresult;
    denresult= denresult(1:(round(n*cut/3)));

    loglog(denresult*(nu/kappa)), hold on
    k2 = round(8.9*nu^(-0.19));
    plot(k2,denresult(k2)*(nu/kappa),'.r')

    %semilogx(k_list,Kresult/fav, 'b-o'), hold on
    %ylabel('$  \Pi_E/\overline{\langle  u\cdot f \rangle}$', 'FontSize',labelFS )
    %ylabel('$  \Pi_E$', 'FontSize',labelFS )
    %xlim([1 1000])
    ylim([1e-5 1e2])
    xlabel('$k = \sqrt{k_x^2 + k_y^2}$')
    nuS = convertStringsToChars(nuS);
    %title('NV 3', 'FontSize',labelFS)
    %saveas(gcf,[figpath 'VODisScales_' nuS], 'epsc')
    nuS = convertStringsToChars(nuS); kappaS = convertStringsToChars(kappaS);
    fS = convertStringsToChars(fS); hnuS = convertStringsToChars(kappaS);
    %saveas(gcf,[figpath 'KSScales_' nuS '_' kappaS '_'  hnuS '_m_' num2str(o2)], 'epsc')
end

%% plot 2
k2 = zeros(1,length(n_list));
for i=1:length(n_list)
    n = n_list(i);
    kappa = kappa_list(i); kappaS = normaltoS(kappa, 'kappa',1);
    nu = nu_list(i); nuS = normaltoS(nu, 'nu',1);
    denresult = data.(nuS).(kappaS).denresult;
    denresult= denresult(1:(round(n*cut/3)));
    ng =1;
    partsum = zeros(1,length(denresult));
    for j=1:length(partsum)
        partsum(j) = sum(denresult(1:j));
        if partsum(j)/sum(denresult) > 0.6 && ng
            ng = 0;
            k2(i) = j;  
        end
    end
   

    %semilogx(k_list,Kresult/fav, 'b-o'), hold on
    %ylabel('$  \Pi_E/\overline{\langle  u\cdot f \rangle}$', 'FontSize',labelFS )
    %ylabel('$  \Pi_E$', 'FontSize',labelFS )
    %xlim([1 1000])

    xlabel('$k = \sqrt{k_x^2 + k_y^2}$')
    nuS = convertStringsToChars(nuS);
    %title(['$Pr = ' num2str(nu/kappa) '$'], 'FontSize',labelFS)
    %saveas(gcf,[figpath 'VODisScales_' nuS], 'epsc')
    nuS = convertStringsToChars(nuS); kappaS = convertStringsToChars(kappaS);
    fS = convertStringsToChars(fS); hnuS = convertStringsToChars(kappaS);
    %saveas(gcf,[figpath 'KSScales_' nuS '_' kappaS '_'  hnuS '_m_' num2str(o2)], 'epsc')
end
figure()
loglog(nu_list,k2,'.b')
[alpha, A, xFitted, yFitted, Rval] = FitsPowerLaw(nu_list, k2);

%% plot 2:1
k1 = 4;
% try to fit k2 by doing power law fitting from k1 in denresult
k2_list = zeros(1,length(n_list));
for i=1:length(n_list)
    i
    n = n_list(i);
    kappa = kappa_list(i); kappaS = normaltoS(kappa, 'kappa',1);
    nu = nu_list(i); nuS = normaltoS(nu, 'nu',1);nuT = RatoRaT(nu);
    denresult = data.(nuS).(kappaS).denresult;
    top = round(n*cut/3);
    denresult= denresult(1:top);
    current = 0;
    for j=k1+1:top
        [~, ~, ~, ~, Rval] = FitsPowerLaw(k1:j, denresult(k1:j));
        if Rval>current
            current = Rval;
            k2_list(i) = j;
        end
    end
end
% figure()
loglog(nu_list,k2_list,'.b')
[alpha, A, xFitted, yFitted, Rval] = FitsPowerLaw(nu_list(1:end-1), k2_list(1:end-1));
%% plot 3
% get C2 and alpha
C2_list = zeros(1,length(n_list));
alpha_list = zeros(1,length(n_list));
figure()
for i=1:length(n_list)
    kappa = kappa_list(i); kappaS = normaltoS(kappa, 'kappa',1);
    nu = nu_list(i); nuS = normaltoS(nu, 'nu',1); nuT = RatoRaT(nu);
    denresult = data.(nuS).(kappaS).denresult;
    k2 = round(8.9*nu^(-0.19));
    k_list = k1:k2;
    denresult = denresult(k_list);
    [beta, A, ~, ~, Rval] = FitsPowerLaw(k_list, denresult);
    alpha_list(i) = 2-beta;
    C2_list(i) = A;
    loglog(k_list,denresult), hold on
    %title(['$\nu = ' nuT '$'])
end
figure()
loglog(Pr_list,alpha_list-min(alpha_list),'.b')
figure()
loglog(Pr_list,C2_list-min(C2_list),'.b')
alphafit = alpha_list-min(alpha_list);
C2fit = C2_list-min(C2_list);

[alpha, A, ~, ~, Rval1] = FitsPowerLaw(nu_list(3:end), alphafit(3:end))
[alpha, A, ~, ~, Rval2] = FitsPowerLaw(nu_list(3:end), C2fit(3:end))


%% plot 5
% get c1
cut = 0.96; % cuts of tail, not really sure if needed
% plots densresult for different Pr, with k2 (from model) added
c1_list = zeros(1,length(n_list));
for i=1:length(n_list)
    n = n_list(i);
    kappa = kappa_list(i); kappaS = normaltoS(kappa, 'kappa',1);
    nu = nu_list(i); nuS = normaltoS(nu, 'nu',1);
    denresult = data.(nuS).(kappaS).denresult;
    c1_list(i) = sum(denresult(1:3));
end
c1 = mean(c1_list(i));




