function PrZeroData = GetAllEigsFunc(PrZeroData,N,G,RaA,Pr,thres,getEigv,WO,WE)
% constants
res = ['N_' num2str(N)];
RaC = pi^4*(4+G^2)^3/(4*G^4);
GS = GtoGS(G);
PrS = PrtoPrSZero(Pr);
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
% temoporary swithch in x by G/2
% [~,~,n,~] = GetRemKeep(N,1);
% for i = 1:length(n)
% if rem(n(i),2)
% PsiE(i) = -PsiE(i);
% ThetaE(i) = -ThetaE(i);
% end
% end
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

