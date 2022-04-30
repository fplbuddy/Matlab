run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
o1 = 1; o2 = 1;
f = 0; hnu = 1;
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
nu = 2e-5; nuS = normaltoS(nu, 'nu',1); nuT = RatoRaT(nu);
kappa = 2e-5; kappaS = normaltoS(kappa, 'kappa',1); kappaT = RatoRaT(kappa);
n = 2048*2;
ns = ['n_' num2str(n)];

% get spectra
path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
kenergy = importdata([path '/Checks/kenergy.txt']);
trans = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).trans;
t = kenergy(:,1); tcrit = t(trans); t = t(trans:end);
[Kresult,Presult] = GetSpec(path,tcrit);

% get flux
[Kresultflux,Presultflux] = GetFluxes(path,tcrit);
fenk =  kenergy(:,4); % injection
fav = MyMeanEasy(fenk(trans:end),t);

% get scales
[euuresult,fenresult,denresult,henresult] = GetKineticScales(path,tcrit);


%% make potential Energy
f = figure();
f.Position = [100 100 600 900];
subplot(3,1,1)
loglog(Kresult.*(1:length(Kresult))'.^(11/5), '-o','MarkerSize',10); hold on
xlim([1 n/3])
ylim([1e-4 10])
yticks([1e-4 10])
%xlabel('$k = \sqrt{k_x^2 + k_y^2}$', 'FontSize', labelFS)
ylabel('Kinetic Energy Spectrum')
title(['$\nu = ' nuT ',\, \kappa = ' kappaT '$'])

subplot(3,1,2)
semilogx(Kresultflux/fav, '-o','MarkerSize',10); hold on
xlim([1 n/3])
ylabel('$\Pi_k<\psi_x \theta>$', 'FontSize', labelFS)

subplot(3,1,3)
loglog(1:length(euuresult),abs(euuresult), 'g-o', 'Displayname','$|\langle u \cdot (u \cdot \nabla)u \rangle|$','MarkerSize',MS/3), hold on
loglog(1:length(fenresult),abs(fenresult), 'b-o', 'Displayname','$|\langle u \cdot \theta \underline{j} \rangle|$','MarkerSize',MS/3)
loglog(1:length(denresult),abs(denresult)*nu, 'r-o', 'Displayname','$\nu |\langle u\cdot\nabla^{2n}u \rangle|$','MarkerSize',MS/3)
loglog(1:length(henresult),abs(henresult)*hnu, 'm-o', 'Displayname','$\mu |\langle u\cdot \nabla^{-1}u \rangle|$','MarkerSize',MS/3)
xlim([1 n/3])
xlabel('$k = \sqrt{k_x^2 + k_y^2}$', 'FontSize', labelFS)
lgnd = legend('Location', 'best');

saveas(gcf,[figpath 'kinetic_' kappaS '_' nuS], 'epsc')









