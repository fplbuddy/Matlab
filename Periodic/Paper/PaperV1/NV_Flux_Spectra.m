run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
figpath  = '/Users/philipwinchester/Desktop/Figures/SpecPaper/';
o1 = 1; o2 = 1;
f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
%
nu_list = [2e-4 6.32e-5 2e-5 6.32e-6 2e-6];
kappa_list = flip(nu_list,2);
%n = 4096;
% n_list = ones(length(nu_list),1)*n;
n = 8192;
n_list = ones(1,length(nu_list))*4096;
n_list = [8192 n_list];
cols = distinguishable_colors(length(nu_list));
Pr_list = nu_list./kappa_list;
[Pr_list,I] = sort(Pr_list,'descend');
kappa_list = kappa_list(I);
nu_list = nu_list(I);
n_list = n_list(I);
cols([3 1],:)=cols([1 3],:); % Make Pr1 blue

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
xlim([1 n/3])
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
xlim([1 n/3])
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
    loglog(Pr*abs(Kresult).*(1:length(Kresult)).^(-p), '-','DisplayName',['$' PrT '$'], 'Color',col,'MarkerSize',10); hold on
    grid on
end
xlim([1 n/3])
ylim([1e-7 20])
ylabel('$Pr |\Pi^{u}(k)|\times k^{4/5}$')
xlabel('$k$')
%
% potential flux
%
subplot(2,2,4) % probably inser exactly later
for i=1:length(nu_list)
    nu = nu_list(i);  nuS =normaltoS(nu, 'nu',1); 
    kappa = kappa_list(i); kappaS =normaltoS(kappa, 'kappa',1);
    Presult = Data.(nuS).(kappaS).Presult/2;
    fav = Data.(nuS).(kappaS).fav;
    col = cols(i,:);
    Pr = Pr_list(i); PrT = RatoRaT(Pr);
    loglog(Pr*Presult, '-','DisplayName',['$' PrT '$'], 'Color',col,'MarkerSize',10); hold on
    grid on
end
xlim([1 n/3])
ylim([1e-7 20])
ylabel('$Pr |\Pi^{\theta}(k)|$')
xlabel('$k$')
lgnd = legend('Location','none');
lgnd.Position = [0.92 0.465 0.05 0.1];
title(lgnd,'$Pr$');
saveas(gcf,[figpath 'NV_Flux_Spectra'], 'epsc')









