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
res = 'N_Low';
PrS_list = string(fieldnames(PrZeroData.(res)));
tic
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPrZero(PrS);
    D = GetFullMZeroLowDim(PrZeroData,PrS);
    [Done,RaA] = GetNextRaA(D);     
    while not(Done)
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
        
        D = GetFullMZeroLowDim(PrZeroData,PrS);
        [Done,RaA] = GetNextRaA(D); 
    end
end
toc
save(spath,'PrZeroData')