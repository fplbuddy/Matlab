fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
addpath(fpath)
addpath(fpath2)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
spath = dpath;
load(dpath);
% constants
RaC = 8*pi^4;
N = 64;
G = 2;
Pr_list = [1.86e-2];
RaA_list = [3.03e3 3.02e3 3.01e3]; %[1380 3230 8000]; 
WE = 0;
WO = 1;
res = ['N_' num2str(N)];
clean = 1;
DNS = 0;
tic
for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrSZero(Pr);
    for j = 1:length(RaA_list)
        RaA = RaA_list(j)
        Ra = RaA + RaC;
        RaAS = RaAtoRaAS(RaA);
        try ngot = not(isfield(PrZeroData.(res).(PrS), RaAS)); catch, ngot = 1; end
        if ngot % If we need to do NR or not
%             [PsiE, ThetaE] = GetICZero(RaA, Pr, res ,PrZeroData);
            PsiE = PrZeroData.N_32.Pr_1e_3.RaA_1e2.PsiE;
            ThetaE = PrZeroData.N_32.Pr_1e_3.RaA_1e2.ThetaE;
            N = 32;
            nbig = [1:2:(N/2-1) 0:2:(N/2-2)]; nbig = repmat(nbig, N/2);  nbig = nbig(1,:);
            mbig = 1:N; mbig = repelem(mbig, N/4);
            N = 16;
            nsmall = [1:2:(N/2-1) 0:2:(N/2-2)]; nsmall = repmat(nsmall, N/2);  nsmall = nsmall(1,:);
            msmall = 1:N; msmall = repelem(msmall, N/4);
            rems = [];
            for i =1:length(nbig)
                nbiginst = nbig(i);
                mbiginst = mbig(i);
                rem = 1;
                for j =1:length(nsmall)
                    nsmallinst = nsmall(j);
                    msmallinst = msmall(j);
                    if nbiginst == nsmallinst && mbiginst == msmallinst
                        rem = 0;
                    end
                end
                if rem
                    rems = [rems i];
                end
            end
            PsiE(rems) = [];
            ThetaE(rems) = [];
            
            [PsiE, ThetaE, dxmin] = NR2(PsiE, ThetaE, N, G, Ra, Pr,1e-15);%, NL);
            PrZeroData.(res).(PrS).(RaAS).RaA = RaA;
            PrZeroData.(res).(PrS).(RaAS).Pr = Pr;
            PrZeroData.(res).(PrS).(RaAS).dxmin = dxmin;
            PrZeroData.(res).(PrS).(RaAS).PsiE = PsiE;
            PrZeroData.(res).(PrS).(RaAS).ThetaE = ThetaE;
        else
            ThetaE = PrZeroData.(res).(PrS).(RaAS).ThetaE;
            PsiE = PrZeroData.(res).(PrS).(RaAS).PsiE;
        end
        if WO
            % Solving odd problem
            M = MakeMatrixForOddProblem(N,G, PsiE, ThetaE, Ra, Pr);
            if clean
                [M,rem] = CleanEigenMatrix(M, N,"odd", DNS); %
            end
            PrZeroData.(res).(PrS).(RaAS).clean = clean;
            PrZeroData.(res).(PrS).(RaAS).DNS = DNS;
            sigmaodd = eig(M);
            clear M
            PrZeroData.(res).(PrS).(RaAS).sigmaodd = sigmaodd;
        end
        if WE
            % Solve even problem
            M = MakeMatrixForEvenProblem(N,G, PsiE,ThetaE, Ra, Pr);
            if clean
                [M,rem] = CleanEigenMatrix(M, N,"even", DNS); %
            end
            sigmaeven = eig(M);
            clear M
            PrZeroData.(res).(PrS).(RaAS).sigmaeven = sigmaeven;
        end
    end
end
toc
save(spath,'PrZeroData')