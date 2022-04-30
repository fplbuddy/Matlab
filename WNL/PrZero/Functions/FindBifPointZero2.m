function [point, Astar,Bstar] = FindBifPointZero2(As,sigmas,Fs)
[~,I] = min(abs(sigmas));
Astar = As(I);
Fstar = Fs(I);
Fderiv = diff(Fs)./diff(As);
Fderivstar = Fderiv(I);
point = 1 - Astar*Fderivstar/Fstar;
Bstar = sqrt(Astar/abs(Fstar));
end

