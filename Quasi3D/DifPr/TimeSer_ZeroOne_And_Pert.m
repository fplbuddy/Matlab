run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Gy = 0.09; Pr1 = 1; Pr2 = 10; Ra = 2e9;
GyS = normaltoS(Gy,'Gy',1); Pr1S = normaltoS(Pr1,'Pr1',1); Pr2S = normaltoS(Pr2,'Pr2',1); RaS = normaltoS(Ra,'Ra',1);
Nx = 1024; Ny = 512; res = ['N_' num2str(Nx) 'x' num2str(Ny)];
NS = ['N_' num2str(Nx) 'x' num2str(Ny)];
type = 'Shearing';
IC = ['IC_' type(1)];
path = ['/Volumes/Samsung_T5/Quasi_difPr/' IC '/' res '/' Pr1S '/' Pr2S '/' RaS '/' GyS  ];
kenergy2 = importdata([path '/Checks/kenergy2.txt']);
kenergy = importdata([path '/Checks/kenergy.txt']);
%%
figure('Renderer', 'painters', 'Position', [5 5 540 540])
subplot(2,1,1)
plot(kenergy(:,1), kenergy(:,5))
ylabel('$\widehat \psi_{0,1}$','FontSize',labelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;

subplot(2,1,2)
semilogy(kenergy2(:,1), kenergy2(:,2))
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$<(\nabla\psi_{\perp})^2>$','FontSize',labelFS)
xlabel('$t\,  (s)$','FontSize',labelFS)
GyT = RatoRaT(Gy); RaT = RatoRaT(Ra); Pr1T = RatoRaT(Pr1); Pr2T = RatoRaT(Pr2);
sgtitle(['$\Gamma_y=' GyT ',\, Ra = ' RaT ',\, Pr_{2D} = ' Pr1T ',\, Pr_{\perp}=' Pr2T '$'], 'FontSize',labelFS)

saveas(gcf,[figpath GyS '_' RaS  '_' Pr1S '_' Pr2S '_' ], 'epsc')