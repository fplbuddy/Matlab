run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
o1 = 4; o2 = 1;
f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
Vary = "kappa";
nu = 1e-18; nuS = normaltoS(nu, 'nu',1);
%kappa = 1e-18; kappaS = normaltoS(kappa, 'kappa',1);
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
    loglog(Kresult, '-o','DisplayName',['$' PrT '$'], 'Color',col,'MarkerSize',10); hold on
end
xlim([1 1400])
ylim([1e-5 1])
yticks([1e-5 1])
%lgnd = legend(p,'Location','bestoutside');
lgnd = legend('Location','bestoutside');
title(lgnd,'$Pr$')
xlabel('$k = \sqrt{k_x^2 + k_y^2}$')
ylabel('Kinetic Energy Spectrum')
title(['$' const '=' constnum '$'])
% make lines to guide the eye
kstart = 10;
kend = 80;
ystart = 1e-1;
exponents = [5/2 7/2];
exponent_text = ["-5/2" "-7/2"];
for i = 1:length(exponents)
    plot([kstart kend], [ystart ystart*kstart^exponents(i)*kend^(-exponents(i))], '--r','HandleVisibility', 'off')
    expo = convertStringsToChars(exponent_text(i));
    text(kend*1.1,ystart*kstart^exponents(i)*kend^(-exponents(i)),['$k^{' expo '}$'],'Color','r','FontSize',labelFS)
end

saveas(gcf,[figpath 'KineticSpec_Vary' convertStringsToChars(Vary) '_const_' constnumS '_m_' num2str(o2)], 'epsc')
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
    loglog(Presult, '-o','DisplayName',['$' PrT '$'], 'Color',col,'MarkerSize',10); hold on
end
xlim([1 1400])
ylim([1e-8 1e-1])
xlabel('$k = \sqrt{k_x^2 + k_y^2}$', 'FontSize', labelFS)
lgnd = legend('Location', 'Bestoutside', 'FontSize', numFS);
title(lgnd,['$Pr$'], 'FontSize', labelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('Potential Energy Spectrum', 'FontSize', labelFS)
title(['$' const '=' constnum '$'], 'FontSize', labelFS)
% make lines to guide the eye
kstart = 10;
kend = 80;
ystart = 5e-2;
exponents = [1 2];
exponent_text = ["-1" "-2"];
for i = 1:length(exponents)
    plot([kstart kend], [ystart ystart*kstart^exponents(i)*kend^(-exponents(i))], '--r','HandleVisibility', 'off')
    expo = convertStringsToChars(exponent_text(i));
    text(kend*1.1,ystart*kstart^exponents(i)*kend^(-exponents(i)),['$k^{' expo '}$'],'Color','r','FontSize',labelFS)
end


saveas(gcf,[figpath 'PotentialSpec_Vary' convertStringsToChars(Vary) '_const_' constnumS '_m_' num2str(o2)], 'epsc')








