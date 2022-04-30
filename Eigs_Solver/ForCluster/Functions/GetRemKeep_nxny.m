function [Rem,Keep,n,m] = GetRemKeep_nxny(Nx,Ny,DNS)
%mmax = floor(2*N/3);
%nmax = floor(N*sqrt(1/9-1/(4*N^2)));
n = [1:2:(Nx/2-1) 0:2:(Nx/2-2)]; n = repmat(n, Ny/2); n = n(1,:);
m = 1:Ny; m = repelem(m, Nx/4);



kn2 = n.^2/Nx^2 + m.^2/(4*Ny^2);
Rem = [];
Keep = [];
if DNS
    comp = 1/9;
else
    comp = 1/4;
end
for i=1:length(kn2)
    if kn2(i) < comp
        Keep = [Keep i];
    else
        Rem = [Rem i];
    end
end
n(Rem) = [];
m(Rem) = [];

end
