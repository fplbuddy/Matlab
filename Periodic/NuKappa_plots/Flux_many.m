run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
o1 = 1; o2 = 1;
f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
Vary = "kappa";
nu = 2e-4; nuS = normaltoS(nu, 'nu',1);
%kappa = 2e-4; kappaS = normaltoS(kappa, 'kappa',1);
figure('Renderer', 'painters', 'Position', [5 5 540 300])
if Vary == "kappa"
    [kappa_list,n_list] = Getkappa_list(AllData,fS,hnuS,o1S,o2S,nuS);
    nu_list = ones(1,length(kappa_list))*nu;
    constnum = RatoRaT(nu_list(end));
    constnumS = normaltoS(nu_list(end),'nu',1);
    const = '\nu';
else
    [nu_list,n_list] = Getnu_list(AllData,fS,hnuS,o1S,o2S,kappaS);
    kappa_list = ones(1,length(nu_list))*kappa; 
    constnum = RatoRaT(kappa_list(end)); 
    constnumS = normaltoS(kappa_list(end),'kappa',1);
    const = '\kappa';
end
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
    [Kresult,Presult] = GetFluxes(path,tcrit);
    fenk =  kenergy(:,4); % injection
    fav = MyMeanEasy(fenk(trans:end),t);
    Data.(nuS).(kappaS).Kresult = Kresult;
    Data.(nuS).(kappaS).Presult = Presult;
    Data.(nuS).(kappaS).fav = fav;
end


%% make kinetic Energy
figure('Renderer', 'painters', 'Position', [5 5 540 300])
for i=1:length(nu_list)
    nu = nu_list(i);  nuS =normaltoS(nu, 'nu',1); 
    kappa = kappa_list(i); kappaS =normaltoS(kappa, 'kappa',1);
    Kresult = Data.(nuS).(kappaS).Kresult;
    fav = Data.(nuS).(kappaS).fav;
    col = cols(i,:);
    Pr = Pr_list(i); PrT = RatoRaT(Pr);
    semilogx(Kresult/fav, '-o','DisplayName',['$' PrT '$'], 'Color',col,'MarkerSize',10); hold on
end
xlim([1 300])
xlabel('$k = \sqrt{k_x^2 + k_y^2}$', 'FontSize', labelFS)
lgnd = legend('Location', 'Bestoutside', 'FontSize', numFS);
title(lgnd,'$Pr$', 'FontSize', labelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$\Pi_k/<\psi_x \theta>$', 'FontSize', labelFS)
title(['$' const '=' constnum '$'], 'FontSize', labelFS)
saveas(gcf,[figpath 'KineticFlux_Many_vary' convertStringsToChars(Vary) '_const_' constnumS '_m_' num2str(o2) ], 'epsc')


%% make pinetic Energy
figure('Renderer', 'painters', 'Position', [5 5 540 300])
for i=1:length(nu_list)
    nu = nu_list(i);  nuS =normaltoS(nu, 'nu',1); 
    kappa = kappa_list(i); kappaS =normaltoS(kappa, 'kappa',1);
    Pr = Pr_list(i); PrT = RatoRaT(Pr);
    Presult = Data.(nuS).(kappaS).Presult;
    fav = Data.(nuS).(kappaS).fav;
    col = cols(i,:);
    semilogx(2*pi*Presult/fav, '-o','DisplayName',['$' PrT '$'], 'Color',col,'MarkerSize',10); hold on
end
xlim([1 1400])
xlabel('$k = \sqrt{k_x^2 + k_y^2}$', 'FontSize', labelFS)
lgnd = legend('Location', 'Bestoutside', 'FontSize', numFS);
title(lgnd,'$Pr$', 'FontSize', labelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$2\pi\Pi_p/\Delta T<\psi_x \theta>$', 'FontSize', labelFS)
title(['$' const '=' constnum '$'], 'FontSize', labelFS)
%saveas(gcf,[figpath 'PotentialFlux_Many_vary' convertStringsToChars(Vary) '_const_' constnumS '_m_' num2str(o2)], 'epsc')




