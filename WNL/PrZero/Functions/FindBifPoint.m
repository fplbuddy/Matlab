function point = FindBifPoint1(As,sigmas,Fs)
% making spline with the data
jump = min(diff(As))/10;
xrange = min(As):jump:max(As);
p = pchip(As,1./abs(sigmas),xrange);
[~,I] = findpeaks(p);
if length(I) > 1
    error
end
Astar = xrange(I);
% eveluation z at xstar
p = pchip(As,Fs,xrange);
Fstar = p(I);
% finding the derivative at this point
Fdiff = diff(p)/jump;
Fderiv = Fdiff(I);
point = 1 - Astar*Fderiv/Fstar;
end

