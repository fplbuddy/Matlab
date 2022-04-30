% Treads = 1;
% maxNumCompThreads(Treads);
% maxNumCompThreads(Treads);
% Adding the extra functions we want
%fpath = '/mi/share/scratch/winchester/Matlab/Eigs/';
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
addpath(fpath)
addpath(fpath2)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
spath = dpath;
load(dpath);
% constants
N = 128;
G_list = [2.37];
Pr_list = [1e-7];
RaA_list = [4e3];
res = ['N_' num2str(N)];
thres = 1e-13;
getEigv = 0;
WO = 1;
WE = 0;
tic
for k=1:length(G_list)
    G = G_list(k);
    RaC = pi^4*(4+G^2)^3/(4*G^4);
    GS = GtoGS(G);
    for i=1:length(Pr_list)
        Pr = Pr_list(i)
        PrS = PrtoPrSZero(Pr);
        for j = 1:length(RaA_list)
            RaA = RaA_list(j)
            Ra = RaA + RaC;
            RaAS = RaAtoRaAS(RaA);
            try ngot = not(isfield(PrZeroData.(GS).(res).(PrS), RaAS)); catch, ngot = 1; end
            if ngot % If we need to do NR or not
                [PsiE, ThetaE] = GetICZero(RaA, Pr, res,GS,PrZeroData);
                [PsiE, ThetaE] = CheckSize(PsiE, ThetaE,N);
                [PsiE, ThetaE, dxmin] = NR2(PsiE, ThetaE, N, G, Ra, Pr, thres);%, NL);
                PrZeroData.(GS).(res).(PrS).(RaAS).RaA = RaA;
                PrZeroData.(GS).(res).(PrS).(RaAS).Pr = Pr;
                PrZeroData.(GS).(res).(PrS).(RaAS).dxmin = dxmin;
                PrZeroData.(GS).(res).(PrS).(RaAS).PsiE = PsiE;
                PrZeroData.(GS).(res).(PrS).(RaAS).ThetaE = ThetaE;
            else
                ThetaE = PrZeroData.(GS).(res).(PrS).(RaAS).ThetaE;
                PsiE = PrZeroData.(GS).(res).(PrS).(RaAS).PsiE;
            end
            % Solving odd problem
            if WO
                M = MakeMatrixForOddProblem2(N,G, PsiE, ThetaE, Ra, Pr);
                if getEigv
                    [Eigv,sigmaodd] = eig(M);
                    clear M
                    sigmaodd = diag(sigmaodd);
                    [~,indices] = sort(real(sigmaodd),'descend');
                    % getting location of most unstable eigenvalue
                    Eigvnotconj = Eigv(:,indices(1));
                    Eigvconj = Eigv(:,indices(2));
                    clear Eigv
                    sigmaodd(real(sigmaodd) < -10) = [];
                    PrZeroData.(GS).(res).(PrS).(RaAS).sigmaodd = sigmaodd;
                    PrZeroData.(GS).(res).(PrS).(RaAS).Eigv = Eigvnotconj;
                    PrZeroData.(GS).(res).(PrS).(RaAS).Eigvconj = Eigvconj;
                else
                    sigmaodd = eig(M);
                    sigmaodd(real(sigmaodd) < -10) = [];
                    clear M
                    PrZeroData.(GS).(res).(PrS).(RaAS).sigmaodd = sigmaodd;
                end
            end
            % Solving even problem
            if WE
                M = MakeMatrixForEvenProblem2(N,G, PsiE, ThetaE, Ra, Pr);
                if getEigv
                    [Eigv,sigmaeven] = eig(M);
                    clear M
                    sigmaeven = diag(sigmaeven);
                    [~,indices] = sort(real(sigmaeven),'descend');
                    % getting location of most unstable eigenvalue
                    Eigvnotconj = Eigv(:,indices(1));
                    Eigvconj = Eigv(:,indices(2));
                    clear Eigv
                    sigmaeven(real(sigmaeven) < -10) = [];
                    PrZeroData.(GS).(res).(PrS).(RaAS).sigmaeven = sigmaeven;
                    PrZeroData.(GS).(res).(PrS).(RaAS).Eigv = Eigvnotconj;
                    PrZeroData.(GS).(res).(PrS).(RaAS).Eigvconj = Eigvconj;
                else
                    sigmaeven = eig(M);
                    sigmaeven(real(sigmaeven) < -10) = [];
                    clear M
                    PrZeroData.(GS).(res).(PrS).(RaAS).sigmaeven = sigmaeven;
                end
            end
        end
    end
end
toc
save(spath,"PrZeroData")
