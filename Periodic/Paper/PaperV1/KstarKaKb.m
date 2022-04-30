run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
figpath  = '/Users/philipwinchester/Desktop/Figures/SpecPaper/';
o1 = 1; o2 = 1;
f = 0; hnu = 1;
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
%
%overtit = '$Ra = (2\pi)^{15}/(10^{-19})^2$';
%overtit = '$Ra = (2\pi)^{3}/(2\times10^{-5})^2$';
%
%nu_list = [1e-18 3.16e-19 1e-19 3.16e-20 1e-20];
nu_list = [2e-4 6.32e-5 2e-5 6.32e-6 2e-6];
kappa_list = flip(nu_list,2);
n = 4096;
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

% for i=1:length(nu_list)
%     nu = nu_list(i); kappa = kappa_list(i);
%     nuS =normaltoS(nu, 'nu',1); kappaS =normaltoS(kappa, 'kappa',1);
%     Presult = Data.(nuS).(kappaS).Presult;
%     check = abs(Presult./max(Presult));
%     for j=start:length(check)
%         if check(j) < thresh 
%             ConstantFluxLS(i) = j;
%             break
%         end
%     end
% end

for i=1:length(nu_list)
    nu = nu_list(i); kappa = kappa_list(i);
    nuS =normaltoS(nu, 'nu',1); kappaS =normaltoS(kappa, 'kappa',1);
    Presult = Data.(nuS).(kappaS).Presult;
    top = floor(n/3);
    k = 1:top;
    logk = log(k);
    logPflux = log(abs(Presult(1:top)));
    grad = gradient(logPflux(:)) ./ gradient(logk(:));
    for j=start:length(check)
        if abs(grad(j)) > thresh 
            ConstantFluxLS(i) = j;
            break
        end
    end
end



BouyancyLS = zeros(length(Pr_list),1);
% thresh = 0.1;
% for i=1:length(nu_list)
%     nu = nu_list(i); kappa = kappa_list(i);
%     nuS =normaltoS(nu, 'nu',1); kappaS =normaltoS(kappa, 'kappa',1);
%     check = abs(Data.(nuS).(kappaS).euuresult./Data.(nuS).(kappaS).fenresult);
%     for j=start:length(check)
%         if check(j) < thresh || check(j) > thresh^(-1)
%             BouyancyLS(i) = j;
%             break
%         end
%     end
% end

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

%% figure
figure()
loglog(Pr_list,min([BouyancyLS'; ConstantFluxLS']),'k--','DisplayName','$k^{\star}$'), hold on
loglog(Pr_list,ConstantFluxLS,'.r','DisplayName','$k_{a_2}$'),hold on
loglog(Pr_list,BouyancyLS,'.b','DisplayName','$k_{b_2}$')
xlabel('$Pr$')
legend()
saveas(gcf,[figpath 'NV_LengthScales'], 'epsc')