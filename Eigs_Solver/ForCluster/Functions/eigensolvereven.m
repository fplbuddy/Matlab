function sigma = eigensolvereven(PsiE, ThetaE, N, G, Pr, Ra, stencilseven)
kx = [(-N/2+1):2:(N/2-1) (-N/2):2:(N/2-2)]; kx = repmat(kx, N);  kx = kx(1,:)*2*pi/G; % N rather than N/2 as we want theta also
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
psi11 = stencilseven.FactorWeWant1.*PsiEexp;
psi22 = stencilseven.FactorWeWant2.*PsiEexp;
psi33 = stencilseven.FactorWeWant3.*PsiEexp;
theta11 = stencilseven.FactorWeWant1.*ThetaEexp;
theta22 = stencilseven.FactorWeWant2.*ThetaEexp;
theta33 = stencilseven.FactorWeWant3.*ThetaEexp;


psi1 = stencilseven.Stencil1psi1 .* psi11(stencilseven.FactorReshuffle1) + ...
    stencilseven.Stencil2psi1 .* psi22(stencilseven.FactorReshuffle2) + ...
    stencilseven.Stencil3psi1 .* psi33(stencilseven.FactorReshuffle3);

psi2 = stencilseven.Stencil1psi2andtheta1 .* theta11(stencilseven.FactorReshuffle1) + ...
    stencilseven.Stencil2psi2andtheta1 .* theta22(stencilseven.FactorReshuffle2) + ...
    stencilseven.Stencil3psi2andtheta1 .* theta33(stencilseven.FactorReshuffle3);
theta1 = -(stencilseven.Stencil1psi2andtheta1 .* psi11(stencilseven.FactorReshuffle1) + ...
    stencilseven.Stencil2psi2andtheta1 .* psi22(stencilseven.FactorReshuffle2) + ...
    stencilseven.Stencil3psi2andtheta1 .* psi33(stencilseven.FactorReshuffle3));

M1 = (1i/2)*Ktwoinv*[psi1 zeros((N^2/2),(N^2/2)); zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2))];
M4 = (-1i/2)*[zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2)); psi2 theta1];

M = M1 + M2 + M3 + M4 + M5 + M6;
clear M1 M2 M3 M4 M5 M6 Ktwo psi1 psi2 psi3 psi11 psi22 psi33 theta11 theta22 theta33 Ktwoinv

sigma = eig(M);
end

