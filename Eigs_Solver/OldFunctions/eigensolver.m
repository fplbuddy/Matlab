function [V, sigma] = eigensolver(PsiE, ThetaE, N, G, Pr, Ra)
kx = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; kx = repmat(kx, N);  kx = kx(1,:)*2*pi/G; % N rather than N/2 as we want theta also
ky = 1:N; ky = repelem(ky, N/2); ky = repmat(ky, 2); ky = ky(1,:)*pi;
Ktwo = kx.^2 + ky.^2;
kx = diag(kx); ky = diag(ky); Ktwo = diag(Ktwo);

% Easy ones
M2 = -1i*Ra*Pr*inv(Ktwo)*kx*[zeros((N^2/2),(N^2/2)) eye((N^2/2)); zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2))];
M3 = -Pr*Ktwo*[eye((N^2/2)) zeros((N^2/2),(N^2/2)); zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2))];
M5 = 1i*kx*[zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2)); eye((N^2/2)) zeros((N^2/2),(N^2/2))];
M6 = -Ktwo*[zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2)); zeros((N^2/2),(N^2/2)) eye((N^2/2))];

% Hard ones
kx_list = diag(kx); ky_list = diag(ky);
kx_list = kx_list(1:(length(kx_list)/2)); ky_list = ky_list(1:(length(ky_list)/2));
psi1 = zeros((N^2/2),(N^2/2)); psi2 = zeros((N^2/2),(N^2/2)); theta1 = zeros((N^2/2),(N^2/2));
for i=1:length(kx_list)
    ninst = round(kx_list(i)*G/(2*pi)); minst = round(ky_list(i)/pi);
    OnesWeWant = checkoe(ninst, minst, N);
    for j=1:length(OnesWeWant)
        modes = OnesWeWant(j,:);
        nodd = modes(1); modd = modes(2); neven = modes(3); meven = modes(4);
        columninst = columnfind(N, nodd, modd);
        % Getting factors
        if neven == -N/2; PsiFact = 0; ThetaFact = 0; else; steadypos = steadyposition(N, abs(neven), meven); PsiFact = PsiE(steadypos); ThetaFact = ThetaE(steadypos); end
        % in the above, we have the steadyposfind behind the else, since it
        % breaks for nsteady == -N/2
        if sign(neven) == -1; PsiFact = conj(PsiFact); ThetaFact = conj(ThetaFact); end % Getting conjugate if needed
        AFact = A(nodd, modd, neven, meven,G, minst);
        
        % Adding to psi1
        psi1(i,columninst) = psi1(i,columninst) + (Square(nodd,modd,G) - Square(neven,meven,G))*AFact*PsiFact;
        % Adding psi2
        psi2(i,columninst) = psi2(i,columninst) + AFact*ThetaFact;
        % Adding theta1
        theta1(i,columninst) = theta1(i,columninst) - AFact*PsiFact;
    end
end
M1 = (1i/2)*inv(Ktwo)*[psi1 zeros((N^2/2),(N^2/2)); zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2))];
M4 = (-1i/2)*[zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2)); psi2 theta1];

M = M1 + M2 + M3 + M4 + M5 + M6;

[V,sigma] = eig(M);
end

