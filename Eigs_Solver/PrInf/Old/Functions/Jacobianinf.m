function J = Jacobianinf(ThetaE, N, Ra,G)
J = zeros(length(ThetaE), length(ThetaE));
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
        Factor1 = ThetaE(Fac1pos); %if sign(n1) == -1; Factor1 = -Factor1; end Dont want this as we are not dealing with c.c.
        Factor2 = ThetaE(Fac2pos); %if sign(n2) == -1; Factor2 = -Factor2; end
        % 1
        Ainst = 1i*A2inf(n1, m1, n2, m2, G,  minst)/2; % NOT 100% ABOUT THE i HERE, BUT I THINK IT IS RIGHT
        J(i, Fac1pos) = J(i, Fac1pos) + Factor2*Ainst; %sign(n1)*Factor2*Ainst;  % The sign() here is from if we have the c.c.
        % 2
        J(i, Fac2pos) = J(i, Fac2pos) + Factor1*Ainst;%sign(n2)*Factor1*Ainst; % think it should actually be plus???? and maybe no sign?
    end
end
J = J*Ra;
kx = 2*pi*n/G;  ky = pi*m; sq = kx.^2 + ky.^2; sqsq = sq.^2;
linear = diag((kx.^2./sqsq)*Ra-sq);
J = J + linear; % linear
clearvars -except J
end
