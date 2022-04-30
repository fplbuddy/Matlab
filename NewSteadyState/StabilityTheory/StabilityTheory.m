addpath('/Users/philipwinchester/Dropbox/Matlab/GeneralFuncs')
addpath('/Users/philipwinchester/Dropbox/Matlab/NewSteadyState/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions');
run SetUp.m
path = '/Volumes/Samsung_T5/OldData/NewSteadyState.mat';
load(path)
RaA = 1.02e-3; Pr = 1e-4; G = 2; Nx = 32; Ny = 32;
GS = GtoGS(G);
type = ['N_' num2str(Nx) 'x' num2str(Ny)];
RaAS = RaAtoRaAS(RaA); PrS = PrtoPrS(Pr);
PsiE = Data.(GS).(type).(PrS).(RaAS).PsiE;
ThetaE = Data.(GS).(type).(PrS).(RaAS).ThetaE;
% remove even modes (apart from 0,2 in theta) and devide by Pr^2
[~,~,n,m,~] = GetRemKeepnss_nxny(Nx,Ny);
for i=1:length(n)
   if not(rem(n(i)+m(i),2)) 
       PsiE(i) = 0;
       if not(n(i) == 0 &&  m(i) == 2)
           ThetaE(i) = 0;
       end
   end
end
PsiE = PsiE/Pr^2;
ThetaE = ThetaE/Pr^2;
M = MakeMatrix_nxny2_nodiag(Nx,Ny,G, PsiE, ThetaE);
sigma = eig(M);
figure()
plot(real(sigma),imag(sigma),'b.')

saveas(gcf,[figpath 'StabilityTheory'], 'epsc')
