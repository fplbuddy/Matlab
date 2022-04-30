function [xstar, zstar,zderiv,pitch,hopf] = FindZero(x,y,z)
% making spline with the data
jump = min(diff(x))/10;
xrange = min(x):jump:max(x);
p = pchip(x,1./abs(y),xrange);
[~,I] = findpeaks(p);
if length(I) > 1
    error
end
xstar = xrange(I);
% eveluation z at xstar
p = pchip(x,z,xrange);
zstar = p(I);
% finding the derivative at this point
zdiff = diff(p)/jump;
zderiv = zdiff(I);
% get bifrucation points
hopf = xstar^2+(2*xstar^2*zstar)/(zstar-xstar*zderiv);
pitch = xstar^2;
end

