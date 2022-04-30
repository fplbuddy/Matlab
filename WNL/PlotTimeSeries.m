figsave = '/Users/philipwinchester/Desktop/Figs/';
FS = 20;
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
r_list = [100 200 238 239 500 800 2000 3000];
G = 2;
GS = GtoGS(G);
eps = 0.1;
epsS = epstoepsS(eps);
for i=1:length(r_list)
    r = r_list(i);
    rS = rtorS(r);
    A = WNLData.(GS).(epsS).(rS).A;
    phi = WNLData.(GS).(epsS).(rS).phi;
    t = WNLData.(GS).(epsS).(rS).t;
    figure('Renderer', 'painters', 'Position', [5 5 540 200])
    plot(t,abs(A),'DisplayName', '$A$'), hold on
    plot(t,phi,'DisplayName', '$\phi$')
    ax = gca;
    ax.XAxis.FontSize = FS;
    ax.YAxis.FontSize = FS;
    xlabel('$t$', 'FontSize', FS)
    lgnd = legend('Location', 'Bestoutside', 'FontSize', FS);
    title(['$\Gamma = 2, r= ' num2str(r) ', \epsilon = 0.1$'],'FontSize', FS)
    if r == 100
       xlim([0 1])         
    end
    saveas(gcf,[figsave num2str(r) '.eps'], 'epsc')
end