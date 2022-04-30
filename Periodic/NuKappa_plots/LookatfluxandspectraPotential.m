run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
o1 = 4; o2 = 1;
f = 0; hnu = 1;
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
nu = 1e-18; nuS = normaltoS(nu, 'nu',1); nuT = RatoRaT(nu);
kappa = 1e-18; kappaS = normaltoS(kappa, 'kappa',1); kappaT = RatoRaT(kappa);
n = 2048;
ns = ['n_' num2str(n)];

% get spectra
path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
kenergy = importdata([path '/Checks/kenergy.txt']);
trans = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).trans;
t = kenergy(:,1); tcrit = t(trans); t = t(trans:end);
[~,Presult] = GetSpec(path,tcrit);

% get flux
[~,Presultflux] = GetFluxes(path,tcrit);
fenk =  kenergy(:,4); % injection
fav = MyMeanEasy(fenk(trans:end),t);

% get scales
[euuresult,fenresult,denresult] = GetPotentailScales(path,tcrit);


%% make potential Energy
f = figure();
f.Position = [100 100 600 900];
subplot(3,1,1)
loglog(Presult, '-o','MarkerSize',10); hold on
xlim([1 n/3])
ylim([1e-8 1e-1])
%xlabel('$k = \sqrt{k_x^2 + k_y^2}$', 'FontSize', labelFS)
ylabel('Potential Energy Spectrum')
title(['$\nu = ' nuT ',\, \kappa = ' kappaT '$'])
% make lines to guide the eye
kstart = 10;
kend = 80;
ystart = 3e-2;
exponents = [1 2];
exponent_text = ["-1" "-2"];
for i = 1:length(exponents)
    plot([kstart kend], [ystart ystart*kstart^exponents(i)*kend^(-exponents(i))], '--r','HandleVisibility', 'off')
    expo = convertStringsToChars(exponent_text(i));
    text(kend*1.1,ystart*kstart^exponents(i)*kend^(-exponents(i)),['$k^{' expo '}$'],'Color','r','FontSize',labelFS)
end

subplot(3,1,2)
semilogx(2*pi*Presultflux/fav, '-o','MarkerSize',10); hold on
xlim([1 n/3])
ylabel('$2\pi\Pi_p/\Delta T<\psi_x \theta>$', 'FontSize', labelFS)

subplot(3,1,3)
loglog(1:length(euuresult),abs(euuresult), 'g-o', 'Displayname','$|\langle \theta \{\psi,\theta\} \rangle|$','MarkerSize',10), hold on
loglog(1:length(fenresult),abs(fenresult/(2*pi)), 'b-o', 'Displayname','$\frac{\Delta T}{2\pi} |\langle \theta \psi_x \rangle|$','MarkerSize',10)
loglog(1:length(denresult),abs(-denresult*kappa), 'r-o', 'Displayname','$\kappa |\langle \theta\nabla^{2n}\theta \rangle|$','MarkerSize',10)
xlim([1 n/3])
xlabel('$k = \sqrt{k_x^2 + k_y^2}$', 'FontSize', labelFS)
lgnd = legend('Location', 'best');

saveas(gcf,[figpath kappaS '_' nuS], 'epsc')








