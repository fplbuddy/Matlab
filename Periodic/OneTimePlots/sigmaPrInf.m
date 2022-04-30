run /Users/philipwinchester/Dropbox/Matlab/Periodic/Plot/SetUp.m
Ra = 1e7;
Rhnu = 2e6;
nu = 1;
kappa = (2*pi)^3/Ra;
mu = Rhnu/(2*pi)^4;
kx_list = 0:10;
sigma = zeros(length(kx_list), 1);
for i=1:length(kx_list)
   kx =  kx_list(i);
   sigma(i) = kx^2/(2*pi*(nu*kx^4+mu)) - kappa*kx^2; 
end
figure('Renderer', 'painters', 'Position', [5 5 600 250])
plot(kx_list,sigma,'-o', 'LineWidth',1)
xlabel('$k_x$','FontSize',labelFS);
ylabel('$\sigma$','FontSize',labelFS);
ax = gca;
ax.FontSize = numFS;
saveas(gcf,[figpath 'sigmaPrInf'], 'epsc')