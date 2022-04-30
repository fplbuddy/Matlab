addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/Functions')
dpath = '/Volumes/Samsung_T5/OldData/WNLZero.mat';
load(dpath)
%%
N = 32;
n = [-(N/2):2:(N/2-1) -(N/2-1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
positionMatrix = MakePositionMatrix(n,m);
G_list = [1.8 1.7 1.6 1.5 1.4 1.3 1.2 1.1 1 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1];
tol = 7;
for j=1:length(G_list)
    G = G_list(j)
    GS = GtoGS(G);
    % first check if we have crossing
    WNLZero = GetCrossingZero(WNLZero,G,N,n,m,positionMatrix);
    %
    [A, cont] = FindNextAZero(WNLZero,G,tol);
    while cont
    [Fs,sigmas,As] = GetFandSigmasZero(A,N,G,n,m,positionMatrix);
    WNLZero = AddtoDataZero(WNLZero,GS,As,Fs,sigmas);
    [A, cont] = FindNextAZero(WNLZero,G,tol);
    end
end
save(dpath, "WNLZero")