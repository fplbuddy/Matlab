addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions');
run SetUp.m
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
% load(dpath);
% dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
% load(dpath);

% [Ra_list,Pr_list] = GetStabBoundary(Data,PrZeroData);
G = 2;
RaC = RaCfunc(G);
%% Make plot 
hej=figure('Renderer', 'painters', 'Position', [5 5 600 500]);
set(gca, 'Layer', 'top')
Pr_list = [1e-6 Pr_list 1e6];
Ra_list = [1e8 Ra_list 1e8];
I = find(Pr_list == 0.0181);
Pr_list(I) = [];
Ra_list(I) = [];
I = find(Pr_list == 0.0186);
Pr_list(I) = [];
Ra_list(I) = [];
patch(Pr_list,Ra_list,'blue','EdgeColor','blue'), hold on
%plot(Pr_list,Ra_list,'r--', 'LineWidth',2)
patch([1e-6 1e6 1e6 1e-6],[400 400 RaC RaC],'red','EdgeColor','red','FaceAlpha', 0.3,'EdgeAlpha', 0.3)
set(gca,'yscale', 'log')
set(gca,'xscale', 'log')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([1e-2 1e2])
ylim([400 1e8])
% xlabel('$Pr$','FontSize', LabelFS)
% ylabel('$Ra$','FontSize', LabelFS)
%text(1,2.5e2, '$Pr$', 'FontSize',LabelFS, 'Color','k', 'HorizontalAlignment', 'center')
% text(1,2.5e5, '$S$', 'FontSize',LabelFS, 'Color','k', 'HorizontalAlignment', 'center')
% text(1e-1,1e7, '$US$', 'FontSize',LabelFS, 'Color','white', 'HorizontalAlignment', 'center')
yticks([])
%yticklabels({'$Ra_c$' '$10^4$' '$10^5$' '$10^6$' '$10^7$' '$10^8$'})
xticks([])

% Make Rac
plot([1e-6 1e6], [RaC RaC], 'k--', 'LineWidth',1)
%text(4e-1 ,RaC, '$Ra_c$', 'FontSize',LabelFS, 'Color','k', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')


% maka red points
p1 = [0.0548 378+RaC];
p2 = [0.0186 3200+RaC];
p3 = [0.2175 1e5*(2.42+2.74)/2];
p4 = [0.2 1e5*(3.33+3.34)/2];
p5 = [5 4e6]; % Not accurate yet
p6 = [8.61 1e6*(1.24+1.25)/2];
p7 = [6.17 1e4*(6.02+4.96)/2];
p8 = [8.6 3.26e4]; % Not accurate yet

% plot([p1(1) p2(1) p5(1) p6(1) p7(1) p8(1)], [p1(2) p2(2)  p5(2) p6(2) p7(2) p8(2)], '*r', 'MarkerSize',MarkerS)
% plot([p3(1) p4(1)], [p3(2) p4(2)], '*r', 'MarkerSize',MarkerS)
left = 0.7;
right = 1/left;
down = 0.6;
up = 1/down;
% text(p1(1)*right,p1(2), '$p_1$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center')
% text(p2(1),p2(2)*down, '$p_2$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
% text(p5(1),p5(2)*down, '$q_2$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
% text(p6(1)*right,p6(2), '$q_3$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
% text(p7(1)*left,p7(2), '$p_4$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
% text(p8(1),p8(2)*down, '$p_5$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
% arrow([4e5 1e7],[7e5 2.45e7],5)
% text(4e5*0.9,1e7*0.9, '$q_4$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
% text(p4(1)/right,p4(2), '$q_1$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
% text(p3(1)*right,p3(2), '$p_3$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')

% arrow and text
% I = 130;
% x1 = 0.1;
% y1 = 6e3;
% arrow([x1 y1],[Pr_list(I) Ra_list(I)], 'length', 10,'EdgeColor','r','FaceColor','r')
% text(x1,y1,"Stability Boundary",'FontSize',TitleFS,'Color', 'r')
%
%
%% make final plot
set(hej,'Units','Inches');
pos = get(hej,'Position');
set(hej,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(gcf,[figpath 'Graphical_Abstract.jpg'], '-djpeg', '-r300')
%saveas(gcf,[figpath 'Graphical_Abstract.eps'], 'epsc')
