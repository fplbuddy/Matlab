addpath('/Users/philipwinchester/Dropbox/Matlab/MeansDNSEig/Functions');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/GeneralFuncs');
addpath('/Users/philipwinchester/Dropbox/Matlab/GeneralFuncs');
dpath = '/Volumes/Samsung_T5/OldData/DataMeanField.mat';
%% Load data
load(dpath)
Ra_list  = [5e4 4.77e4];
Pr = 30; PrS = normaltoS(Pr,'Pr',1);
nproc = 8;
Nx = 128;
Ny = 128;
res = ['N_' num2str(Nx) 'x' num2str(Ny)];
IC = 'IC_N';
G = 2;
Gy = 1; GyS = normaltoS(Gy,'Gy',1);
for i=1:length(Ra_list)
   Ra = Ra_list(i); RaS = normaltoS(Ra,'Ra',1);
   path = ['/Volumes/Samsung_T5/MeanFields/' num2str(Nx) 'x' num2str(Ny) '/'  PrS '/' RaS ];
   [PsiE,ThetaE] = ExtractMeanFields(Nx,Ny,path,nproc,Ra,Pr);
   M = MakeMatrix_MeanDNS(Nx,Ny,G,Gy, PsiE, ThetaE, Ra, Pr);
   sigma = eig(M); 
   clear M
   DataMeanField.(IC).(res).(PrS).(RaS).(GyS).sigma = sigma;
end
save(dpath,'DataMeanField');
