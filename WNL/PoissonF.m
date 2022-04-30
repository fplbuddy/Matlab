fpath = '/Users/philipwinchester/Dropbox/Matlab/WNL/Functions';
addpath(fpath)
datapath = '/Volumes/Samsung_T5/OldData/WNLData.mat';
load(datapath)
addpath('/Users/philipwinchester/Dropbox/Matlab/chebfun-master');
%%
N = 32;
% want odd and even here
n = [-(N/2):(N/2-1)]; n = repmat(n, N);  n = n(1,:);
m = 1:N; m = repelem(m, N);
[~,~,n,m] = GetRemGeneral(n,m,N);
kx = (2*pi/G)*n';
K2 = ((2*pi/G)*n').^2 + (pi*m').^2;

nold = [-(N/2):2:(N/2-1) -(N/2-1):2:(N/2-1)]; nold = repmat(nold, N/2);  nold = nold(1,:);
mold = 1:N; mold = repelem(mold, N/2);
[~,~,nold,mold] = GetRemGeneral(nold,mold,N);
As = 0:0.01:100;
Fs = [];
G = 2;
for i = 1:length(As) % this evaluates F(A) and sigmas
    i
    M = MakeMatrixEigProb(N,G, As(i));
    [V, sigma] = eig(M);
    sigma = diag(sigma);
    [~,I] = max(real(sigma));
    V = V(:,I);
    % expand V here
    Vnew = V;
    for i=1:length(n)
        ninst = n(i); minst = m(i);
        if rem(ninst+minst,2) == 0 % then we add something to v1
            Vnew = [Vnew(1:i-1); 0; Vnew(i:end)]; % adding
        end
    end
    V = Vnew;
    clear Vnew
    V2 = -K2.*V;
    V3 = Poisson(V,V2,N,n,m,G);
    F = V3(max(n)+2); % just pick out the component
    Fs = [Fs F];
end
