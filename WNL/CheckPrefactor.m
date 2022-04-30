G = 2;
K112 = (2*pi/G)^2 + pi^2;
a = ((4*G^3/((4+G^2)^2*K112^2))^(1/3))/pi;
rhat = (83.1)^2;
r = G*rhat/(2*pi*a)

%% What we are aiming for
load('/Volumes/Samsung_T5/OldData/PrZeroData.mat')


fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
fpath4 = '/Users/philipwinchester/Dropbox/Matlab/Normal/Functions/';
addpath(fpath)
addpath(fpath2)
addpath(fpath4)
% Loading in the old data
RaC = 8*pi^4;
PrS_list = [string(fields(PrZeroData.N_32)); string(fields(PrZeroData.N_64))];
PrS_list(PrS_list == "Pr_2_6e_2") = [];
PrS_list(PrS_list == "Pr_2_5e_2") = [];
PrS_list(PrS_list == "Pr_2_4e_2") = [];
PrS_list(PrS_list == "Pr_2_3e_2") = [];
PrS_list(PrS_list == "Pr_3e_2") = [];
PrS_list(PrS_list == "Pr_1e14") = [];
Pr_list = [];
RaA_list = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPrZero(PrS);
    D = GetFullMZero(PrZeroData,PrS);
    RaA_add = GetCrossings(D);
    Pr_add = ones(1,length(RaA_add))*Pr;
    Pr_list = [Pr_list Pr_add];
    RaA_list = [RaA_list RaA_add];
end
[RaA_list, I] = sort(RaA_list);
Pr_list = Pr_list(I);

RaA_list(Pr_list > 0.01) = [];
Pr_list(Pr_list > 0.01) = [];

[alpha, A, ~, ~, Rval] = FitsPowerLaw(Pr_list,RaA_list); 
% A = 6.16e4

%%
kx = 2;
G = 2;
Ra = ((pi^4/(4*G^4))*(4*kx^2+G^2)^3/kx^2)