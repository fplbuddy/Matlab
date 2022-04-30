addpath('/Users/philipwinchester/Dropbox/Matlab/JFM')
run SetUp.m
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions';
addpath(fpath)
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath)
G = 2;
AR = ['AR_' num2str(G)];
%%
p1 = [5.48e-2 1.16e3];
p2 = [1.81e-2 4.12e3];
p3 = [0.2175 2.59e5];
q1 = [0.2 3.32e5];
q2 = [4.97 3.949e6];
q3 = [8.58 1.27e6];
p4 = [6.16 5.43e4];
p5 = [9.53 3.24e4];
q4 = [7e5 2.54e7];
tit = ["$p_1$" "$p_2$" "$p_3$" "$q_1$" "$q_2$" "$q_3$" "$p_4$" "$p_5$" "$q_4$"];
points = [p1; p2 ; p3; q1; q2; q3; p4;p5;q4];
figure('Renderer', 'painters', 'Position', [5 5 1000 2000])
for i=2:2:length(points)*2
    i
    point = points(i/2,:);
    Ra = point(2); Pr = point(1);
    %Ra = 1.16e3; Pr = 5.48e-2;
    if Ra <= 3e3
        N = 64;
    elseif Ra <= 6e5
        N = 152;
    elseif Ra <= 4e6
        N = 256;
    elseif Ra <= 3e7
        N = 400;
    end
    [PsiPlot, ThetaPlot] =  PlotEvenFunc(Data, AR, N,Pr,Ra,G);
    subplot(5,4,i-1)
    pcolor(PsiPlot/max(max(abs(PsiPlot))));
    shading flat
    colormap('jet')
    xticks([1 2*N])
    yticks([1 2*N])
    if i > 15
        xlabel('$x$', 'FontSize', LabelFS)
        %xticklabels({'$0$' '$\Gamma$'})
    else
        %xticklabels({'' ''})
    end
    if i == 2 || i == 6 || i == 10 || i == 14 || i == 18
        ylabel('$y$', 'FontSize', LabelFS)
        %yticklabels({'$0$' '$1$'})
    else
        %yticklabels({'' ''})
    end
    yticklabels({'' ''})
    xticklabels({'' ''})
    if i == 2 || i == 4
        title('$\psi/$max$(|\psi|)$', 'FontSize', TitleFS)
    end
    ax = gca;
    ax.XAxis.FontSize = numFS;
    ax.YAxis.FontSize = numFS;
    text(length(PsiPlot)*0.02,length(PsiPlot)*1.2,tit(i/2), 'FontSize',LabelFS,'Color','r')
    
    subplot(5,4,i)
    pcolor(ThetaPlot/max(max(abs(ThetaPlot))))
    shading flat
    colormap('jet')
    if i == 8
        c = colorbar('position', [0.92 0.55 0.02 0.1]);
        c.FontSize = numFS;
    end
    xticks([1 2*N])
    yticks([1 2*N])
    if i > 15
        xlabel('$x$', 'FontSize', LabelFS)
        %xticklabels({'$0$' '$\Gamma$'})
    else
        %xticklabels({'' ''})
    end
    xticklabels({'' ''})
    yticklabels({'' ''})
    if i == 2 || i == 4
        title('$\theta/$max$(|\theta|)$', 'FontSize', TitleFS)
    end
    ax = gca;
    ax.XAxis.FontSize = numFS;
    ax.YAxis.FontSize = numFS;
    text(length(PsiPlot)*0.02,length(PsiPlot)*1.2,tit(i/2), 'FontSize',LabelFS,'Color','r')
end
saveas(gcf,[figpath 'ManySCRS.eps'], 'epsc')