function [Rem,Keep,n,m,signvector] = GetRemKeepnss_nxny(Nx,Ny)
mmax = floor(2*Ny/3);
nmax = floor(Nx*sqrt(1/9-1/(4*Ny^2)));
n = [0:nmax]; n = repmat(n, mmax);  n = n(1,:);
m = 1:mmax; m = repelem(m, nmax+1);  m = m(1,:);
kn2 = n.^2/Nx^2 + m.^2/(4*Ny^2);
Rem = [];
Keep = [];
for i=1:length(kn2)
    if kn2(i) <= 1/9
        Keep = [Keep i];
    else
        Rem = [Rem i];
    end
end
n(Rem) = [];
m(Rem) = [];
% making signvector for psi, will just be - for theta
signvector = ones(length(n), 1);
for i=1:length(n)
    if not(rem(n(i) + m(i),2)) % if even
        signvector(i) = -1;
    end
end
end
