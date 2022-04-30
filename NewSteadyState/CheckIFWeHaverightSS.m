addpath('/Users/philipwinchester/Dropbox/Matlab/NewSteadyState/Functions')
path = '/Volumes/Samsung_T5/OldData/NewSteadyState.mat';
load(path)
PsiE = Data.G_2.N_32x32.Pr_0_0001.RaA_1e_3.PsiE;
ThetaE = Data.G_2.N_32x32.Pr_0_0001.RaA_1e_3.ThetaE;
Nx = 32;
Ny = 32;
G = 2;
RaA = 1e-3;
RaC = pi^4*(4+G^2)^3/(4*G^4);
Ra = RaC + RaA;
Pr = 1e-4;
% Think what my other results suggest is that (odd) modes with m is even are of
% the wrong sign! So will flip them and see if we converge
[~,~,n,m,~] = GetRemKeepnss_nxny(32,32);
PsiEtest = zeros(length(PsiE),1);
ThetaEtest = zeros(length(PsiE),1);
for i=1:length(n)
    if rem(n(i)+m(i),2) && not(rem(m(i),2))
        PsiEtest(i) = -PsiE(i);
        ThetaEtest(i) = -ThetaE(i);
    else
        PsiEtest(i) = PsiE(i);
        ThetaEtest(i) = ThetaE(i);
    end
end
% now do NR
[PsiR, ThetaR, dxmin] = NR2nss_nxny(PsiEtest, ThetaEtest, Nx, Ny,G, Ra, Pr,1e-13,0);