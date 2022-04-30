addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions');
run SetUp.m
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
load(dpath);

myBlue = [41 170 225]/255;

[Ra_listtot,Pr_listtot] = GetStabBoundary(Data,PrZeroData);
    Pr_listtot = [1e-6 Pr_listtot 1e6];
    Ra_listtot = [1e8 Ra_listtot 1e8];
G = 2;
RaC = RaCfunc(G);
left = 0.7;
right = 1/left;
down = 0.6;
up = 1/down;

% p1 = [0.0548 378+RaC];
% p2 = [0.0186 3200+RaC];
% p3 = [0.2175 1e5*(2.42+2.74)/2];
% p4 = [0.2 1e5*(3.33+3.34)/2];
% p5 = [5 4e6]; % Not accurate yet
% p6 = [8.61 1e6*(1.24+1.25)/2];
% p7 = [6.17 1e4*(6.02+4.96)/2];
% p8 = [8.6 3.26e4]; % Not accurate yet

q1 = [0.2 1e5*(3.33+3.34)/2];
q2 = [5 4e6];
q3 = [8.61 1e6*(1.24+1.25)/2];
q4 = [7e5 2.54e7];

%% making inserts

    h = figure('Renderer', 'painters', 'Position', [5 5 600 300]);
    
    set(gca, 'Layer', 'top')
    patch(Pr_listtot,Ra_listtot,myBlue,'EdgeColor',myBlue), hold on
    patch([1e-6 1e6 1e6 1e-6],[400 400 RaC RaC],'red','EdgeColor','red','FaceAlpha', 0.3,'EdgeAlpha', 0.3)
    set(gca,'yscale', 'log')
    set(gca,'xscale', 'log')
    ax = gca;
    ax.XAxis.FontSize = numFS;
    ax.YAxis.FontSize = numFS;
    ax.TickLength = [0, 0];
    set(gca,'XColor',[1 1 1])
    set(gca,'YColor',[1 1 1])
    xlim([1e-2 1e2])
    ylim([400 1e7 ])
    xlabel('$Pr$','FontSize', LabelFS, 'Color','w')
    ylabel('$Ra$','FontSize', LabelFS, 'Color','w')
    yticks([RaC-10 1e4 1e5 1e6 1e7])
    yticklabels({'$Ra_c$' '$10^4$' '$10^4$' '$10^6$' '$10^7$'})
    xticks([1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1 10 1e2 1e3 1e4 1e5 1e6])


    plot([1e-6 1e6], [RaC RaC], 'k--', 'LineWidth',1)



    
    plot([q1(1) q2(1) q3(1) q4(1)], [q1(2) q2(2) q3(2) q4(2)], '*r', 'MarkerSize',MarkerS)
    text(q1(1)*right,q1(2), '$q_1$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    text(q2(1),q2(2)*down, '$q_2$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    text(q3(1)*left,q3(2), '$q_3$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    text(q4(1),q4(2)*down, '$q_4$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')


    
       %plot([p1(1) p2(1) p5(1) p6(1) p7(1) p8(1) 7e5], [p1(2) p2(2)  p5(2) p6(2) p7(2) p8(2) 2.54e7], '*r', 'MarkerSize',MarkerS)
    %plot([p3(1) p4(1)], [p3(2) p4(2)], '*r', 'MarkerSize',MarkerS)
    %text(p1(1)*right,p1(2), '$p_1$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center')
    %text(p2(1),p2(2)*down, '$p_2$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    %text(p5(1),p5(2)*down, '$q_2$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    %text(p6(1)*right,p6(2), '$q_3$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    %text(p7(1)*left,p7(2), '$p_4$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    %text(p8(1),p8(2)*down, '$p_5$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    %arrow([4e5 1e7],[7e5 2.45e7],5)
    %text(7e5,2.54e7*down, '$q_4$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    %text(4e5*0.9,1e7*0.9, '$q_4$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    %text(p4(1)/right,p4(2), '$q_1$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    %text(p3(1)*right,p3(2), '$p_3$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')

    set(gcf, 'InvertHardCopy', 'off'); 
    set(gcf,'Color',[0 0 0]);
    print(gcf,['/Users/philipwinchester/Desktop/MPr.png'],'-dpng','-r300');


%
%
%% make final plot


%saveas(gcf,[figpath 'Graphical_Abstract.eps'], 'epsc')
