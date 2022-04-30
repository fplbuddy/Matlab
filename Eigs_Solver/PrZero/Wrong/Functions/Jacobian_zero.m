function J = Jacobian_zero(PsiE, N, Ra,G)
J = zeros(length(PsiE), length(PsiE));
n = [1:2:(N/2-1) 0:2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:);
m = 1:N; m = repelem(m, N/4);
for i=1:length(n) 
    ninst = n(i); minst = m(i);   
    %non linear ones
    modepairs = checkeenew(N, ninst, minst);
    for j=1:length(modepairs) % Looping round non-linear ones
        modes = modepairs(j,:);
        n1 = modes(1); m1 = modes(2); n2 = modes(3); m2 = modes(4);
        % Do psi bit first
        Fac1pos = steadypossmall(N, abs(n1), m1);
        Fac2pos = steadypossmall(N, abs(n2), m2);
        Factor1 = PsiE(Fac1pos); if sign(n1) == -1; Factor1 = -Factor1; end
        Factor2 = PsiE(Fac2pos); if sign(n2) == -1; Factor2 = -Factor2; end
        % 1
        Ainst = A2_zero(n1, m1, n2, m2, G,  minst)/2;
        J(i, Fac1pos) = J(i, Fac1pos) - sign(n1)*Factor2*Ainst;  % The sign() here is from if we have the c.c.
        % 2
        J(i, Fac2pos) = J(i, Fac2pos) - sign(n2)*Factor1*Ainst;
    end
end
kx = 2*pi*n/G; kxsq = kx.^2;  ky = pi*m; Ksq = kx.^2 + ky.^2; Ksqsq = Ksq.^2; kxsqKsqinv = kxsq./Ksq;
kxsqKsqinv = diag(kxsqKsqinv); Ksqsq = diag(Ksqsq);
J = J + Ra*kxsqKsqinv-Ksqsq; % linear
clearvars -except J
end
