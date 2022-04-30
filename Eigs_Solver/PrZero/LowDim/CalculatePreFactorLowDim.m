fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
fpath3 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/LowDim/Functions/';
addpath(fpath)
addpath(fpath2)
addpath(fpath3)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
spath = dpath;
load(dpath);
%%
Pr = 3e-4;
PrS = PrtoPrSZero(Pr);
RaA = 2.55e-4;
RaAS = RaAtoRaAS(RaA);
RaC = 8*pi^4;
Ra = RaC + RaA;
ThetaE = PrZeroData.N_Low.(PrS).(RaAS).ThetaE;
PsiE = PrZeroData.N_Low.(PrS).(RaAS).PsiE;
M = MakeMatrixLowDim(2, PsiE, ThetaE, Ra, Pr);
M([4,5],:) = [];
M(:,[4,5]) = [];

% fix scaling
for i=1:length(M)
    for j=1:length(M)
       if i == j
           M(i,j) = M(i,j)/Pr;
       else
           M(i,j) = M(i,j)/sqrt(RaA);
       end
       
    end
end

% the big sum
res = 0;
for i=1:length(M)
    for j=i+1:length(M) % looping round upper triangular entries
        res = res + (M(i,j)*M(j,i))/(M(i,i)*M(j,j))*RaC/4;   
    end
end


