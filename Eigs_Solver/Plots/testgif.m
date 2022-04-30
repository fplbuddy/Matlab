% Some sample data:
t = sin(linspace(0,2*pi,30));
[X,Y,Z] = peaks(500);

% Plot the first frame:
h = surf(X,Y,Z*t(1));
shading interp
axis([-3 3 -3 3 -9 9])

% Make it fancy:
camlight
set(gca,'color','k')
set(gcf,'color','k')
caxis([min(Z(:)) max(Z(:))])

gif('myfile.gif')

% for k = 2:29
%    set(h,'Zdata',Z*t(k))
%    gif
% end