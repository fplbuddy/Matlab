function M = MakeMatrixLowDim(G, PsiE, ThetaE, Ra, Pr)
    n = [0 -1 1 -1 1]; 
    m = [1 2 2 2 2];
    kx = n*2*pi/G;
    ky = m*pi;
    Ktwo = kx.^2 + ky.^2;
    Ktwoinv = Ktwo.^-1;
    clear ky
    % Non linear stuff
    psi1 = zeros(3,3); psi2 = zeros(2,3); %theta1 = zeros(2,2);
    % building psi1
    AFact = A(1, 2, -1, 1,G, 1);
    psi1(1,2) = (Square(1,2,G) - Square(-1,1,G))*AFact*conj(PsiE)*Ktwoinv(1)*(1i/2);
    AFact = A(-1, 2, 1, 1,G, 1);
    psi1(1,3) = (Square(-1,2,G) - Square(1,1,G))*AFact*PsiE*Ktwoinv(1)*(1i/2);
    AFact = A(0, 1, -1, 1,G, 2);
    psi1(2,1) = (Square(0,1,G) - Square(-1,1,G))*AFact*conj(PsiE)*Ktwoinv(2)*(1i/2);
    AFact = A(0, 1, 1, 1,G, 2);
    psi1(3,1) = (Square(0,1,G) - Square(1,1,G))*AFact*PsiE*Ktwoinv(3)*(1i/2);
    % Building psi2
    AFact = A(0, 1, -1, 1,G, 2);
    psi2(1,1) = AFact*conj(ThetaE(1))*(-1i/2);
    AFact = A(0, 1, 1, 1,G, 2);
    psi2(2,1) = AFact*ThetaE(1)*(-1i/2);
    % setting everything together
    M = -diag(Ktwo); M(1:3, 1:3) = M(1:3, 1:3)*Pr; % gettting viscous term
    M(2,4) = -1i*Ra*Pr*Ktwoinv(2)*kx(2);
    M(3,5) = -1i*Ra*Pr*Ktwoinv(3)*kx(3);
    M(4,2) = 1i*kx(2);
    M(5,3) = 1i*kx(3);
    % adding the non-linear
    M(1:3, 1:3) = M(1:3, 1:3) + psi1;
    M(4:5,1:3) = M(4:5,1:3) + psi2;
end

