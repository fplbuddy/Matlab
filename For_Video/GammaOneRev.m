path = '/Volumes/Samsung_T5/Video/Revs/Pr_30/Ra_9e5';
home = '/Users/philipwinchester/Dropbox/Matlab/Normal';
Functions = [home '/Functions'];
addpath(Functions);
pathF = [path '/Fields/'];
kpsmodes1 = importdata([path '/Checks/kpsmodes1.txt']);
signal = kpsmodes1(:,2)*2;
t = kpsmodes1(:,1);
L = 20;
nx = 128;
ny = 128;
nmpi = 8;
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
numFS = 18;
%% calcuating some stuff
Ra = 9e5;
Pr = 30;
kappa = sqrt((pi)^3/(Ra*Pr));
kenergy = importdata([path '/Checks/kenergy.txt']);
te = kenergy(:,1);
Ex = kenergy(:,6);
Ey = kenergy(:,5);
urms = 2*Ex+2*Ey;
urms = MyMeanEasy(urms,t); urms = urms^(1/2);

%% non-dim
signal = signal/(pi*urms);
t = t/(pi/urms);
t = t - t(1); % If we have not started at t = 0.

%% Getting field times
field_times = importdata([pathF 'field_times.txt']);
Times_list = field_times(:,2);
Times_list = Times_list - Times_list(1); % If we have not started at t = 0.
%% Picking prints we want
PTimes = [4650:4800 5325:5475]; %1:700;
Pmax = max(PTimes);
Pmin = min(PTimes);
%% Making Video
h = figure('Renderer', 'painters', 'Position', [5 5 750 300]);
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'GammaOne.gif';
DelayTime = L/length(PTimes);
set(0,'DefaultFigureVisible','off')
tic
for P=PTimes % Looping round times
    if P == PTimes(1)
        Start = 1;
    elseif P == PTimes(2)
        Start = 0;
    end
    disp(P)
    subplot(1,2,1)
    % plot green bit
    plot(t(Pmin:P), signal(Pmin:P), 'Color', [0 0.5 0]), hold on
    % plot shaded bit
    plt = plot(t(P:Pmax), signal(P:Pmax), 'Color', [0 0.5 0]); hold off
    plt.Color(4) = 0.3;
    xlim([t(Pmin) t(Pmax)])
    ax = gca;
    ax.FontSize = numFS;
    xlabel('$t/(\pi d/u_{rms})$', 'FontSize', numFS)
    ylabel('$\widehat \psi_{0,1}/(\pi d u_{rms})$', 'FontSize', numFS)
    %
    %
    subplot(1,2,2)
    Time = Times_list(P)/(pi/urms); % Time of plot
    % Making sure num is right format
    P = num2str(P);
    while length(P) < 3
        P = ['0' P];
    end
    %toc %%%%%%%%%%%%%%%%%%%%%%
    files = dir([pathF,'hd2DTT','.*.',P,'.dat']);
    ff = zeros(nx*ny/nmpi,nmpi);
    for i=1:nmpi % Looping round mpi
        fid = fopen([pathF,files(i).name],'r');
        fread(fid,1,'real*4');
        ff(:,i) = fread(fid,inf,'real*8');
        fclose(fid);
    end
    %toc %%%%%%%%%%%%%%%%%%%%
    ff = reshape(ff,nx,ny);
    %figure
    pcolor(ff');
    shading flat
    colormap('jet')
    colorbar
    caxis([0 1])
    xlabel('$x/(\pi d)$', 'FontSize', numFS)
    ylabel('$y/(\pi d)$', 'FontSize', numFS)
    xticks([1 nx])
    xticklabels({'$0$' '$\Gamma = 1$'})
    yticks([1 ny])
    yticklabels({'$0$' '$1$'})
    ax = gca;
    ax.FontSize = numFS;
    sgtitle({['Pr $=30, $ Ra $= 9 \times 10^5$']; ['$t = ' num2str(Time, ceil(log10(Time))) '$']}, 'FontSize', numFS + 4)
    text(nx/2, ny+10,'$T/\Delta T$', 'HorizontalAlignment', 'center', 'FontSize', numFS)
    %toc %%%%%%%%%%%%%%%
    
    
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    drawnow
    % Write to the GIF File
    if Start
        imwrite(imind,cm,filename,'gif', 'DelayTime',DelayTime, 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','DelayTime',DelayTime,'WriteMode','append');
    end
end
% set(0,'DefaultFigureVisible','on')
close all
clearvars -except AllData

