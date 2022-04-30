run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
figpath  = '/Users/philipwinchester/Desktop/Figures/SpecPaper/';
o1 = 1; o2 = 1;
f = 0; hnu = 1;
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);

% get nu constant first
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
Pr_list = nu_list./kappa_list;
[Pr_list,I] = sort(Pr_list);
kappa_list = kappa_list(I);
nu_list = nu_list(I);
n_list = n_list(I);

% now add kappa constant
Vary = "nu";
kappa = 2e-4; kappaS = normaltoS(kappa, 'kappa',1);
figure('Renderer', 'painters', 'Position', [5 5 540 300])
if Vary == "kappa"
    [kappa_list,n_list] = Getkappa_list(AllData,fS,hnuS,o1S,o2S,nuS);
    nu_list = ones(1,length(kappa_list))*nu;
    constnum = RatoRaT(nu_list(end));
    constnumS = normaltoS(nu_list(end),'nu',1);
    const = '\nu';
else
    [nu_list2,n_list2] = Getnu_list(AllData,fS,hnuS,o1S,o2S,kappaS);
    kappa_list2 = ones(1,length(nu_list2))*kappa; 
    constnum = RatoRaT(kappa_list(end)); 
    constnumS = normaltoS(kappa_list(end),'kappa',1);
    const = '\kappa';
end
Pr_list2 = nu_list2./kappa_list2;
[Pr_list2,I] = sort(Pr_list2);
kappa_list2 = kappa_list2(I);
nu_list2 = nu_list2(I);
n_list2 = n_list2(I);
% remove Pr = 25
kappa_list2 = kappa_list2(Pr_list2 ~= 25);
nu_list2 = nu_list2(Pr_list2 ~= 25);
n_list2 = n_list2(Pr_list2 ~= 25);
Pr_list2 = Pr_list2(Pr_list2 ~= 25);



for i=1:length(nu_list)
    nu = nu_list(i); kappa = kappa_list(i); n = n_list(i);
    nuS =normaltoS(nu, 'nu',1); kappaS =normaltoS(kappa, 'kappa',1); ns = ['n_' num2str(n)];
    path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
    kenergy = importdata([path '/Checks/kenergy.txt']);
    trans = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).trans;
    t = kenergy(:,1); tcrit = t(trans);
    [~,Presult] = GetFluxes(path,tcrit);
    Data.(nuS).(kappaS).Presult = Presult;
    [euuresult,fenresult,denresult,henresult] = GetKineticScales(path,tcrit);
    Data.(nuS).(kappaS).euuresult = euuresult;
    Data.(nuS).(kappaS).fenresult = fenresult;
    Data.(nuS).(kappaS).denresult = denresult;
    Data.(nuS).(kappaS).henresult = henresult;
end

for i=1:length(nu_list2)
    nu = nu_list2(i); kappa = kappa_list2(i); n = n_list2(i);
    nuS =normaltoS(nu, 'nu',1); kappaS =normaltoS(kappa, 'kappa',1); ns = ['n_' num2str(n)];
    path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
    kenergy = importdata([path '/Checks/kenergy.txt']);
    trans = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).trans;
    t = kenergy(:,1); tcrit = t(trans);
    [~,Presult] = GetFluxes(path,tcrit);
    Data.(nuS).(kappaS).Presult = Presult;
    [euuresult,fenresult,denresult,henresult] = GetKineticScales(path,tcrit);
    Data.(nuS).(kappaS).euuresult = euuresult;
    Data.(nuS).(kappaS).fenresult = fenresult;
    Data.(nuS).(kappaS).denresult = denresult;
    Data.(nuS).(kappaS).henresult = henresult;
end

%% Get length scales
% get constant flux LS
ConstantFluxLS = zeros(length(Pr_list),1);
thresh = 1/3;
start = 5;

for i=1:length(nu_list)
    nu = nu_list(i); kappa = kappa_list(i); n = n_list(i);
    nuS =normaltoS(nu, 'nu',1); kappaS =normaltoS(kappa, 'kappa',1);
    Presult = Data.(nuS).(kappaS).Presult;
    top = floor(n/3);
    k = 1:top;
    logk = log(k);
    logPflux = log(abs(Presult(1:top)));
    grad = gradient(logPflux(:)) ./ gradient(logk(:));
    for j=start:length(grad)
        if abs(grad(j)) > thresh 
            ConstantFluxLS(i) = j;
            break
        end
    end
end
Data.ConstantFluxLSnuconst = ConstantFluxLS;
ConstantFluxLS = zeros(length(Pr_list2),1);
for i=1:length(nu_list2)
    nu = nu_list2(i); kappa = kappa_list2(i); n = n_list2(i);
    nuS =normaltoS(nu, 'nu',1); kappaS =normaltoS(kappa, 'kappa',1);
    Presult = Data.(nuS).(kappaS).Presult;
    top = floor(n/3);
    k = 1:top;
    logk = log(k);
    logPflux = log(abs(Presult(1:top)));
    grad = gradient(logPflux(:)) ./ gradient(logk(:));
    for j=start:length(grad)
        if abs(grad(j)) > thresh 
            ConstantFluxLS(i) = j;
            break
        end
    end
end
Data.ConstantFluxLSkappaconst = ConstantFluxLS;


BouyancyLS = zeros(length(Pr_list),1);
thresh = 0.1;
for i=1:length(nu_list)
    nu = nu_list(i); kappa = kappa_list(i);
    nuS =normaltoS(nu, 'nu',1); kappaS =normaltoS(kappa, 'kappa',1);
    T = Data.(nuS).(kappaS).euuresult;
    S = Data.(nuS).(kappaS).denresult*nu;
    for j=start:length(S)
        if abs(S(j)) > abs(T(j))
            BouyancyLS(i) = j;
            break
        end
    end
end
Data.BouyancyLSnuconst = BouyancyLS;
BouyancyLS = zeros(length(Pr_list),1);
for i=1:length(nu_list2)
    nu = nu_list2(i); kappa = kappa_list2(i);
    nuS =normaltoS(nu, 'nu',1); kappaS =normaltoS(kappa, 'kappa',1);
    T = Data.(nuS).(kappaS).euuresult;
    S = Data.(nuS).(kappaS).denresult*nu;
    for j=start:length(S)
        if abs(S(j)) > abs(T(j))
            BouyancyLS(i) = j;
            break
        end
    end
end
Data.BouyancyLSkappaconst = BouyancyLS;

%% figure
figure()
set(subplot(1,1,1), 'Position', [0.07 0.15 0.85 0.79])
loglog(Pr_list,min([Data.BouyancyLSnuconst'; Data.ConstantFluxLSnuconst']),'r--','DisplayName','$k_{\star}^{\nu}$'); hold on
loglog(Pr_list,Data.ConstantFluxLSnuconst,'dr','DisplayName','$k_{a_2}^{\nu}$','MarkerFaceColor','r','MarkerSize',MS*0.3);
loglog(Pr_list,Data.BouyancyLSnuconst,'.r','DisplayName','$k_{b_2}^{\nu}$');
loglog(Pr_list2,min([Data.BouyancyLSkappaconst'; Data.ConstantFluxLSkappaconst']),'b--','DisplayName','$k_{\star}^{\kappa}$')
loglog(Pr_list2,Data.ConstantFluxLSkappaconst,'db','DisplayName','$k_{a_2}^{\kappa}$','MarkerFaceColor','b','MarkerSize',MS*0.3);
loglog(Pr_list2,Data.BouyancyLSkappaconst,'.b','DisplayName','$k_{b_2}^{\kappa}$');


% x1= 2e-1;
% x2 = 8e-1;
% yval = 8e1;
% if Vary == "kappa"
%     arrow([x1 yval],[x2 yval],20,'BaseAngle',60,'width',2);
%     text(x1*0.75,yval,'$Ra$','FontSize',numFS*1.2,'HorizontalAlignment','center','VerticalAlignment','middle')
%     text(x1*(x2/(2*x1)),yval*1.5,['$' const '=' constnum '$' ],'FontSize',numFS*1.2,'HorizontalAlignment','center','VerticalAlignment','middle')
% else
%     
% end
xlabel('$Pr$')
legend()
saveas(gcf,[figpath 'NV_LengthScalesV2'], 'epsc')