path = '/Volumes/Samsung_T5/Video/ZtoNS';
home = '/Users/philipwinchester/Dropbox/Matlab/Normal';
Functions = [home '/Functions'];
addpath(Functions);
pathF = [path '/Fields/'];
kpsmodes1 = importdata([path '/Checks/kpsmodes1.txt']);
signal = kpsmodes1(:,2)*2;
t = kpsmodes1(:,1);
L = 27;
nx = 256;
ny = 256;
nmpi = 8;
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
numFS = 18;
%% calcuating some stuff
Ra = 5.6e6;
Pr = 30;
kappa = sqrt((pi)^3/(Ra*Pr));
kenergy = importdata([path '/Checks/kenergy.txt']);
te = kenergy(:,1);
Ex = kenergy(:,6);
Ey = kenergy(:,5);
urms = 2*Ex+2*Ey;
urms = MyMeanEasy(urms,t); urms = urms^(1/2);

%% Getting field times
field_times = importdata([pathF 'field_times.txt']);
Times_list = field_times(:,2);
Times_list = Times_list/(pi/urms);

%% non-dim and fixing data
signal = signal/(pi*urms);
t = t/(pi/urms);
t(1:9) = [];
signal(1:9) = [];
t = [Times_list(1); t];
signal = [100; signal];
t = t([1 2 12:10:length(t)]);
signal = signal([1 2 12:10:length(signal)]);

%% Doing so that we start at 0
t = t - t(1);
Times_list = Times_list - Times_list(1);

%% Setting print times
PTimes = [1200:1400 250:450];

%% Changing t and signal into what we want
dt = mean(diff(t));
extra = 1800;
signal = [signal(1200:1400+extra); -signal(250:450)];
t = (0:length(signal)-1)*dt+546;

%% Make gif
set(0,'DefaultFigureVisible','off')
h = figure('Renderer', 'painters', 'Position', [5 5 400 400]);
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'GammaTwo.gif';
DelayTime = L/length(PTimes);
count = 0;
swap = 0;
for P=PTimes % Looping round times
    count = count + 1;
    if P == 250, count = extra + count; swap = 1; end
    if P == PTimes(1)
        Start = 1;
    elseif P == PTimes(2)
        Start = 0;
    end
    disp(P)
    subplot(2,1,1)
    % plot green bit
    plot(t(1:count), signal(1:count), 'Color', [0 0.5 0]), hold on
    % plot shaded bit
    plt = plot(t(count:end), signal(count:end), 'Color', [0 0.5 0]); hold off
    plt.Color(4) = 0.3;
    xlim([min(t) max(t)])
    ax = gca;
    ax.FontSize = numFS;
    xlabel('$t/(\pi d/u_{rms})$', 'FontSize', numFS)
    ylabel('$\widehat \psi_{0,1}/(\pi d u_{rms})$', 'FontSize', numFS)
    %
    %
    subplot(2,1,2)
    Time = t(count); % Time of plot
    % Making sure num is right format
    P = num2str(P);
    while length(P) < 4
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
    ff = ff';
    if swap
    ff = [ff(:,nx:-1:nx/2+1) ff(:,nx/2:-1:1)];
    end
    pcolor(ff);
    shading flat
    colormap('jet')
    colorbar
    caxis([0 1])
    xlabel('$x/(\pi d)$', 'FontSize', numFS)
    ylabel('$y/(\pi d)$', 'FontSize', numFS)
    xticks([1 nx])
    xticklabels({'$0$' '$\Gamma = 2$'})
    yticks([1 ny])
    yticklabels({'$0$' '$1$'})
    ax = gca;
    ax.FontSize = numFS;
    text(40, ny+20,'$T/\Delta T$', 'HorizontalAlignment', 'center', 'FontSize', numFS)
    sgtitle({['Pr $=30, $ Ra $= 5.6 \times 10^6$']; ['$t = ' num2str(Time, ceil(log10(Time))) '$']}, 'FontSize', numFS + 4)
    
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
set(0,'DefaultFigureVisible','on')

%% Test plot
figure('Renderer', 'painters', 'Position', [5 5 400 400]);
count = 10;
P = 5000;
subplot(2,1,1)
% plot green bit
plot(t(1:count), signal(1:count), 'Color', [0 0.5 0]), hold on
% plot shaded bit
plt = plot(t(count:end), signal(count:end), 'Color', [0 0.5 0]); hold off
plt.Color(4) = 0.3;
xlim([min(t) max(t)])
ax = gca;
ax.FontSize = numFS;
xlabel('$t/(\pi d/u_{rms})$', 'FontSize', numFS)
ylabel('$\widehat \psi_{0,1}/(\pi d u_{rms})$', 'FontSize', numFS)
%
%
subplot(2,1,2)
Time = t(count); % Time of plot
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
ff = ff';
ff = [ff(:,nx:-1:nx/2+1) ff(:,nx/2:-1:1)];
pcolor(ff);
shading flat
colormap('jet')
colorbar
caxis([0 1])
xlabel('$x/(\pi d)$', 'FontSize', numFS)
ylabel('$y/(\pi d)$', 'FontSize', numFS)
xticks([1 nx])
xticklabels({'$0$' '$\Gamma = 2$'})
yticks([1 ny])
yticklabels({'$0$' '$1$'})
ax = gca;
ax.FontSize = numFS;
text(40, ny+20,'$T/\Delta T$', 'HorizontalAlignment', 'center', 'FontSize', numFS)
sgtitle({['Pr $=30, $ Ra $= 5.6 \times 10^6$']; ['$t = ' num2str(Time, ceil(log10(Time))) '$']}, 'FontSize', numFS + 4)


%[M(:,(3:4)) M(:,(2:-1:1))]
