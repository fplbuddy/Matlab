fpath = '/Users/philipwinchester/Dropbox/Matlab/Low_Dim/Functions/';
addpath(fpath);

FS = 19;
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)

%% Plot the steady states
Pr_list = [10];
Ra_list = logspace(0, 4,100);
for i=1:length(Pr_list)
    figure('Renderer', 'painters', 'Position', [5 5 800 600])
    Pr = Pr_list(i);
    xp = zeros(1,length(Ra_list));
    xn = zeros(1,length(Ra_list));
    wp = zeros(1,length(Ra_list));
    wn = zeros(1,length(Ra_list));
    eigenp = zeros(1,length(Ra_list));
    eigenn = zeros(1,length(Ra_list));
    for i =1:length(Ra_list)
        Ra = Ra_list(i);
        xp(i) = xs(Ra,Pr,'p');
        xn(i) = xs(Ra,Pr,'n');
        wp(i) = ws(Ra,Pr,'p');
        wn(i) = ws(Ra,Pr,'n');
        eigenp(i) = eigen(Ra,Pr, wp(i), xp(i));
        eigenn(i) = eigen(Ra,Pr, wn(i), xn(i));
    end
    subplot(3,1,1)
    semilogx(Ra_list,wp), hold on
    plot(Ra_list,wn)
    plot([min(Ra_list) max(Ra_list)], [-(1+Pr)/2 -(1+Pr)/2], 'k--')
    ax = gca;
    set(ax, 'XTickLabel', [])
    ax.YAxis.FontSize = FS;
    ylabel('$w$ fixed points', 'FontSize',FS)
    text(2e3, -(1+Pr)/2+70, '$-($Pr$+1)/2$', 'FontSize', FS)
    %%%
    subplot(3,1,2)
    semilogx(Ra_list,xp), hold on
    plot(Ra_list,xn)
    plot([min(Ra_list) max(Ra_list)], [-1 -1], 'k--')
    ax = gca;
    ax.YAxis.FontSize = FS;
    set(ax, 'XTickLabel', [])
    ylabel('$x$ fixed points', 'FontSize',FS)
    sgtitle(['Pr $= ' num2str(Pr) '$'], 'FontSize',FS)
    %%%
    subplot(3,1,3)
    semilogx(Ra_list,real(eigenp)), hold on
    plot(Ra_list,real(eigenn)) 
    xlabel('Ra', 'FontSize',FS);
    ax = gca;
    ax.YAxis.FontSize = FS;
    ax.XAxis.FontSize = FS;
    ylabel('max($\mathcal{R}(\sigma)$)', 'FontSize',FS)
end
%% Check eigen
Pr  = 10;
n = 100;
P = [2*wp(n)+Pr Pr*Ra_list(n) 0 0 ;
    1+xp(n) 1+wp(n) 0 0 ;
    0 0 2*wp(n)+Pr Pr*Ra_list(n);
    0 0 1+xp(n) 1+wp(n)];
eig(P)
N = [2*wn(n)+Pr Pr*Ra_list(n) 0 0 ;
    1+xn(n) 1+wn(n) 0 0 ;
    0 0 2*wn(n)+Pr Pr*Ra_list(n);
    0 0 1+xn(n) 1+wn(n)];
eig(N)
