function [PsiE] = GetICsFromWNL(RaA, WNLZero,G,Nx,Ny)
    GS = GtoGS(G);
    eps = sqrt(RaA);
    As = WNLZero.(GS).As;
    sigmas = WNLZero.(GS).sigmas;
    Fs = WNLZero.(GS).Fs;
    [~, Astar, Bstar] = FindBifPointZero2(As,sigmas,imag(Fs));
    a = (1+G^2/4); Astar = a*Astar;
    b = a*(4+G^2)*pi^2/G^2; Bstar = b*Bstar;
    
    % Here A and B are in the form before we have put in standard form
    M = MakeMatrixEigProb_2(Nx,Ny,G, Astar,1); % use N = 32 here
    [V, sigma] = eig(M);
    sigma = diag(sigma);
    [~,I] = max(real(sigma));
    V = V(:,I);
    % These are the n and m for V
    nodd = [(-Nx/2):2:(Nx/2-1) (-Nx/2+1):2:(Nx/2-1)]; nodd = repmat(nodd, Ny/2);  nodd = nodd(1,:);
    modd = 1:Ny; modd = repelem(modd, Nx/2);
    [~,~,nodd,modd] = GetRemGeneral_nxny(nodd,modd,Nx,Ny);
    % this is the modes for the final thing
    [~,~,n,m,~] = GetRemKeepnss_nxny(Nx,Ny);
    % make some sort of position matrix
    positionMatrix = MakepositionMatrix(n,m);
    % Adding V to PsiE
    PsiE = zeros(length(n),1);
    for i=1:length(nodd)
       if nodd(i) >= 0
        I = positionMatrix(modd(i),nodd(i)+1);
        PsiE(I) = V(i)*Bstar*eps;
       end
    end
    % now adding 1,1
    I = positionMatrix(1,2);
    PsiE(I) = -Astar;
end

