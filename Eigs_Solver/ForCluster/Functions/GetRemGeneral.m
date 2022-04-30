function [Rem,Keep,n,m] = GetRemGeneral(n,m,N)
kn2 = n.^2/N^2 + m.^2/(4*N^2);
Rem = [];
Keep = [];
comp = 1/9;
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
