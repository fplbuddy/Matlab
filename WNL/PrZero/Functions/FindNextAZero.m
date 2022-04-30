function [A, cont] = FindNextAZero(WNLZero,G,tol)
a = (1+G^2/4);
GS = GtoGS(G);
As = WNLZero.(GS).As*a;
sigmas = WNLZero.(GS).sigmas;
I = find(sign(sigmas) == 1); I = I(1);
A = (As(I) + As(I-1))/2;
A = round(A,tol,'significant');
cont = not(ismember(A, round(As,tol,'significant')));
end

