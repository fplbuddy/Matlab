function [sigma,x,iter,relres] = eigensolverodd2(PsiE, ThetaE, N, G, Pr, Ra, stencilsodd,z0,mu)

kx = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; kx = repmat(kx, N);  kx = kx(1,:)*2*pi/G; % N rather than N/2 as we want theta also
ky = 1:N; ky = repelem(ky, N/2); ky = repmat(ky, 2); ky = ky(1,:)*pi;
Ktwo = kx.^2 + ky.^2;
Ktwoinv = Ktwo.^-1;
% kx = diag(kx); ky = diag(ky); Ktwo = diag(Ktwo);
Ktwo = diag(Ktwo); kx = diag(kx); Ktwoinv = diag(Ktwoinv);
clear ky

% Easy ones
M2 = -1i*Ra*Pr*Ktwoinv*kx*[zeros((N^2/2),(N^2/2)) eye((N^2/2)); zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2))];
M3 = -Pr*Ktwo*[eye((N^2/2)) zeros((N^2/2),(N^2/2)); zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2))];
M5 = 1i*kx*[zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2)); eye((N^2/2)) zeros((N^2/2),(N^2/2))];
M6 = -Ktwo*[zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2)); zeros((N^2/2),(N^2/2)) eye((N^2/2))];

[PsiEexp, ThetaEexp] = Getexp(PsiE, ThetaE, N);
psi11 = stencilsodd.FactorWeWant1.*PsiEexp;
psi22 = stencilsodd.FactorWeWant2.*PsiEexp;
psi33 = stencilsodd.FactorWeWant3.*PsiEexp;
theta11 = stencilsodd.FactorWeWant1.*ThetaEexp;
theta22 = stencilsodd.FactorWeWant2.*ThetaEexp;
theta33 = stencilsodd.FactorWeWant3.*ThetaEexp;


psi1 = stencilsodd.Stencil1psi1 .* psi11(stencilsodd.FactorReshuffle1) + ...
    stencilsodd.Stencil2psi1 .* psi22(stencilsodd.FactorReshuffle2) + ...
    stencilsodd.Stencil3psi1 .* psi33(stencilsodd.FactorReshuffle3);

psi2 = stencilsodd.Stencil1psi2andtheta1 .* theta11(stencilsodd.FactorReshuffle1) + ...
    stencilsodd.Stencil2psi2andtheta1 .* theta22(stencilsodd.FactorReshuffle2) + ...
    stencilsodd.Stencil3psi2andtheta1 .* theta33(stencilsodd.FactorReshuffle3);
theta1 = -(stencilsodd.Stencil1psi2andtheta1 .* psi11(stencilsodd.FactorReshuffle1) + ...
    stencilsodd.Stencil2psi2andtheta1 .* psi22(stencilsodd.FactorReshuffle2) + ...
    stencilsodd.Stencil3psi2andtheta1 .* psi33(stencilsodd.FactorReshuffle3));

M1 = (1i/2)*Ktwoinv*[psi1 zeros((N^2/2),(N^2/2)); zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2))];
M4 = (-1i/2)*[zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2)); psi2 theta1];

M = M1 + M2 + M3 + M4 + M5 + M6;
clear M1 M2 M3 M4 M5 M6 Ktwo psi1 psi2 psi3 psi11 psi22 psi33 theta11 theta22 theta33 Ktwoinv

[sigma,x,iter,relres]=invpower(M,z0,mu,1e-5,10);

end

