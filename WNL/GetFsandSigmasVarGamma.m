fpath = '/Users/philipwinchester/Dropbox/Matlab/WNL/Functions';
addpath(fpath)
datapath = '/Volumes/Samsung_T5/OldData/WNLData.mat';
load(datapath)
addpath('/Users/philipwinchester/Dropbox/Matlab/chebfun-master');
%% Do Calc
N = 32;
G_list = 2;
n = [-(N/2):2:(N/2-1) -(N/2-1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
positionMatrix = MakePositionMatrix(n,m);
Asold = 0:0.001:6;
Fs = [];
sigmas = [];
for j=1:length(G_list)
    G = G_list(j);
    GS = GtoGS(G);
    for i = 1:length(Asold) % this evaluates F(A) and sigmas
        i
        M = MakeMatrixEigProb(N,G, Asold(i));
        [V, sigma] = eig(M);
        sigma = diag(sigma);
        [~,I] = max(real(sigma));
        V = V(:,I);
        sigmas = [sigmas sigma(I)];
        F = GetF(V,n,m,positionMatrix,N,G);
        Fs = [Fs F];
    end
    % add reverse
    As = [-Asold(end:-1:2) Asold];
    Fs = [-Fs(end:-1:2) Fs];
    sigmas = [sigmas(end:-1:2) sigmas];
    Ktwo = (2*pi/G)^2 + pi^2;
    a = (1/pi)*(4*G^3/(Ktwo^2*(4+G^2)^2))^(1/3);
    As = As/a; % do the scaling
    WNLData.(GS).As = As;
    WNLData.(GS).sigmas = sigmas;
    Fs = imag(Fs);
    WNLData.(GS).Fs = Fs;
    
    [Astar, I] = FindZero(As,sigmas);
    Astar = mean(abs(Astar));
    F = mean([-Fs(I(1)) Fs(I(2))]); % odd function
    Fsdash = diff(Fs)/mean(diff(As));
    Fdash = mean(Fsdash(I));
    WNLData.(GS).calcs.F = F;
    WNLData.(GS).calcs.Fdash = Fdash;
    WNLData.(GS).calcs.Astar = Astar;
    WNLData.(GS).calcs.pitch = Astar^2;
    WNLData.(GS).calcs.hopf = Astar^2+2*Astar^2*F/(F-Astar*Fdash);
    clear As
    Fs = [];
    sigmas = [];
end

save(datapath, "WNLData")

%% Doing a check
N = 32;
G_list = [2];
n = [-(N/2):2:(N/2-1) -(N/2-1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
positionMatrix = MakePositionMatrix(n,m);
Asold = 6;
Fs = [];
sigmas = [];
for j=1:length(G_list)
    G = G_list(j);
    GS = GtoGS(G);
    for i = 1:length(Asold) % this evaluates F(A) and sigmas
        i
        M = MakeMatrixEigProb(N,G, Asold(i));
        [V, sigma] = eig(M);
        sigma = diag(sigma);
        [~,I] = max(real(sigma));
        V = V(:,I);
        sigmas = [sigmas sigma(I)];
        F = GetF(V,n,m,positionMatrix,N,G);
        Fs = [Fs F];
    end
    % add reverse
    As = [-Asold(end:-1:2) Asold];
    Fs = [-Fs(end:-1:2) Fs];
    sigmas = [sigmas(end:-1:2) sigmas]
    Ktwo = (2*pi/G)^2 + pi^2;
    a = (1/pi)*(4*G^3/(Ktwo^2*(4+G^2)^2))^(1/3);
    As = As/a; % do the scaling
end
