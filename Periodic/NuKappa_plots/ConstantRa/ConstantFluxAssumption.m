run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
o1 = 4; o2 = 1;
f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
%
overtit = '$Ra = (2\pi)^{15}/(10^{-19})^2$';
%overtit = '$Ra = (2\pi)^{3}/(2\times10^{-5})^2$';
%
nu_list = [1e-18 3.16e-19 1e-19 3.16e-20 1e-20];
%nu_list = [2e-4 6.32e-5 2e-5 6.32e-6 2e-6];
kappa_list = flip(nu_list,2);
n = 4096/2;
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
end

%% plot
for i=1:length(nu_list)
    Pr = Pr_list(i); PrT = RatoRaT(Pr);
    nu = nu_list(i); kappa = kappa_list(i);
    nuS =normaltoS(nu, 'nu',1); kappaS =normaltoS(kappa, 'kappa',1); 
    Presult = Data.(nuS).(kappaS).Presult;
    Before = Presult(1:end-1);
    After = Presult(2:end);
    figure()
    %semilogy(abs(Before./After));
    semilogy(abs(Presult./max(Presult)));
    title(['$Pr = ' PrT '$'])
    ylim([0.1 10])
end










