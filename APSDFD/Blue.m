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
left = 0.5;
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





%% storing eigenvectors, and make sure they are right phase to go
width = 0.12;
height = 0.12;
L = 10;
num = 200;
Pr_list = [0.2 0.2 8.58 100 7e5];
Ra_list = [3.32e5 3.35e5 1.29e6 1.06e5 2.54e7];
ZoNZ_list = ["Z" "Z" "Z" "Z" "NZ"];
split_list = [0 0 0 0 1];
N_list = [152 152 256 152 400];
x1_list = [0.3 0.3 0.6 0.6 0.78 ];
y1_list = [0.45 0.65 0.85 0.65 0.85];
x_arrow = [1e-2 1e-2 1e2 1e2 1e5];
y_arrow = [1e5 3e6 1e8 3e6 1e8];
for i=1:length(split_list)
    Ra = Ra_list(i); Pr = Pr_list(i); ZoNZ = ZoNZ_list(i); split = split_list(i); N = N_list(i);
    PrS = PrtoPrS(Pr);
    RaS = RatoRaS(Ra);
    type = ['OneOne' num2str(N)];
    div = N/300;
    if ZoNZ == "Z"
        if split
            EigV = Data.AR_2.(type).(PrS).(RaS).EigvZ;
        else
            EigV = Data.AR_2.(type).(PrS).(RaS).Eigv;
        end
    else
        EigV = Data.AR_2.(type).(PrS).(RaS).EigvNZ;
    end
    n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
    m = 1:N; m = repelem(m, N/2);
    [~,~,n,~] = GetRemGeneral(n,m,N);
    I = find(n<0);
    EigV([I I+length(n)]) = [];
    [~,I] = max(abs(EigV)); % finding largest mode
    if ZoNZ == "Z"
        phase = -angle(EigV(I));
    else
        phase = -angle(EigV(I))+pi/2;
    end
    EigV = EigV*exp(1i*phase); % making sure largest mode is at max
    savepos = ['num_' num2str(i)];
    Vectors.(savepos).vec = EigV;
    [Eigenfuntionpsi, ~] = GetEigVPlot(EigV,N,0,G,ZoNZ,0,div);
    Vectors.(savepos).m = max(max(abs(Eigenfuntionpsi)));
end

%% making inserts
phase_list = 0:2*pi/num:2*pi;
phase_list(end) = []; % dont actually need the last one
filename = [convertStringsToChars(RaS) convertStringsToChars(PrS) convertStringsToChars(ZoNZ) '.gif'];
DelayTime = L/length(phase_list);
for i=1:length(phase_list)
    h = figure('Renderer', 'painters', 'Position', [5 5 800 400]);
    %axis tight manual % this ensures that getframe() returns a consistent size
%     if i ==  1
%         Start = 1;
%     else
%         Start = 0;
%     end
    
     disp(i)
    
    set(gca, 'Layer', 'top')
    patch(Pr_listtot,Ra_listtot,myBlue,'EdgeColor',myBlue), hold on
    patch([1e-6 1e6 1e6 1e-6],[400 400 RaC RaC],'red','EdgeColor','red','FaceAlpha', 0.3,'EdgeAlpha', 0.3)
    set(gca,'yscale', 'log')
    set(gca,'xscale', 'log')
    ax = gca;
    ax.XAxis.FontSize = numFS*1.3;
    ax.YAxis.FontSize = numFS*1.3;
    ax.TickLength = [0, 0];
    set(gca,'XColor',[1 1 1])
    set(gca,'YColor',[1 1 1])
    xlim([1e-6 1e6])
    ylim([400 1e8])
    xlabel('$Pr$','FontSize', LabelFS*1.3, 'Color','w')
    ylabel('$Ra$','FontSize', LabelFS*1.3, 'Color','w')
    yticks([RaC 1e4 1e5 1e6 1e7 1e8])
    yticklabels({'$Ra_c$' '$10^4$' '$10^5$' '$10^6$' '$10^7$' '$10^8$'})
    xticks([1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1 10 1e2 1e3 1e4 1e5 1e6])


    plot([1e-6 1e6], [RaC RaC], 'k--', 'LineWidth',1.5)




    for j=1:length(Pr_list)
        if j == 4
            inst = 3;
        else
            inst = j;
        end
        arrow([x_arrow(j) y_arrow(j)],[Pr_list(inst) Ra_list(inst)],5, 'color','r')
    end
    
    plot([q1(1) q2(1) q3(1) q4(1)], [q1(2) q2(2) q3(2) q4(2)], '*r', 'MarkerSize',MarkerS)
    text(q1(1)*right,q1(2), '$q_1$', 'FontSize',LabelFS*1.2, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    text(q2(1),q2(2)*down, '$q_2$', 'FontSize',LabelFS*1.2, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    text(q3(1)*left,q3(2), '$q_3$', 'FontSize',LabelFS*1.2, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    text(q4(1),q4(2)*down, '$q_4$', 'FontSize',LabelFS*1.2, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')


    
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

    % now looping round the plot
    for j=1:length(Pr_list)
        Ra = Ra_list(j); Pr = Pr_list(j); ZoNZ = ZoNZ_list(j); split = split_list(j); N = N_list(j);
        PrS = PrtoPrS(Pr);
        RaS = RatoRaS(Ra);
        type = ['OneOne' num2str(N)];
        div = N/300;
        savepos = ['num_' num2str(j)];
        EigV = Vectors.(savepos).vec;
        m = Vectors.(savepos).m;
        if j == 1
            phase = 0;
        else
            phase = phase_list(i);
        end
        
        [Eigenfuntionpsi, ~] = GetEigVPlot(EigV,N,phase,G,ZoNZ,0,div);
        
        x1 = x1_list(j);
        y1 = y1_list(j);
        axes('Position',[x1 y1 width height])
        box on
        pcolor(Eigenfuntionpsi);
        shading interp
        colormap('jet')
        caxis([-m m])
        xticks([])
        yticks([])
    end
    set(gcf, 'InvertHardCopy', 'off'); 
    set(gcf,'Color',[0 0 0]);
    print(gcf,['/Users/philipwinchester/Desktop/Blue/blue_' num2str(i) '.png'],'-dpng','-r300');
%      f = export_fig('-nocrop',['-r','300']);
%     [imind,cm] = rgb2ind(f,256,'dither'); 
%     drawnow
    % Write to the GIF File
%     if Start
%         imwrite(imind,cm,filename,'gif', 'DelayTime',DelayTime, 'Loopcount',inf);
%     else
%         imwrite(imind,cm,filename,'gif','DelayTime',DelayTime,'WriteMode','append');
%     end
    close all
end


%
%
%% make final plot


%saveas(gcf,[figpath 'Graphical_Abstract.eps'], 'epsc')
