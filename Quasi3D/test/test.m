run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Ly = 1; Pr = 30; Ra = 3e5j;
LyS = normaltoS(Ly,'Ly',1); PrS = normaltoS(Pr,'Pr',1); RaS = normaltoS(Ra,'Ra',1);
Nx = 128; Ny = 128; 
NS = ['N_' num2str(Nx) 'x' num2str(Ny)];
type = 'NonShearing';
IC = ['IC_' type(1)];
path = AllData.(IC).(NS).(PrS).(RaS).(LyS).path;
kenergy2 = importdata([path '/Checks/kenergy2.txt']);


[alpha, ~, ~, ~, ~] = Fitslogy(kenergy2(:,1),kenergy2(:,2));
kappa = sqrt((pi)^3/(Ra*Pr));
alphachek = alpha*pi^2/(kappa*2) % 2 becouse thing is squared
