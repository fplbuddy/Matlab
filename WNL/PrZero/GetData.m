addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/Functions')
dpath = '/Volumes/Samsung_T5/OldData/WNLZero.mat';
load(dpath);
%%
N = 32;
n = [-(N/2):2:(N/2-1) -(N/2-1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
positionMatrix = MakePositionMatrix(n,m);
As = [1e7 1e8 1e9 1e10 1e11 1e12 1e13 1e14];
G_list = [2];
for j=1:length(G_list)
    G = G_list(j)
    GS = GtoGS(G);
    Fs = [];
    sigmas = [];
    for i = 1:length(As) % this evaluates F(A) and sigmas
        i
        M = MakeMatrixEigProb(N,G, As(i),1);
        [V, sigma] = eig(M);
        sigma = diag(sigma);
        [~,I] = max(real(sigma));
        V = V(:,I);
        sigmas = [sigmas sigma(I)];
        F = GetF(V,n,m,positionMatrix,N,G);
        Fs = [Fs F];
    end
    
    % do the scalings
    a = (1+G^2/4);
    b = a*(4+G^2)*pi^2/G^2;
    As = As/a;
    Fs = Fs*b^2;
    sigmas = sigmas*b;
    % Save
    if isfield(WNLZero.(GS),"As")
        As = [WNLZero.(GS).As As];
        Fs = [WNLZero.(GS).Fs Fs];
        sigmas = [WNLZero.(GS).sigmas sigmas];
        % cleaning
        [As,I] = unique(As,'stable');
        Fs = Fs(I);
        sigmas = sigmas(I);
        % sort
        [As,I] = sort(As);
        Fs = Fs(I);
        sigmas = sigmas(I);
    end
    WNLZero.(GS).As = As;
    WNLZero.(GS).Fs = Fs;
    WNLZero.(GS).sigmas = sigmas;  
end
save(dpath, "WNLZero")