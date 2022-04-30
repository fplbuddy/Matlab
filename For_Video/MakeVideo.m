%% Set up
path = '/Volumes/Samsung_T5/Check_Parity/Pr_1/Ra_6e6';
pathF = [path '/Fields/'];
L = 30;
nx = 256;
ny = 256;
nmpi = 8;
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
%% Checking time series
% kpsmodes1 = importdata([path '/Checks/kpsmodes1.txt']);
% plot(kpsmodes1(:,1), kpsmodes1(:,2))
field_times = importdata([pathF 'field_times.txt']);
Times_list = field_times(:,2);
Times_list = Times_list - Times_list(1); % If we have not started at t = 0.
%% Picking prints we want
PTimes = 1:101; %1:700;
%% Making GIF
% set(0,'DefaultFigureVisible','off')
h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'Pr1Field.gif';
DelayTime = L/length(PTimes);
for num=PTimes % Looping round times
    if num == PTimes(1)
        Start = 1;
    elseif num == PTimes(2)
        Start = 0;
    end
    disp(num)
    Time = Times_list(num); % Time of plot
    % Making sure num is right format
    num = num2str(num);
    while length(num) < 3
        num = ['0' num];
    end
    files = dir([pathF,'hd2Dps','.*.',num,'.dat']);
    ff = zeros(nx*ny/nmpi,nmpi);
    for i=1:nmpi % Looping round mpi
        fid = fopen([pathF,files(i).name],'r');
        fread(fid,1,'real*4');
        ff(:,i) = fread(fid,inf,'real*8');
        fclose(fid);
    end
    ff = reshape(ff,nx,ny);
    %figure
    pcolor(ff');
    shading flat
    colormap('jet')
    colorbar
    xlabel('$x$', 'FontSize', 14)
    ylabel('$y$', 'FontSize', 14)
    xticks([1 nx])
    xticklabels({'$0$' '$2\pi$'})
    yticks([1 ny])
    yticklabels({'$0$' '$\pi$'})
    ax = gca;
    ax.FontSize = 14;
    title({['$Pr=1, Ra = 6 \times 10^6$']; ['$t = ' num2str(Time, ceil(log10(Time))) '$']}, 'FontSize', 15)
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
