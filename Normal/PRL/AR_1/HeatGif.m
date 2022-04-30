%% Set up
run SetUp.m
path = '/Volumes/Samsung_T5/Video/Revs/Pr_30/Ra_9e5';
nx = 128;
ny = 128;
L = 40;
Upath = [path '/Fields/'];
field_times = importdata([Upath 'field_times.txt']);
Times_list = field_times(:,2);
PTimes = 5800:6100;
Ra = 9e5; Pr = 30;
kappa = sqrt((pi)^3/(Ra*Pr)); nu = sqrt((pi)^3*Pr/(Ra));

%% Making GIF
% set(0,'DefaultFigureVisible','off')
h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'heat.gif';
DelayTime = L/length(PTimes);
for num=PTimes % Looping round times
    if num == PTimes(1)
        Start = 1;
    elseif num == PTimes(2)
        Start = 0;
    end
    disp(num)
    Time = Times_list(num)*kappa/pi^2-1; % Time of plot
    % Making sure num is right format
    num = num2str(num);
    while length(num) < 4
        num = ['0' num];
    end
    files = dir([Upath,'hd2DTT','.*.',num,'.dat']);
    ff = zeros(nx*ny/nmpi,nmpi);
    for i=1:nmpi % Looping round mpi
        fid = fopen([Upath,files(i).name],'r');
        fread(fid,1,'real*4');
        ff(:,i) = fread(fid,inf,'real*8');
        fclose(fid);
    end
    ff = reshape(ff,nx,ny);
    fieldcheck = ff';
    pcolor(ff');
    shading flat
    colormap('jet')
    caxis([0 1])
    colorbar
    xlabel('$x$', 'FontSize', 14)
    ylabel('$y$', 'FontSize', 14)
    xticks([1 nx])
    xticklabels({'$0$' '$\Gamma$'})
    yticks([1 ny])
    yticklabels({'$0$' '$1$'})
    title(['$t=' num2str(Time, 3) '$'], 'FontSize', 14)
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


