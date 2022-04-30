G_list = 0.3:0.02:0.4;
FS = 20;
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)

figure('Renderer', 'painters', 'Position', [5 5 700 300])
for i=1:length(G_list)
    G = G_list(i); G = round(G,2,'significant');
    GS = GtoGS(G);
    As = WNLData.(GS).As;
    Fs = WNLData.(GS).Fs;
    % trim to A_*
    Astar = WNLData.(GS).calcs.Astar;
    Fs(abs(As) > Astar) = [];
    As(abs(As) > Astar) = [];
    %
    sigmas = WNLData.(GS).sigmas;
    subplot(5,1,[1,2,3])
    plot(As,Fs, 'DisplayName', num2str(G)), hold on
    subplot(5,1,[4,5])
    % plot gradients here
    dx = mean(diff(As));
    deriv = diff(Fs)/dx;
    plot(As(1:length(deriv)),deriv, 'DisplayName', num2str(G)), hold on
    %plot(As,sigmas, '-o'), hold on
end
subplot(5,1,[1,2,3])
lgnd = legend('Location', 'northoutside', 'FontSize', FS); title(lgnd,'$\Gamma$', 'FontSize', FS)
lgnd.NumColumns = 6;
ax = gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;
ylabel('$\lambda$','FontSize',FS)
set(gca,'xtick',[])
set(gca,'xticklabel',[])
subplot(5,1,[4,5])
ax = gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;
xlabel('$A$','FontSize',FS)
ylabel('$\frac{d\lambda}{dA}$','FontSize',FS)