run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
close all
o1 = 1; o2 = 1;
nu = 2e-3; kappa = 2e-3; f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
nuS = normaltoS(nu,'nu',1); kappaS = normaltoS(kappa,'kappa',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
n = 4096/8;
ns = ['n_' num2str(n)];
path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
kenergy = importdata([path '/Checks/kenergy.txt']);
penergy = importdata([path '/Checks/penergy.txt']);
%% Make plot
figure()
plot(kenergy(:,2)); hold on
plot(penergy(:,2));
xlim([0 100])