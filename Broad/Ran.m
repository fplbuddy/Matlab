Q_list = [0 10 20];
k_list = 1:0.01:4;
FS = 20;
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)

figure('Renderer', 'painters', 'Position', [5 5 600 200])
for i=1:length(Q_list)
    Q = Q_list(i);
    beta2 = pi^2 + k_list.^2;
    Ra_list = (beta2.^3 + Q*pi^2*beta2)./k_list.^2;
    plot(beta2,Ra_list,'DisplayName', num2str(Q)), hold on 
end
xlim([min(beta2) 22])
ylim([500 3000])
lgnd = legend('Location', 'Bestoutside', 'FontSize', FS); title(lgnd,'$Q$', 'FontSize', FS)
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
xlabel('$\alpha$', 'FontSize', FS)
ylabel('$Ra^e$', 'FontSize', FS)