function [sig, F] = GetFandSig(A,n,m,N,G,positionMatrix) 
    M = MakeMatrixEigProb(N,G, A);
    [V, sigma] = eig(M);
    sigma = diag(sigma);
    [~,I] = max(real(sigma));
    V = V(:,I);
    sig = sigma(I);
    F = imag(GetF(V,n,m,positionMatrix,N,G));
end