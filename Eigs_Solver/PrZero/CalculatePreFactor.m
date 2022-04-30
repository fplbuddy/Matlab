fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
addpath(fpath)
addpath(fpath2)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
load(dpath);
% constants
RaC = 8*pi^4;
N = 32;
G = 2;
Pr_list = [1e-4];
RaA_list = 6.35e-4;
res = ['N_' num2str(N)];
for i=1:length(Pr_list)
    Pr = Pr_list(i);
    PrS = PrtoPrSZero(Pr);
    for j = 1:length(RaA_list)
        RaA = RaA_list(j);
        Ra = RaA + RaC;
        RaAS = RaAtoRaAS(RaA);      
        ThetaE = PrZeroData.(res).(PrS).(RaAS).ThetaE;
        PsiE = PrZeroData.(res).(PrS).(RaAS).PsiE;
        % Only keeping modes we want
        ThetaE([2:N/4, N/4+2:end]) = 0;
        PsiE(2:end) = 0;
        % Solving odd problem
        M = MakeMatrixForOddProblem(N,G, PsiE, ThetaE, Ra, Pr);
        rem = [1:N:N^2/2 N^2/2+1:N^2]; %N^2/2+1:N:N^2]; % get rid of the extra minus and theta bit
        %rem = [513:1024];
        M(:,rem) = [];
        M(rem,:) = [];
    end
end

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
        res = res + ((M(i,j)*M(j,i))/(M(i,i)*M(j,j)))*RaC/4;% taking out the mod(psi1,1) here also  
    end
end


