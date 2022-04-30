Q_list = logspace(0, 5, 1000);
alpha_list = [];
Ra_list = [];
FS = 20;
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)

for i=1:length(Q_list)
   Q =  Q_list(i);
   p = [4 -6*pi^2 0 -2*Q*pi^4];
   alpha = roots(p);
   alpha = alpha(1);
   alpha_list = [alpha_list alpha];
   Ra = (alpha^3+Q*pi^2*alpha)/(alpha - pi^2);
   Ra_list = [Ra_list Ra];
end
alpha_list_comp = (Q_list*pi^4/2).^(1/3);
Ra_list_comp = Q_list*pi^2;



figure('Renderer', 'painters', 'Position', [5 5 600 300])
subplot(1,2,1)
loglog(Q_list, alpha_list), hold on
loglog(Q_list, alpha_list_comp,'k--')
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
xlabel('$Q$', 'FontSize', FS)
ylabel('$\alpha_c$', 'FontSize', FS)
text(1e1,5, '$\alpha_c = (\frac{\pi^4Q}{2})^{1/3}$', 'FontSize', FS)

subplot(1,2,2)
loglog(Q_list, Ra_list), hold on
loglog(Q_list, Ra_list_comp,'k--')
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
xlabel('$Q$', 'FontSize', FS)
ylabel('$Ra^e_c$', 'FontSize', FS)
text(1e1,2.5, '$Ra^e_c = \pi^2Q$', 'FontSize', FS)
