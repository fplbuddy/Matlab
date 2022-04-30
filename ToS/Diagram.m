run SetUp.m
figure('Renderer', 'painters', 'Position', [5 5 800 300])
ax = gca;
ax.Position = [0 0 1 1];
set(gca,'visible','off'); % remove axis
annotation('line', 'LineStyle', '--', 'LineWidth', 3, 'Color', 'black', 'X', [0.15 0.85], 'Y', [0.15 0.15])
annotation('line', 'LineStyle', '--', 'LineWidth', 3, 'Color', 'black', 'X', [0.15 0.85], 'Y', [0.85 0.85])
text('String', '$0$', 'Units', 'normalized','Position', [0.13 0.15] , 'HorizontalAlignment', 'right','FontSize', numFS)
text('String', '$0$', 'Units', 'normalized','Position', [0.15 0.09] , 'HorizontalAlignment', 'center','FontSize', numFS)
text('String', '$\psi = \psi_{yy} = \theta = 0$, $T = T_0 + \Delta T$', 'Units', 'normalized','Position', [0.25 0.09] , 'HorizontalAlignment', 'left','FontSize', numFS)
text('String', '$\psi = \psi_{yy} = \theta = 0$, $T = T_0$', 'Units', 'normalized','Position', [0.25 0.9] , 'HorizontalAlignment', 'left','FontSize', numFS)
text('String', '$\pi d$', 'Units', 'normalized','Position', [0.13 0.85] , 'HorizontalAlignment', 'right','FontSize', numFS)
text('String', '$2\pi L$', 'Units', 'normalized','Position', [0.85 0.09] , 'HorizontalAlignment', 'center','FontSize', numFS)
annotation('arrow', [0.05 0.1025], [0.55 0.55])
annotation('arrow', [0.05 0.05], [0.55 0.69])
text('String', '$y$', 'Units', 'normalized','Position', [0.03 0.68] , 'HorizontalAlignment', 'center','FontSize', numFS)
text('String', '$x$', 'Units', 'normalized','Position', [0.11 0.52] , 'HorizontalAlignment', 'center','FontSize', numFS)
text('String', '$\psi(x,y,t) = \psi(x+ 2\pi L,y,t)$', 'Units', 'normalized','Position', [0.20 0.35] , 'HorizontalAlignment', 'center','FontSize', numFS)
text('String', '$T(x,y,t) = T(x+ 2\pi L,y,t)$', 'Units', 'normalized','Position', [0.20 0.27] , 'HorizontalAlignment', 'center','FontSize', numFS)


