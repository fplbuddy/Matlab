% Seems to work
N = 152;
n = [(-N/2+1):2:(N/2-1) (-N/2):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions';
addpath(fpath);
%v1 = rand(1,length(n));
%v2 = rand(1,length(n));
% dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
% load(dpath)
Ra = 4e4;
Pr = 9.9;
[~,~,nold,mold] = GetRemKeep(N,1);
positionMatrixold = MakepositionMatrix(nold,mold);
v1 = Data.AR_2.OneOne152.Pr_9_9.Ra_4e4.PsiE; % base vector
v1new = v1;
theta = Data.AR_2.OneOne152.Pr_9_9.Ra_4e4.ThetaE;
thetanew = theta;
for i=1:length(n)
    ninst = n(i);
    if ninst < 0 % then we add something to v1
        minst = m(i);
        I = positionMatrixold(minst,abs(ninst)+1);
        fact = conj(v1(I));
        fact2 = conj(theta(I));
        v1new = [v1new(1:i-1); fact; v1new(i:end)]; % adding
        thetanew = [thetanew(1:i-1); fact2; thetanew(i:end)];
    end  
end
v1 = v1new;
theta = thetanew;
clear v1new thetanew
v3 = zeros(length(n),1);
G = 2;

%% make the linear terms
kx = (2*pi/G)*n';
K2 = ((2*pi/G)*n').^2 + (pi*m').^2;
K4 = K2.^2;
K4psi = K4.*v1;
kxtheta = kx.*theta;
v2 = -K2.*v1;
%%

positionMatrix = MakepositionMatrixEig(n,m);
nmax = max(n);

for i=1:length(n)
    n1 = n(i); m1 = m(i);
    for j=1:length(n)
        n2 = n(j); m2 = m(j);
        n3 = n1 + n2;
        if abs(n3) <= nmax
            Fact = v1(i)*v2(j)*(1i*pi^2/G);
            m31 = m1 - m2;
            if not(m31 == 0) && n3^2/N^2 + m31^2/(4*N^2) < 1/9
                Fact1 = sign(m31)*(n1*m2+n2*m1); % If negative, we get a sign change
                I1 = positionMatrix(abs(m31), n3 + 1 + nmax);
                v3(I1) = v3(I1) + Fact*Fact1;
            end
            m32 = m1 + m2;
            if n3^2/N^2 + m32^2/(4*N^2) < 1/9
                Fact2 = n1*m2-n2*m1;
                I2 = positionMatrix(m32, n3 + 1 + nmax);
                v3(I2) = v3(I2) + Fact*Fact2;
            end
        end
    end
end

check = v3 - Ra*Pr*1i*kxtheta - Pr*K4psi;