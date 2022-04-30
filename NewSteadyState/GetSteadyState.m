fpath = '/Users/philipwinchester/Dropbox/Matlab/NewSteadyState/Functions';
addpath(fpath);
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions';
addpath(fpath);
% get data
path = '/Volumes/Samsung_T5/OldData/NewSteadyState.mat';
load(path)
RaC = 8*pi^4;
%Ra_list = RaC + [100 200];
Ra_list = [798 797];
Pr_list = 1e-2;
N = 32;
type = ['N_' num2str(N)];
G = 2;
thres = 1e-14;

for i=1:length(Pr_list)
    Pr = Pr_list(i);
    PrS = PrtoPrS(Pr);
    for j=1:length(Ra_list)
        Ra = round(Ra_list(j),7, 'significant');
        RaS = RatoRaS(Ra);
        kappa = sqrt((pi)^3/(Ra*Pr));
        [PsiE, ThetaE] = GetICnss(Ra, Pr, Data, type); 
        [PsiE, ThetaE, dxmin] = NR2(PsiE, ThetaE, N, G, Ra, Pr,thres);
        Data.(type).(PrS).(RaS).PsiE = PsiE;
        Data.(type).(PrS).(RaS).ThetaE = ThetaE;
        Data.(type).(PrS).(RaS).dxmin = dxmin;
    end
end
ss
save(path,'Data')





