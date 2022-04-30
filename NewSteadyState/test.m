RaA = 1.02e-5; Pr = 1e-5;
RaC = pi^4*(4+G^2)^3/(4*G^4);
Ra = RaC + RaA;
RaAS = RaAtoRaAS(RaA); PrS = PrtoPrS(Pr);
PsiE = Data.G_2.N_32x32.(PrS).(RaAS).PsiE;
ThetaE = Data.G_2.N_32x32.(PrS).(RaAS).ThetaE;
% % only keep 1,1 
% for i=1:length(PsiE)
%     if i ~= 2
%        PsiE(i) = 0;
%        ThetaE(i) = 0;
%     end
% end
M = MakeMatrix_nxny2(32,32,2, PsiE, ThetaE, Ra, Pr,0);
sigma = eig(M);
figure()
plot(real(sigma), imag(sigma),'.')
xlim([-1e-9 1e-9])