% Adding the extra functions we want
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/')
% Loading in the old data
load('/Volumes/Samsung_T5/OldData/masternew.mat');
% Setting up some constants
G = 2;
AR = ['AR_' num2str(G)];
N = 32;
Ny = N;
Nx = N;
type = 'OneOne32';
nmpi = 1;
Pr_list = [30];
RaC = round((2*pi^2)^3/pi^2,4);
Ra_list = [1e-4 2e-4 3e-4 6e-4 1e-3 2e-3 3e-3 6e-3 1e-2 2e-2 3e-2 6e-2 1e-1 2e-1 3e-1 6e-1 1 2 3 6 10 20 30 60 100 200 300 600 1000 2000 3000 6000 10000] + RaC;
S = struct('val',cell(1,length(Pr_list)));
parpool('local', nmpi)
parfor i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr)
    temp = struct()
    % Getting ICs
    for j = 1:length(Ra_list)        
        Ra = Ra_list(j);
        RaS = RatoRaS(Ra)
        [PsiE, ThetaE] = GetIC(Ra, Pr, Data, AR, type)      
        [PsiE, ThetaE, dxmin] = NR(PsiE, ThetaE, Nx, Ny, G, Ra, Pr);
        [~, sigmaodd] = eigensolver(PsiE, ThetaE, N, G, Pr, Ra);
        [~, sigmaeven] = eigensolvereven(PsiE, ThetaE, N, G, Pr, Ra)
        % Saving the data
        temp.(AR).(type).(PrS).(RaS).Ra = Ra;
        temp.(AR).(type).(PrS).(RaS).Pr = Pr;
        temp.(AR).(type).(PrS).(RaS).dxmin = dxmin;
        temp.(AR).(type).(PrS).(RaS).PsiE = PsiE;
        temp.(AR).(type).(PrS).(RaS).ThetaE = ThetaE;
        temp.(AR).(type).(PrS).(RaS).sigmaodd = diag(sigmaodd)
        temp.(AR).(type).(PrS).(RaS).sigmaeven = diag(sigmaeven)    
    end
    S(i).val = temp
end
delete(gcp('nocreat'))
save('S.mat', 'S')











