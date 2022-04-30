run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Pr = 0; PrS = normaltoS(Pr,'Pr',1);PrT = ' \infty'; %PrT = RatoRaT(Pr); %PrT = ' \infty';
Ra = 1e7; RaS = normaltoS(Ra,'Ra',1); RaT = RatoRaT(Ra);
nx = 1024;
ny = 1024;
%path = ['/Volumes/Samsung_T5/Periodic/n_512/o1_1e0/o2_1e0/f_0e1/hnu_1e0/' PrS '/' RaS '/Fields/'];
path = '/Volumes/Samsung_T5/Periodic/n_1024/o1_1e0/o2_0e1/f_0e1/hnu_1e0/nu_5e_3/kappa_5e_5/Fields/';
num = 7;
nmpi = 16;
fields = ["ps", "theta" "ww"];
len = 3;

[Data,time] = GetFields(nx,ny,path,num,nmpi,fields,len);
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
xticks([1 nx])
xticklabels({'$0$' '$2\pi$'})
yticks([1 ny])
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
xticks([1 nx])
xticklabels({'$0$' '$2\pi$'})
yticks([1 ny])
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
xticks([1 nx])
xticklabels({'$0$' '$2\pi$'})
yticks([1 ny])
yticklabels({'$0$' '$2\pi$'})
ax = gca;
ax.FontSize = numFS;
title('$\theta$')