Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m % !!! Where we have the functions i guess
path = '/Volumes/Samsung_T5/Quasi3D/IC_N/N_1024x512/';
%addpath('/Users/philipwinchester/Dropbox/Matlab/JFM/Functions/github_repo')
nx = 1024; ny = 512; nmpi = 16;
Pr = Inf; Ra = 2e9; Ly = 0.08;
jump = 1;
L = 30;
numFS = 18;
titFS = 20;

PrS = normaltoS(Pr,'Pr',1); RaS = normaltoS(Ra,'Ra',1); LyS = normaltoS(Ly,'Ly',1); % !!!
PrT = RatoRaT(Pr); RaT = RatoRaT(Ra); LyT = RatoRaT(Ly);
fields = ["ps", "theta2", "ph", "thetav"];
path = [path PrS '/' RaS '/' LyS '/Fields/'];
nums = importdata([path 'field_times.txt']);
nums = nums(:,1);
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
DelayTime = jump*L/length(nums);
filename = [RaS PrS LyS '.gif'];
h = figure('Renderer', 'painters', 'Position', [10 10 800 400]);
axis tight manual % this ensures that getframe() returns a consistent size

for i=2:jump:length(nums)
    i
    num = nums(i);
    Data = GetFields(nx,ny,path,num,nmpi,fields,4);
    %% Plot on figure 
    % ps
    subplot(2,2,1)
    ff = Data.ps;
    pcolor(ff);
    shading interp
    colormap('jet')
    caxis([-max(max(abs(ff))), max(max(abs(ff)))])
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
    title('$\psi$','FontSize', titFS )
    
    % theta
    subplot(2,2,2)
    ff = Data.theta2;
    pcolor(ff);
    shading interp
    colormap('jet')
    caxis([-max(max(abs(ff))), max(max(abs(ff)))])
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
    title('$\theta$','FontSize', titFS )
    
    % ph
    subplot(2,2,3)
    ff = Data.ph;
    pcolor(ff);
    shading interp
    colormap('jet')
    caxis([-max(max(abs(ff))), max(max(abs(ff)))])
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
    title('$\psi_{\perp}$','FontSize', titFS )
    
     % thetav
    subplot(2,2,4)
    ff = Data.thetav;
    pcolor(ff);
    shading interp
    colormap('jet')
    caxis([-max(max(abs(ff))), max(max(abs(ff)))])
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
    title('$\theta_{\perp}$','FontSize', titFS )
    sgtitle(['$Pr = ' PrT '\,, Ra = ' RaT '\,, \Gamma_y = ' LyT  '$'],'FontSize', titFS)
    
    
    %frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);

% Think this makes it nice, but is much slower
     %f = export_fig('-nocrop',['-r','300']);
     %[imind,cm] = rgb2ind(f,256,'dither'); 
    drawnow
    % Write to the GIF File
    if i == 1
        imwrite(imind,cm,filename,'gif', 'DelayTime',DelayTime, 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','DelayTime',DelayTime,'WriteMode','append');
    end
    
    
end

