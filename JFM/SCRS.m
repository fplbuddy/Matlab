%load('/Volumes/Samsung_T5/OldData//masternew.mat')
AR = 'AR_2';
type = 'OneOne400';
run SetUp.m

% Making the fields
RaC = 8*pi^4;
N = 400;
Ra = 3e7;
Pr = 1e6;
G = 2;
[PsiPlot, ThetaPlot] =  PlotEvenFunc(Data, AR, N,Pr,Ra,G);
%%
figure('Renderer', 'painters', 'Position', [5 5 700 200])
subplot(1,2,1)
pcolor(PsiPlot);
shading flat
colormap('jet')
c = colorbar;
c.FontSize = numFS;
xlabel('$x$', 'FontSize', LabelFS)
ylabel('$y$', 'FontSize', LabelFS)
xticks([1 2*N])
xticklabels({'$0$' '$\Gamma$'})
yticks([1 2*N])
yticklabels({'$0$' '$1$'})
title('$\psi$', 'FontSize', TitleFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;

subplot(1,2,2)
pcolor(ThetaPlot);
shading flat
colormap('jet')
c = colorbar;
c.FontSize = numFS;
xlabel('$x$', 'FontSize', LabelFS)
%ylabel('$y/(\pi d)$', 'FontSize', LabelFS)
xticks([1 2*N])
xticklabels({'$0$' '$\Gamma$'})
yticks([1 2*N])
yticklabels({'$0$' '$1$'})
title('$\theta$', 'FontSize', TitleFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;