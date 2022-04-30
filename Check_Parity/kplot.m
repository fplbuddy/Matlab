%% Set up
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
clear
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
Mpath = '/Volumes/Samsung_T5/Check_Parity';
nx = 256;
ny = 256;
Pr = 3;
Ra = 6e6;
RaS = convertStringsToChars(RatoRaS(Ra));
PrS = ['Pr_' num2str(Pr)];
L = 40;
path = [Mpath '/' PrS '/' RaS '/'];
xr = floor(nx/3 + 1) + 1;
yr = floor(2*ny/3 + 1);
Upath = [path 'Spectra/'];
spec_times = importdata([Upath 'spec_times.txt']);
Times_list = spec_times(:,2);
PTimes = 1:101;

%% Making GIF
% set(0,'DefaultFigureVisible','off')
h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'test.gif';
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
    fid = fopen([Upath 'spectrum2D_UU.' num '.out'],'r');
    fread(fid,1, 'real*4');
    Spectra = fread(fid,inf, 'real*8');
    fclose(fid);
    % Reshape and plot
    Spectra = reshape(Spectra,xr,yr);
    pcolor(Spectra');
    colormap('jet')
    colorbar
    caxis([1e-6 1])
    set(gca,'ColorScale','log')
    xlim([1 10])
    ylim([1 20])
    xlabel('$k_x$', 'FontSize', 14)
    ylabel('$k_y$', 'FontSize', 14)
    l = 3:2:40; l = l/2;
    xticks(l)
    xticklabels({'$0$' '$1$' '$2$' '$3$' '$4$' '$5$' '$6$' '$7$' '$8$'})
    yticks(l)
    yticklabels({'$1$' '$2$' '$3$' '$4$' '$5$' '$6$' '$7$' '$8$' '$9$' '$10$' '$11$' '$12$' '$13$' '$14$' '$15$' '$16$' '$17$' '$18$' '$19$'})
    ax = gca;
    ax.FontSize = 14;
    title({['$Pr=' num2str(Pr) ', Ra = ' RatoRaT(Ra)  '$']; ['$t = ' num2str(Time, ceil(log10(Time))) '$']}, 'FontSize', 15)
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


