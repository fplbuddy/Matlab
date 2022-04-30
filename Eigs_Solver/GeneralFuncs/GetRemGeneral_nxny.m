function [Rem,Keep,n,m] = GetRemGeneral_nxny(n,m,Nx,Ny)
kn2 = n.^2/Nx^2 + m.^2/(4*Ny^2);
Rem = [];
Keep = [];
comp = 1/9;
for i=1:length(kn2)
    if kn2(i) <= comp
        Keep = [Keep i];
    else
        Rem = [Rem i];
    end
end
n(Rem) = [];
m(Rem) = [];

end
