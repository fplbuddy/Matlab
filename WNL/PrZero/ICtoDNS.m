G = 0.4;
N = 32;
eps = 1e-1;
GS = GtoGS(G);
As = WNLZero.(GS).As;
sigmas = WNLZero.(GS).sigmas;
Fs = WNLZero.(GS).Fs;
[~, Astar, Bstar] = FindBifPointZero2(As,sigmas,imag(Fs));
a = (1+G^2/4); Astar = a*Astar;
b = a*(4+G^2)*pi^2/G^2; Bstar = b*Bstar;

Out = SaveICs(Astar,Bstar,eps,G,N);