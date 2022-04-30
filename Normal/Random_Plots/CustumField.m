Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m % !!! Where we have the functions i guess
Pr = 0.6; Ra = 2e9;
RaS = normaltoS(Ra,'Ra',1); PrS = 'Pr_0_6';
PrT = RatoRaT(Pr); RaT = RatoRaT(Ra);
path = '/Volumes/Samsung_T5/AR_2/1024x512/';
nx = 1024; ny = 512; nmpi = 16;

fields = ["ps", "theta"];
path = [path PrS '/' RaS '/Fields/'];
num = 115;
h = figure('Renderer', 'painters', 'Position', [10 10 700 250]);




Data = GetFields(nx,ny,path,num,nmpi,fields,3);
%% Plot on figure
% ps
subplot(1,2,1)
ff = Data.ps;
pcolor(ff);
shading interp
colormap('jet')
caxis([min(min(abs(ff))), max(max(abs(ff)))])
%xlabel('$x$', 'FontSize', numFS)
%ylabel('$y$', 'FontSize', numFS)
xticks([1 nx])
%xticklabels({'$0$' '$2\pi$'})
xticklabels({'' ''})
yticks([1 ny])
%yticklabels({'$0$' '$\pi$'})
yticklabels({'' ''})
ax = gca;
ax.FontSize = numFS;
colorbar()
title('$\psi$','FontSize', labelFS )

% theta
subplot(1,2,2)
ff = Data.theta;
ff = thetatoTT(ff);
pcolor(ff);
shading interp
colormap('jet')
caxis([min(min(abs(ff))), max(max(abs(ff)))])
%xlabel('$x$', 'FontSize', numFS)Data
%ylabel('$y$', 'FontSize', numFS)
xticks([1 nx])
%xticklabels({'$0$' '$2\pi$'})
xticklabels({'' ''})
yticks([1 ny])
%yticklabels({'$0$' '$\pi$'})
yticklabels({'' ''})
ax = gca;
ax.FontSize = numFS;
title('$T$','FontSize',  labelFS )
colorbar()
sgtitle(['$Pr = ' PrT '\,, Ra = ' RaT '$'],'FontSize',  labelFS)

%% save
set(gcf,'renderer','opengl')
saveas(gcf,[figpath 'Field_' RaS '_' PrS '_nonburst'], 'epsc')


