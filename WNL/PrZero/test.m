addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrActuallyZero/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions')
%%
N = 32;
G = 2;
Amp = 10;
RaC = RaCfunc(G);
Ra = RaC;

ZeroMatrix = MakeMatrixEigProb(N,G, Amp,1);
NormalMatrix = MakeMatrix_paz_v1(Amp,Ra,G,N,N);
% remove even modes from NormalMatrix to copare like with like
n = [(-N/2):(N/2-1)]; n = repmat(n, N);  n = n(1,:);
m = 1:N; m = repelem(m, N);
[~,~,n,m] = GetRemGeneral_nxny(n,m,N,N);
remove = [];
for i=1:length(n)
   if not(rem(n(i)+m(i),2))
   remove = [remove i];
   end
end
NormalMatrix(remove,:) = [];
NormalMatrix(:,remove) = [];
% abs(ZeroMatrix) - abs(NormalMatrix) gives 0, but there is difference in
% the complex bit on the diagonal
[Vzero, eigzero] = eig(ZeroMatrix);
[Vnormal, eignormal] = eig(NormalMatrix);
eigzero = diag(eigzero);
eignormal = diag(eignormal);
[~,I] = max(real(eigzero));
Vzero = Vzero(:,I);
[~,I] = max(real(eignormal));
Vnormal = Vnormal(:,I);


