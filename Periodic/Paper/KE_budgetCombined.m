run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
figpath  = '/Users/philipwinchester/Desktop/Figures/SpecPaper/';
Vary = "kappa";
o1 = 1; o2 = 1;
f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
nu = 2e-4; nuS = normaltoS(nu, 'nu',1);
%kappa = 2e-4; kappaS = normaltoS(kappa, 'kappa',1);
if Vary == "kappa"
    [kappa_list,n_list] = Getkappa_list(AllData,fS,hnuS,o1S,o2S,nuS);
    nu_list =  ones(1,length(kappa_list))*nu;
    Vary = kappa_list;
    constnumS = normaltoS(nu_list(end),'nu',1);
    tit = ['Varykappa_'  constnumS '_m_' num2str(o2)];
    xlab = '$\kappa$';
    nuT = RatoRaT(nu);
    overtit = ['$\nu = ' nuT ',\, m = ' num2str(o2) '$'];
    nu_list = ones(1,length(kappa_list))*nu;
else
    [nu_list,n_list] = Getnu_list(AllData,fS,hnuS,o1S,o2S,kappaS);
    kappa_list = ones(1,length(nu_list))*kappa;
    Vary = nu_list;
    constnumS = normaltoS(kappa_list(end),'kappa',1);
    tit = ['Varynu_kappa' constnumS '_m_' num2str(o2)];
    xlab = '$\nu$';
    kappaT = RatoRaT(kappa);
    overtit = ['$\kappa = ' kappaT ',\, m = ' num2str(o2) '$'];
end
Pr_list = nu_list./kappa_list;
quantities = ["fenk" "denk" "henk"];
err = 50;
% boulding data
clear data
for i=1:length(kappa_list)
    nu = nu_list(i); kappa = kappa_list(i); n = n_list(i);
    nuS =normaltoS(nu, 'nu',1); kappaS =normaltoS(kappa, 'kappa',1); ns = ['n_' num2str(n)];
    for j=1:length(quantities)
        quant = convertStringsToChars(quantities(j));
        data.(quant)(i) = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).calcs.(quant);
        data.([quant 'err'])(i) = abs(AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).calcs.(quant) - AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).calcs.([quant 'err' num2str(err)]));
    end
end
%% figure
% kinetic energy budget, nu constant
figure()
h(1) = loglog(Pr_list,data.fenk,'.r','DisplayName','$B^{\nu}$','MarkerSize',MS), hold on
h(2) = loglog(Pr_list,nu_list.*data.denk,'dr','DisplayName','$\nu S^{\nu}$','MarkerSize',MS*0.3,'MarkerFaceColor','r')
h(3) = loglog(Pr_list,hnu*data.henk,'sr','DisplayName','$\mu L^{\nu}$','MarkerSize',MS*0.3,'MarkerFaceColor','r')
legend('Location','bestoutside');


%% now do kappa const
%nu = 2e-4; nuS = normaltoS(nu, 'nu',1);
kappa = 2e-4; kappaS = normaltoS(kappa, 'kappa',1);
Vary = "nu";
if Vary == "kappa"
    [kappa_list,n_list] = Getkappa_list(AllData,fS,hnuS,o1S,o2S,nuS);
    nu_list =  ones(1,length(kappa_list))*nu;
    Vary = kappa_list;
    constnumS = normaltoS(nu_list(end),'nu',1);
    tit = ['Varykappa_'  constnumS '_m_' num2str(o2)];
    xlab = '$\kappa$';
    nuT = RatoRaT(nu);
    overtit = ['$\nu = ' nuT ',\, m = ' num2str(o2) '$'];
    nu_list = ones(1,length(kappa_list))*nu;
else
    [nu_list,n_list] = Getnu_list(AllData,fS,hnuS,o1S,o2S,kappaS);
    kappa_list = ones(1,length(nu_list))*kappa;
    Vary = nu_list;
    constnumS = normaltoS(kappa_list(end),'kappa',1);
    tit = ['Varynu_kappa' constnumS '_m_' num2str(o2)];
    xlab = '$\nu$';
    kappaT = RatoRaT(kappa);
    overtit = ['$\kappa = ' kappaT ',\, m = ' num2str(o2) '$'];
end
Pr_list = nu_list./kappa_list;
% remove Pr = 25
kappa_list = kappa_list(Pr_list ~= 25);
nu_list = nu_list(Pr_list ~= 25);
n_list = n_list(Pr_list ~= 25);
Pr_list = Pr_list(Pr_list ~= 25);


quantities = ["fenk" "denk" "henk"];
err = 50;
% boulding data
clear data
for i=1:length(kappa_list)
    nu = nu_list(i); kappa = kappa_list(i); n = n_list(i);
    nuS =normaltoS(nu, 'nu',1); kappaS =normaltoS(kappa, 'kappa',1); ns = ['n_' num2str(n)];
    for j=1:length(quantities)
        quant = convertStringsToChars(quantities(j));
        data.(quant)(i) = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).calcs.(quant);
        data.([quant 'err'])(i) = abs(AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).calcs.(quant) - AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).calcs.([quant 'err' num2str(err)]));
    end
end
%% add to fig
h(4) = loglog(Pr_list,data.fenk,'.b','DisplayName','$B^{\kappa}$','MarkerSize',MS), hold on
h(5) = loglog(Pr_list,nu_list.*data.denk,'db','DisplayName','$\nu S^{\kappa}$','MarkerSize',MS*0.3,'MarkerFaceColor','b')
h(6) = loglog(Pr_list,hnu*data.henk,'sb','DisplayName','$\mu L^{\kappa}$','MarkerSize',MS*0.3,'MarkerFaceColor','b')
xlabel('$Pr$')

% Ra arrows
yloc = 1e-3;
x1 = 1e1;
x2 = 30;
yfact = 0.4;
Raxshift = 0.8;
Rayshift = 1.2;
arrow([x1 yloc],[x2 yloc],15,'BaseAngle',60,'width',1,'EdgeColor','r','FaceColor','r');
text(x1*Raxshift,yloc*Rayshift,'$Ra$','Color','r')
arrow([x2 yloc*yfact],[x1 yloc*yfact],15,'BaseAngle',60,'width',1,'EdgeColor','b','FaceColor','b');
text(x2/Raxshift,yloc*yfact/Rayshift,'$Ra$','Color','b')












legend(h,'Location','bestoutside');












saveas(gcf,[figpath 'KineticEnergyBudgetCombined_' tit], 'epsc')
