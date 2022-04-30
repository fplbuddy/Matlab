run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
n = 1024*2;
nu = 1e-18; kappa = 1e-18;
nuS = normaltoS(nu, 'nu',1); kappaS = normaltoS(kappa, 'kappa',1);
nuT = RatoRaT(nu); kappaT = RatoRaT(kappa); 
o1 = 4; o2 = 1;
f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
path = ['/Volumes/Samsung_T5/Periodic/n_' num2str(n) '/' o1S '/' o2S '/f_0e1/' hnuS '/' nuS '/' kappaS '/Fields/'];
num = 5;
nmpi = 16*4;
fields = ["ps", "theta" "ww"];
len = 3;

[Data,time] = GetFields(n,n,path,num,nmpi,fields,len);
figure('Renderer', 'painters', 'Position', [5 5 1000 250])
subplot(1,3,1)
ff = Data.ps;
pcolor(ff);
set(gcf,'renderer','opengl') % needed to save for some reason
shading flat
colormap('jet')
caxis([-max(max(abs(ff))), max(max(abs(ff)))])
%xlabel('$x$', 'FontSize', numFS)
%ylabel('$y$', 'FontSize', numFS)
xticks([1 n])
xticklabels({'$0$' '$2\pi$'})
yticks([1 n])
yticklabels({'$0$' '$2\pi$'})
ax = gca;
ax.FontSize = numFS;
title('$\psi$')
% title(['$\theta,\, Ra = ' RaT ',\, Pr = '  PrT '$'],'FontSize', labelFS )
% saveas(gcf,[figpath 'PrinfPeriodicTheta'], 'epsc')
subplot(1,3,2)
ff = Data.ww;
pcolor(ff);
set(gcf,'renderer','opengl') % needed to save for some reason
shading flat
colormap('jet')
caxis([-max(max(abs(ff))), max(max(abs(ff)))])
%xlabel('$x$', 'FontSize', numFS)
%ylabel('$y$', 'FontSize', numFS)
xticks([1 n])
xticklabels({'$0$' '$2\pi$'})
yticks([1 n])
yticklabels({'$0$' '$2\pi$'})
ax = gca;
ax.FontSize = numFS;
title('Vorticity')


subplot(1,3,3)
ff = Data.theta;
pcolor(ff);
set(gcf,'renderer','opengl') % needed to save for some reason
shading flat
colormap('jet')
caxis([-max(max(abs(ff))), max(max(abs(ff)))])
%xlabel('$x$', 'FontSize', numFS)
%ylabel('$y$', 'FontSize', numFS)
xticks([1 n])
xticklabels({'$0$' '$2\pi$'})
yticks([1 n])
yticklabels({'$0$' '$2\pi$'})
ax = gca;
ax.FontSize = numFS;
title('$\theta$')
sgtitle(['$\nu = ' nuT ',\, \kappa = ' kappaT ',\, t=' num2str(round(time,0)) ',\, m = ' num2str(o2) '$'])
%saveas(gcf,[figpath 'Fields_' nuS '_' kappaS '_m_' num2str(o2) '_num_' num2str(num)], 'epsc')