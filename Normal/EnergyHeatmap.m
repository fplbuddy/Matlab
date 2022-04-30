TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)


x = logspace(4, 9,1000);
y = logspace(0,3,1000);

[X,Y] = meshgrid(x,y);
 
ExE = (E(Y,X) - Ey(Y,X))./E(Y,X);
ExE(ExE<0.5) = 0.5;

figure
surf(X,Y,ExE)
shading interp
colorbar()
set(gca,'XScale','log')
set(gca,'yScale','log')
xlabel('$Ra$', 'FontSize',13)
ylabel('$Pr$', 'FontSize',13)
title('$\frac{E_x}{E}$', 'FontSize',20)
view(2)
ylim([3,300])
%% Functions
function E = E(Pr,Ra)
     E = 2.32*Pr.^(-2.92)*Ra.^(log(0.981*Pr.^(0.109)));
end
function Ey = Ey(Pr,Ra)
    Ey = 38.3*Pr.^(-0.726)*Ra.^(-0.624*Pr.^(-0.114));
end