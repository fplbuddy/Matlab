TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
ms = 20;
FS = 20;
Pr = 1;
zeta = 0.5;
q = zeta*(1+Pr)/(Pr*(1-zeta))+1;
r_list = [3 3.2 3.4 3.6 3.8 4];
root_list = [];
figure('Renderer', 'painters', 'Position', [5 5 600 300])
cmap = colormap(winter(length(r_list)));
subplot(1,2,2)
for i=1:length(r_list)
    r = r_list(i);
    two = 1+Pr+zeta;
    one = Pr*(1-r+zeta*q)+zeta*(1+Pr);
    zero = Pr*zeta*(1+q-r);
    p = [1 two one zero];
    root = roots(p);
    %root_list = [root_list root];
    plot(real(root), imag(root),'*','Color',cmap(i,:),'DisplayName', num2str(r),'MarkerSize',ms), hold on  
end
lgnd = legend('Location', 'Bestoutside', 'FontSize', FS); title(lgnd,'$r$', 'FontSize', FS)
xlim([-0.2 0.2])
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
xlabel('$Real(\hat s)$', 'FontSize', FS)
text(0.1, 0.42, '(b)', 'FontSize', FS)



q = zeta*(1+Pr)/(Pr*(1-zeta))-1;
r_list = [1.3 1.5 1.7 1.9 2.1 2.3];
subplot(1,2,1)
for i=1:length(r_list)
    r = r_list(i);
    two = 1+Pr+zeta;
    one = Pr*(1-r+zeta*q)+zeta*(1+Pr);
    zero = Pr*zeta*(1+q-r);
    p = [1 two one zero];
    root = roots(p);
    plot(real(root), imag(root),'*','Color',cmap(i,:),'DisplayName', num2str(r),'MarkerSize',ms), hold on  
end
lgnd = legend('Location', 'Bestoutside', 'FontSize', FS); title(lgnd,'$r$', 'FontSize', FS)
xlim([-0.4 0.3])
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
xlabel('$Real(\hat s)$', 'FontSize', FS)
ylabel('$Imag(\hat s)$', 'FontSize', FS)
text(0.14, 0.34, '(a)', 'FontSize', FS)
