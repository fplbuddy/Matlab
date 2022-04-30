[cs,Hs] = polyfitA(As',sigmas',200);
[cf,Hf] = polyfitA(As',imag(Fs'),200);

p = polyfit(As',sigmas',200);

p2 = fit(As',sigmas','poly2');

tic
for i=1:0.01:50
polyvalA(cs,Hs,i);
end
toc
tic
for i = 1:0.01:50
interp1(As,sigmas,i);
end
toc
tic
for i = 1:0.01:50
interp1(As,sigmas,i,'spline');
end
toc
% tic
% for i = 1:0.1:50
% y = polyval(p,i);
% end
% toc
% tic
% for i = 1:0.1:50
% y = spline(As,sigmas,i);
% end
% toc
tic
for i = 1:0.01:50
    y =  feval(p2,i);
end
toc