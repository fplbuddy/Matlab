%load('/Volumes/Samsung_T5/OldData//masternew.mat')

AR = "AR_2";
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions');
run SetUp.m
RaC = 8*pi^4;
markermin = 2;
xstart = 0.06;
width = 0.27;
height = 0.7;
dif = 0.06;
ystart = 0.17;

Prl = 1.99e-1;
Pru = 2.18e-1;
Ral = 1.5e5;
Rau = 3.6e5;


myBlue = [41 170 225]/255;
num1 = 50;
num2 = 50;

[Ra_listtot,Pr_listtot] = GetStabBoundary(Data);
Pr_listtot = [1e-6 Pr_listtot 1e6];
Ra_listtot = [1e8 Ra_listtot 1e8];

%% k1
Pr = 0.2;
PrS = PrtoPrS(Pr);
RaS_list = string(fields((Data.AR_2.OneOne152.(PrS))));
RaS_list = OrderRaS_list(RaS_list);
Is = find(RaS_list == "Ra_1e5");
Ie = find(RaS_list == "Ra_4e5");
RaS_list = RaS_list(Is:Ie);
sig_list = [];
Ra_list = [];
for i=1:length(RaS_list)
    RaS = RaS_list(i);
    Ra = RaStoRa(RaS);
    Ra_list = [Ra_list Ra];
    sigs = Data.AR_2.OneOne152.(PrS).(RaS).sigmaodd;
    [~,I] = max(real(sigs));
    add = sigs(I);
    if imag(add) < 0
        add = conj(add);
    end
    sig_list = [sig_list add];
end

Ra_list_plot1 = 1.5e5:(3.1e5-1.5e5)/(num1-1):3.1e5;
Ra_list_plot2 = 3.1e5:(3.5e5-3.1e5)/(num2-1):3.5e5;
Ra_list_plot = [Ra_list_plot1 Ra_list_plot2 3.32859e5];
Ra_list_plot = sort(Ra_list_plot);
Ra_list_plot = unique(Ra_list_plot,'stable');
y_list = zeros(1,length(Ra_list_plot)); % how far inbetween
I_list = zeros(1,length(Ra_list_plot)); % first largest thing that is smaller
sigma_list_plot = zeros(1,length(Ra_list_plot)); % first largest thing that is smaller
for i=1:length(Ra_list_plot)
    Ra = Ra_list_plot(i);
    for j=1:length(Ra_list)
        check =  Ra_list(j);
        if Ra < check
            I_list(i) = j-1;
            if isempty(Ra_list(j-1))
                y_list(i) = 0;
            else
                y_list(i) = (Ra - check)/(Ra_list(j-1) - check);
            end
            break
        end
    end
    y = y_list(i);
    sigma_list_plot(i) = y*sig_list(j-1)+(1-y)*sig_list(j);
end
figure()
plot(abs(diff(real(sigma_list_plot))));
q1 = [0.2 1e5*(3.33+3.34)/2];
%set(subplot(1,2,1), 'Position', [xstart, ystart, width, height])
for i=1:length(Ra_list_plot)
    figure('Renderer', 'painters', 'Position', [5 5 800 400])
    subplot(1,2,1), hold on
    
    ylim([-1 1])
    xlim([-0.2 1])
    %xticks([0 0.1 0.2])
    %yticks([-0.4 -0.2 0 0.2 0.4])
    ax = gca;
    ax.XAxis.FontSize = numFS;
    ax.YAxis.FontSize = numFS;
    ylabel('$\mathcal{I}(\sigma^o)$','FontSize', LabelFS);
    xlabel('$\mathcal{R}(\sigma^o)$','FontSize', LabelFS);
    plot(real(sigma_list_plot(i)), imag(sigma_list_plot(i)),'r.','MarkerSize',MarkerS+15), hold on
    if abs(imag(sigma_list_plot(i))) > 0.001
        plot(real(sigma_list_plot(i)), -imag(sigma_list_plot(i)),'r.','MarkerSize',MarkerS+15)
    end
    plot(real(sigma_list_plot),abs(imag(sigma_list_plot)),'-k')
    plot(real(sigma_list_plot),-abs(imag(sigma_list_plot)),'-k')
    
    
    plot([0 0], [-1 1], 'k--')
    %plot([-0.05 1], [0 0], 'k--')
    set(gca,'XColor',[1 1 1])
    set(gca,'YColor',[1 1 1])
    
    
    subplot(1,2,2)
    set(gca, 'Layer', 'top')
    patch(Pr_listtot,Ra_listtot,myBlue,'EdgeColor',myBlue), hold on
    ax = gca;
    ax.XAxis.FontSize = numFS;
    ax.YAxis.FontSize = numFS;
    ax.TickLength = [0, 0];
    set(gca,'XColor',[1 1 1])
    set(gca,'YColor',[1 1 1])
    xlabel('$Pr$','FontSize', LabelFS, 'Color','w')
    ylabel('$Ra/10^5$','FontSize', LabelFS, 'Color','w')
    yticks([RaC 1e4 1e5 1e6 1e7 1e8])
    plot(q1(1), q1(2), '*r', 'MarkerSize',MarkerS)
    text(q1(1)*1.006,q1(2), '$q_1$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    set(gcf, 'InvertHardCopy', 'off');
    set(gcf,'Color',[0 0 0]);
    xlim([Prl Pru])
    ylim([Ral Rau])
    %xticks([0.2 0.2175])
    yticks([2e5 3e5])
    yticklabels({'$2$' '$3$'})
    plot(0.2, Ra_list_plot(i),'r.','MarkerSize',MarkerS+15)
    if i == 1 || i == length(Ra_list_plot) % first or last one
        print(gcf,[pwd '/hopf/hopf_' num2str(i) '.png'],'-dpng','-r300');
    else
        print(gcf,[pwd '/hopf/hopf_' num2str(i) '.png'],'-dpng','-r300');
        print(gcf,[pwd '/hopf/hopf_' num2str(100+(100-i)) '.png'],'-dpng','-r300');
    end
    
    
end
