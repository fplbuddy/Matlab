fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions';
addpath(fpath);
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath)
%%
N = 400;
n = [(-N/2+1):(N/2)]; n = repmat(n, N);  n = n(1,:);
m = 1:N; m = repelem(m, N);
[~,~,n,m] = GetRemGeneral(n,m,N);
%% get even steady state
Ra = 2.54e7;
Pr = 7e5;
RaS = RatoRaS(Ra);
PrS = PrtoPrS(Pr);
PsiE = Data.AR_2.OneOne400.(PrS).(RaS).PsiE; 
ThetaE = Data.AR_2.OneOne400.(PrS).(RaS).ThetaE;
% expand even steady state
% first get conj
nc = [(-N/2+1):2:(N/2-1) (-N/2):2:(N/2-1)]; nc = repmat(nc, N/2);  nc = nc(1,:);
mc = 1:N; mc = repelem(mc, N/2);
[~,~,nc,mc] = GetRemGeneral(nc,mc,N);
[~,~,nold,mold] = GetRemKeep(N,1);
positionMatrixold = MakepositionMatrix(nold,mold);
psinew = PsiE;
thetanew = ThetaE;
for i=1:length(nc)
    ninst = nc(i);
    if ninst < 0 % then we add something to v1
        minst = mc(i);
        I = positionMatrixold(minst,abs(ninst)+1);
        fact = conj(PsiE(I));
        fact2 = conj(ThetaE(I));
        psinew = [psinew(1:i-1); fact; psinew(i:end)]; % adding
        thetanew = [thetanew(1:i-1); fact2; thetanew(i:end)];
    end  
end
PsiE = psinew;
ThetaE = thetanew;
% now add odd modes
for i=1:length(n)
    ninst = n(i); minst = m(i);
    if rem(ninst+minst,2) ~= 0 
        psinew = [psinew(1:i-1); 0; psinew(i:end)];
        thetanew = [thetanew(1:i-1); 0; thetanew(i:end)];
    end  
end
PsiE = psinew;
ThetaE = thetanew;
clear psinew thetanew

%% Get eigenfunc
EigvNZ = Data.AR_2.OneOne400.(PrS).(RaS).EigvNZ;

PsiV = 1i*imag(EigvNZ(1:length(EigvNZ)/2));
ThetaV = real(EigvNZ(length(EigvNZ)/2+1:end));
psinew = PsiV;
thetanew = ThetaV;
% add even modes
for i=1:length(n)
    ninst = n(i); minst = m(i);
    if rem(ninst+minst,2) == 0 
        psinew = [psinew(1:i-1); 0; psinew(i:end)];
        thetanew = [thetanew(1:i-1); 0; thetanew(i:end)];
    end  
end
PsiV = psinew;
ThetaV = thetanew;
clear psinew thetanew
%% Now do calculation
G = 2;
K2 = ((2*pi/G)*n').^2 + (pi*m').^2;
stop
[r1, check] = Poisson(PsiE,-K2.*PsiV,N,n,m,G,1);

r2 = Poisson(PsiV,-K2.*PsiE,N,n,m,G);
[r3, check] = Poisson(PsiV,-K2.*PsiV,N,n,m,G,1);