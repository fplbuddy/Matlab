o1 = 1; o2 = 1; 
nu = 7e-3; kappa = 7e-2; f = 0; hnu = 0.2; 
fS = normaltoS(f, 'f'); hnuS = normaltoS(hnu, 'hnu');
nuS = nutonuS(nu); kappaS = kappatokappaS(kappa);
o1 = normaltoS(o1, 'o1'); o2 = normaltoS(o2, 'o2');
n = 256;
nS = ['n_' num2str(n)];
run SetUp.m
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

%% find average injection
fenk =  kenergy(:,4); % injection
fav = MyMeanEasy(fenk(trans:end),t(trans:end));

%% Energy flux firsts
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    flux  = importdata([spath 'vectrans_euu.' inst '.txt']);
    if i == 1
        totalflux = flux;
    else
       totalflux = totalflux + flux; 
    end
end
% take average
totalflux = -totalflux/length(times); % minus sign means that we get u dot (u dot nabla)u
% follwing convention in Alexakis. Ie, only consider wavenumbers that are
% smallers
for i=2:length(totalflux)+1
   Kresult(i) = sum(totalflux(1:i-1));
end

%% entropy flux
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    flux  = importdata([spath 'vectrans_puu.' inst '.txt']);
    if i == 1
        totalflux = flux;
    else
       totalflux = totalflux + flux; 
    end
end
% take average
totalflux = totalflux/length(times); % dont need minus sign here
for i=2:length(totalflux)+1
   Presult(i) = sum(totalflux(1:i-1));
end
%%
figure('Renderer', 'painters', 'Position', [5 5 540 300])
semilogx(Kresult/fav, 'b-o','DisplayName','$\Pi_E/g\alpha <\psi_x \theta>$'), hold on
semilogx(pi*Presult/fav, 'r-o','DisplayName','$\pi\Pi_S/\Delta T <\psi_x \theta>$')
xlim([1 200])
xlabel('$k = \sqrt{k_x^2 + k_y^2}$')
lgnd = legend('Location', 'Best', 'FontSize', numFS);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
nuT = RatoRaT(nu);
kappaT = RatoRaT(kappa);
hnuT = RatoRaT(hnu);
title(['$ \nu =' nuT '\, , \kappa = ' kappaT '\, , \mu = ' hnuT '$'  ],'FontSize',labelFS);
nuS = convertStringsToChars(nuS);
kappaS = convertStringsToChars(kappaS);
hnuS = convertStringsToChars(hnuS);
saveas(gcf,[figpath 'Flux_' nuS '_' kappaS '_'  hnuS], 'epsc')




