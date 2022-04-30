run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
figpath  = '/Users/philipwinchester/Desktop/Figures/SpecPaper/';
o1 = 1; o2 = 1;
f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
%
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
% remove Pr = 25 if needed
kappa_list = kappa_list(Pr_list ~= 25);
nu_list = nu_list(Pr_list ~= 25);
n_list = n_list(Pr_list ~= 25);
Pr_list = Pr_list(Pr_list ~= 25);

for i=1:length(nu_list)
    i
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
    [Kspec,Pspec] = GetSpec(path,tcrit);
    Data.(nuS).(kappaS).Kspec = Kspec;
    Data.(nuS).(kappaS).Pspec = Pspec;
end


%% make plot
speclim = [1e-5 1e2];
sb = 5;
st= 100;
figure('Renderer', 'painters', 'Position', [5 5 540*2 300*2])
% First do kenetic spec
subplot(2,2,1) % probably inser exactly later
p = -11/5;
for i=1:length(nu_list)
    nu = nu_list(i);  nuS =normaltoS(nu, 'nu',1); 
    kappa = kappa_list(i); kappaS =normaltoS(kappa, 'kappa',1);
    Kspec = Data.(nuS).(kappaS).Kspec/2; % dont think i devide by 2 in code
    col = cols(i,:);
    Pr = Pr_list(i); PrT = RatoRaT(Pr);
    ttp = Pr*Kspec.*(1:length(Kspec))'.^(-p);
    loglog(ttp, '-','DisplayName',['$' PrT '$'], 'Color',col,'MarkerSize',10); hold on
%     % add straight line from 5 to 100
%     a = plot([sb st], [ttp(sb) ttp(sb)],'--');
%     a.
    grid on
end
ylim(speclim)
xlim([1 8192/3])
set(gca,'xTickLabel',[]);
ylabel('$PrE^u(k)\times k^{11/5}$')
% now do potential spec
subplot(2,2,2) % probably inser exactly later
p = -7/5;
for i=1:length(nu_list)
    nu = nu_list(i);  nuS =normaltoS(nu, 'nu',1); 
    kappa = kappa_list(i); kappaS =normaltoS(kappa, 'kappa',1);
    Pspec = Data.(nuS).(kappaS).Pspec/2; % dont think i devide by 2 in code
    col = cols(i,:);
    Pr = Pr_list(i); PrT = RatoRaT(Pr);
    loglog(Pr*Pspec.*(1:length(Pspec))'.^(-p), '-','DisplayName',['$' PrT '$'], 'Color',col,'MarkerSize',10); hold on
    grid on
end
ylim(speclim)
xlim([1 8192/3])
set(gca,'xTickLabel',[]);
ylabel('$PrE^{\theta}(k)\times k^{7/5}$')
% Now do kinetic flux
subplot(2,2,3) % probably inser exactly later
p = -4/5;
for i=1:length(nu_list)
    nu = nu_list(i);  nuS =normaltoS(nu, 'nu',1); 
    kappa = kappa_list(i); kappaS =normaltoS(kappa, 'kappa',1);
    Kresult = Data.(nuS).(kappaS).Kresult;
    fav = Data.(nuS).(kappaS).fav;
    col = cols(i,:);
    Pr = Pr_list(i); PrT = RatoRaT(Pr);
    semilogx(Kresult/fav, '-','DisplayName',['$' PrT '$'], 'Color',col,'MarkerSize',10); hold on
end
xlim([1 8192/3])
%ylim([0 1])
ylabel('$\frac{\Pi^{u}(k)}{B}$')
xlabel('$k$')
%
% potential flux
%
subplot(2,2,4) % probably inser exactly later
for i=1:length(nu_list)
    nu = nu_list(i);  nuS =normaltoS(nu, 'nu',1); 
    kappa = kappa_list(i); kappaS =normaltoS(kappa, 'kappa',1);
    Presult = Data.(nuS).(kappaS).Presult;
    fav = Data.(nuS).(kappaS).fav;
    col = cols(i,:);
    Pr = Pr_list(i); PrT = RatoRaT(Pr);
    semilogx(2*pi*Presult/fav, '-','DisplayName',['$' PrT '$'], 'Color',col,'MarkerSize',10); hold on
end
xlim([1 8192/3])
%ylim([0 1])
ylabel('$\frac{2\pi \Pi^{\theta}(k)}{\Delta T B}$')
xlabel('$k$')
lgnd = legend('Location','none');
lgnd.Position = [0.92 0.465 0.05 0.1];
title(lgnd,'$Pr$');
saveas(gcf,[figpath 'NV_Flux_Spectra_vary' convertStringsToChars(Vary)], 'epsc')