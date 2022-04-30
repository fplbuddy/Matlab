% Treads = 1;
% maxNumCompThreads(Treads);
% maxNumCompThreads(Treads);
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m % !!! Where we have the functions i guess
path = '/Volumes/Samsung_T5/Coherance/';
%addpath('/Users/philipwinchester/Dropbox/Matlab/JFM/Functions/github_repo')
nx = 256; ny = 256; nmpi = 8; res = ['N_' num2str(nx) 'x' num2str(ny)];
Pr = 1e1; Ra = 8e6; Gy = 0.25;
dt = 5e-3;
type = 'Shearing'; ICS = ['IC_' type(1)];
ext = 'rstep_2e0_vid';
jump = 1;
L = 150;
numFS = 18;
titFS = 20;

PrS = normaltoS(Pr,'Pr',1); RaS = normaltoS(Ra,'Ra',1); GyS = normaltoS(Gy,'Gy',1); dtS = normaltoS(dt,'dt',1);  % !!!
PrT = RatoRaT(Pr); RaT = RatoRaT(Ra); LyT = RatoRaT(Gy);
fields1 = ["ps", "theta2", "ph", "thetav"];
fields2 = ["psrand", "theta2rand", "ph", "thetav"];
path = [path ICS '/' res '/' PrS '/' RaS '/' GyS '/' dtS '/' ext '/Fields/'];
nums = importdata([path 'field_times.txt']);
nums = nums(:,1);
DelayTime = jump*L/length(nums);
filename = [RaS PrS GyS '.gif'];
h = figure('Renderer', 'painters', 'Position', [10 10 800 400]);
axis tight manual % this ensures that getframe() returns a consistent size

for i=2:jump:length(nums)
    i
    num = nums(i);
    if rem(i,2) % if odd, then we want rand ones
        fields =  fields2;
    else % 
        fields =  fields1;
    end
    Data = GetFields(nx,ny,path,num,nmpi,fields,4);
    %% Plot on figure 
    % ps
    subplot(2,2,1)
    if rem(i,2) % if even
        ff = Data.psrand;
    else
        ff = Data.ps;
    end
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
    %colorbar()
    
    % theta
    subplot(2,2,2)
    if rem(i,2) % if even
        ff = Data.theta2rand;
    else
        ff = Data.theta2;
    end
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
    %colorbar()
    
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
    
    
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);

% Think this makes it nice, but is much slower
     %f = export_fig('-nocrop',['-r','300']);
     %[imind,cm] = rgb2ind(f,256,'dither'); 
    drawnow
    % Write to the GIF File
    if i == 2
        imwrite(imind,cm,filename,'gif', 'DelayTime',DelayTime, 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','DelayTime',DelayTime,'WriteMode','append');
    end
    
    
end

