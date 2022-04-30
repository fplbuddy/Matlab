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
% constants
RaC = 8*pi^4;
G = 2;
Pr_list = [2*1e-5]; %1e-4 1e-3 1e-2 1e-1 1]; %[1e-5 2e-5 3e-5 6e-5 1e-4 2e-4 3e-4 6e-4 1e-3 2e-3 3e-3 6e-3 1e-2 2e-2 3e-2 6e-2];
RaA_list = [1e-5 1e-4];
res = 'N_Low';
tic
RaAold = 1e-7;
for i=1:length(Pr_list)
    RaA = RaAold;
    Pr = Pr_list(i);
    PrS = PrtoPrSZero(Pr);
    Done = 0;
    %for j = 1:length(RaA_list)
    start = 1;
    while not(Done)
        %RaA = RaA_list(j);
        RaAold = RaA;
        if not(start) RaA = RaA*10; end
        RaA = round(RaA,3,'significant');
        Ra = RaA + RaC;
        RaAS = RaAtoRaAS(RaA);     
%         try ngot = not(isfield(PrZeroData.(res).(PrS), RaAS)); catch, ngot = 1; end
%         if ngot % If we need to do NR or not
%             [PsiE, ThetaE] = GetICZero(RaA, Pr, 'N_8' ,PrZeroData);
%             [PsiE, ThetaE, dxmin] = NR(PsiE, ThetaE, 8, G, Ra, Pr);%, NL);
%             if abs(PsiE) < 1e-10
%                 stop % have converged to 0
%             end
%             PrZeroData.N_8.(PrS).(RaAS).RaA = RaA;
%             PrZeroData.N_8.(PrS).(RaAS).Pr = Pr;
%             PrZeroData.N_8.(PrS).(RaAS).dxmin = dxmin;
%             PrZeroData.N_8.(PrS).(RaAS).PsiE = PsiE;
%             PrZeroData.N_8.(PrS).(RaAS).ThetaE = ThetaE;
%         else
%             ThetaE = PrZeroData.N_8.(PrS).(RaAS).ThetaE;
%             PsiE = PrZeroData.N_8.(PrS).(RaAS).PsiE;
%         end
        modPsiE = sqrt(RaA/RaC)*2;
        modThetaE = 4*modPsiE*pi^3/Ra;
        M = MakeMatrixLowDim(modPsiE, modThetaE, Ra, Pr);
        [vectors, sigmaodd] = eig(M);
        sigmaodd = diag(sigmaodd);
        PrZeroData.(res).(PrS).(RaAS).RaA = RaA;
        PrZeroData.(res).(PrS).(RaAS).Pr = Pr;
        PrZeroData.(res).(PrS).(RaAS).sigmaodd = sigmaodd;
        PrZeroData.(res).(PrS).(RaAS).vectors = vectors;
        Done = max(real(sigmaodd)) > 0;
        start = 0;
    end
end
toc
save(spath,'PrZeroData')