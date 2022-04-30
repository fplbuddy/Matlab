figure('Renderer', 'painters', 'Position', [5 5 700 200])

run SetUp.m
load('/Volumes/Samsung_T5/OldData//masternew.mat')
AR = 'AR_2';
PrS = 'Pr_30';
type = 'OneOne32';
RaC = 8*pi^4;

% Making the fields
N = 32;
Ra = 100 + RaC;
RaS = RatoRaS(Ra);
[PsiPlot, ThetaPlot] =  PlotEvenFunc(Data.(AR).(type).(PrS).(RaS).PsiE, Data.(AR).(type).(PrS).(RaS).ThetaE, 32, 1);
subplot(1,2,1)
pcolor(PsiPlot);
shading flat
colormap('jet')
c = colorbar;
c.FontSize = numFS;
xlabel('$x/(\pi d)$', 'FontSize', LabelFS)
ylabel('$y/(\pi d)$', 'FontSize', LabelFS)
xticks([1 2*N])
xticklabels({'$0$' '$\Gamma$'})
yticks([1 2*N])
yticklabels({'$0$' '$1$'})
title('$\psi/\kappa$', 'FontSize', TitleFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;

subplot(1,2,2)
pcolor(ThetaPlot);
shading flat
colormap('jet')
c = colorbar;
c.FontSize = numFS;
xlabel('$x/(\pi d)$', 'FontSize', LabelFS)
%ylabel('$y/(\pi d)$', 'FontSize', LabelFS)
xticks([1 2*N])
xticklabels({'$0$' '$\Gamma$'})
yticks([1 2*N])
yticklabels({'$0$' '$1$'})
title('$\theta/\Delta T$', 'FontSize', TitleFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;