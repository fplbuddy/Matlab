run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
o1 = 1; o2 = 1;
f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
%
overtit = '$Ra = (2\pi)^{3}/(2 \times 10^{-5})^2$ BO Scaling';
%
nu_list = [2e-4 6.32e-5 2e-5 6.32e-6 2e-6];
kappa_list = flip(nu_list,2);
n = 2048*2;
n_list = ones(length(nu_list),1)*n;
cols = distinguishable_colors(length(nu_list));
Pr_list = nu_list./kappa_list;
[Pr_list,I] = sort(Pr_list);
kappa_list = kappa_list(I);
nu_list = nu_list(I);
n_list = n_list(I);

for i=1:length(nu_list)
    nu = nu_list(i); kappa = kappa_list(i); n = n_list(i);
    nuS =normaltoS(nu, 'nu',1); kappaS =normaltoS(kappa, 'kappa',1); ns = ['n_' num2str(n)];
    path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
    kenergy = importdata([path '/Checks/kenergy.txt']);
    trans = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).trans;
    t = kenergy(:,1); tcrit = t(trans); t = t(trans:end);
    [Kresult,Presult] = GetSpec(path,tcrit);
    Data.(nuS).(kappaS).Kresult = Kresult;
    Data.(nuS).(kappaS).Presult = Presult;
end

%% make kinetic Energy
figure()
for i=1:length(nu_list)
    nu = nu_list(i);  nuS =normaltoS(nu, 'nu',1); 
    kappa = kappa_list(i);  kappaS =normaltoS(kappa, 'kappa',1); 
    Kresult = Data.(nuS).(kappaS).Kresult;
    col = cols(i,:);
    legent = RatoRaT(nu);
    Pr = Pr_list(i); PrT = RatoRaT(Pr);
    %p(i) = loglog(Kresult, '-o','DisplayName',['$' PrT '$'], 'Color',col,'MarkerSize',10); hold on
    loglog(Kresult.*(1:length(Kresult))'.^(11/5), '-o','DisplayName',['$' PrT '$'], 'Color',col,'MarkerSize',10); hold on
end
xlim([1 n/3])
ylim([1e-4 10])
yticks([1e-4 10])
%lgnd = legend(p,'Location','bestoutside');
lgnd = legend('Location','bestoutside');
title(lgnd,'$Pr$')
xlabel('$k = \sqrt{k_x^2 + k_y^2}$')
ylabel('Kinetic Energy Spectrum')
title(overtit)

saveas(gcf,[figpath 'BOKineticSpec_RaConst_n_' num2str(o1)], 'epsc')
%close all

%% make potential Energy
figure()
for i=1:length(nu_list)
    nu = nu_list(i);  nuS =normaltoS(nu, 'nu',1); 
    kappa = kappa_list(i);  kappaS =normaltoS(kappa, 'kappa',1); 
    Presult = Data.(nuS).(kappaS).Presult;
    col = cols(i,:);
    legent = RatoRaT(nu);
    Pr = Pr_list(i); PrT = RatoRaT(Pr);
    loglog(Presult.*(1:length(Presult))'.^(7/5), '-o','DisplayName',['$' PrT '$'], 'Color',col,'MarkerSize',10); hold on
end
xlim([1 n/3])
ylim([1e-7 1e0])
xlabel('$k = \sqrt{k_x^2 + k_y^2}$')
lgnd = legend('Location', 'Bestoutside', 'FontSize', numFS);
title(lgnd,'$Pr$')
ylabel('Potential Energy Spectrum', 'FontSize', labelFS)
title(overtit)


saveas(gcf,[figpath 'BOPotentialSpec_RaConst_n_' num2str(o1)], 'epsc')
