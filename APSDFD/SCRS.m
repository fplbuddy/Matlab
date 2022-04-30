%load('/Volumes/Samsung_T5/OldData//masternew.mat')
AR = 'AR_2';
type = 'OneOne152';
run SetUp.m

% Making the fields
RaC = 8*pi^4;
N = 152;
Ra = 1e5;
Pr = 1;
G = 2;
[PsiPlot, ThetaPlot,xderiv,yderiv] =  PlotEvenFunc(Data, AR, N,Pr,Ra,G,1);
%%
figure('Renderer', 'painters', 'Position', [5 5 400 200], 'Color', 'k')
% Add temperature
tempadd = [1:-1/(length(ThetaPlot)-1):0];
for i=1:length(ThetaPlot)
    TempPlot(i,:) = ThetaPlot(i,:) + tempadd(i);
end

% getting reduced derivatives
HMWW = 16;
step = round(length(xderiv)/HMWW);
want = [1:step:length(xderiv) length(xderiv)];
xderivred = xderiv(want,want);
yderivred = yderiv(want,want);


x = 0:length(xderivred)/length(TempPlot):length(xderivred); 
y = 0:length(xderivred)/length(TempPlot):length(xderivred); 
x(1) = [];
y(1) = [];
[xx, yy] = meshgrid(x,y);
pcolor(xx,yy,TempPlot); hold on
shading interp
colormap('jet')
xlabel('$x$', 'FontSize', LabelFS, 'Color', 'w')
ylabel('$y$', 'FontSize', LabelFS, 'Color', 'w')
%ylabel('$y/(\pi d)$', 'FontSize', LabelFS)
%xticks([1 2*N])
xticks([])
%xticklabels({'$0$' '$\Gamma$'})
%yticks([1 2*N])
yticks([])
%yticklabels({'$0$' '$1$'})
%title('$\theta$', 'FontSize', TitleFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
set(gca,'Color','k')

set(gcf, 'InvertHardCopy', 'off'); 
set(gcf,'Color',[0 0 0]); % RGB values [0 0 0] indicates black color

%print(gcf,[figpath 'SCRS.jpg'], '-djpeg', '-r1000')
% put quiver on top

% remove some entires

x = x(want); 
y = y(want); 
[xx, yy] = meshgrid(x,y);
quiver(xx,yy,-yderivred/300,xderivred/300,'k')
%xlim([0 length(xderiv)])
%ylim([0 length(xderiv)])

saveas(gcf,[figpath 'SCRS'], 'epsc')

