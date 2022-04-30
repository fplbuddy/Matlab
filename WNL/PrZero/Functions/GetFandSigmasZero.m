function [Fs,sigmas,As] = GetFandSigmasZero(As,N,G,n,m,positionMatrix)
sigmas = zeros(1,length(As));
Fs = zeros(1,length(As));
for i = 1:length(As)
    A = As(i);
    M = MakeMatrixEigProb(N,G, A,1);
    [V, sigma] = eig(M);
    sigma = diag(sigma);
    [~,I] = max(real(sigma));
    V = V(:,I);
    sigmas(i) =  sigma(I);
    Fs(i) = GetF(V,n,m,positionMatrix,N,G);
end
a = (1+G^2/4);
b = a*(4+G^2)*pi^2/G^2;
As = As/a;
Fs = Fs*b^2;
sigmas = sigmas*b;
end

