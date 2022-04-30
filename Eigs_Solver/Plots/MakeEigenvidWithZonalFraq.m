dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE);
NumFS = 18;
TitleFS = 20;

%%
L = 10;
num = 50;
ZoNZ = "Z";
split = 0; % This is if we have Eigvz and Eigvnz, for larger Pr
G = 2;
Pr = 8.58;
PrS = PrtoPrS(Pr);
Ra = 1.27e6;
RaS = RatoRaS(Ra);
N = 256;
type = ['OneOne' num2str(N)];
if ZoNZ == "Z"
    BotT = "with zonal flow";
    if split
        EigV = Data.AR_2.(type).(PrS).(RaS).EigvZ;
    else
        EigV = Data.AR_2.(type).(PrS).(RaS).Eigv;
    end
else
    BotT = "without zonal flow";
    EigV = Data.AR_2.(type).(PrS).(RaS).EigvNZ;
end
% put in in format so that we can plot it, ie remove complex conjugates
n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
I = find(n<0);
EigV([I I+length(n)]) = [];
%% get limits
% do ten and take maximum
Psilim = 0;
Thetalim = 0;
numtest = 10;
phase_list = 0:2*pi/numtest:2*pi;
for i=1:length(phase_list)
    i
    phase = phase_list(i);
    [Eigenfuntionpsi, Eigenfuntiontheta] = GetEigVPlot(EigV,N,phase,G,ZoNZ);
    Psilim = max(max(max(abs(Eigenfuntionpsi))), Psilim);
    Thetalim = max(max(max(abs(Eigenfuntiontheta))), Thetalim);
end
'Lim done'

%% make top title
RaChar = num2str(Ra);
RaChar = strrep(RaChar,'.','');
power = num2str(floor(log10(Ra)));
dp = find(RaChar ~= '0', 1, 'last');
RaStart = RaChar(1);
if dp == 1
    TopT = ['$Ra =' RaStart '\times 10^' power '$'];
else
    RaEnd = char(extractBetween(RaChar, 2, dp));
    TopT = ['$Ra = ' RaStart '.' RaEnd '\times 10^' power '$'];
end
%
PrChar = num2str(Pr);
PrChar = strrep(PrChar,'.','');
power = num2str(floor(log10(Pr)));
dp = find(PrChar ~= '0', 1, 'last');
PrStart = PrChar(1);
if dp == 1
    TopT = [TopT ', $Pr = ' PrStart '\times 10^' power '$'];
else
    PrEnd = char(extractBetween(RaChar, 2, dp));
    TopT = [TopT ', $Pr = ' PrStart '.' PrEnd '\times 10^' power '$'];
end
phase_list = 0:2*pi/num:2*pi;
phase_list(end) = []; % dont actually need the last one
h = figure('Renderer', 'painters', 'Position', [5 5 550 500]);
axis tight manual % this ensures that getframe() returns a consistent size
filename = [convertStringsToChars(RaS) convertStringsToChars(PrS) convertStringsToChars(ZoNZ) '.gif'];
DelayTime = L/length(phase_list);
ZeroOneFreq_list = [];
phase_plot = [];
for i=1:length(phase_list)
    if i ==  1
        Start = 1;
    else
        Start = 0;
    end
    sgtitle({TopT; BotT}, 'FontSize',TitleFS)
    disp(i)
    phase = phase_list(i);
    [Eigenfuntionpsi, Eigenfuntiontheta, ZeroOneFraq] = GetEigVPlot(EigV,N,phase,G,ZoNZ);
    subplot(3,1,1)
    pcolor(Eigenfuntionpsi);
    shading flat
    colormap('jet')
    %colorbar
    caxis([-Psilim Psilim])
    xlabel('$x$', 'FontSize', NumFS)
    ylabel('$y$', 'FontSize', NumFS)
    xticks([1 2*N])
    xticklabels({'$0$' '$\Gamma$'})
    yticks([1 2*N])
    yticklabels({'$0$' '$1$'})
    title('$\psi^O$', 'FontSize', TitleFS)
    ax = gca;
    ax.XAxis.FontSize = NumFS;
    ax.YAxis.FontSize = NumFS;
    
    subplot(3,1,2)
    pcolor(Eigenfuntiontheta);
    shading flat
    colormap('jet')
    %colorbar
    caxis([-Thetalim Thetalim])
    xlabel('$x$', 'FontSize', NumFS)
    ylabel('$y$', 'FontSize', NumFS)
    xticks([1 2*N])
    xticklabels({'$0$' '$\Gamma$'})
    yticks([1 2*N])
    yticklabels({'$0$' '$1$'})
    title('$\theta^O$', 'FontSize', TitleFS)
    ax = gca;
    ax.XAxis.FontSize = NumFS;
    ax.YAxis.FontSize = NumFS;
    
    ZeroOneFreq_list = [ZeroOneFreq_list ZeroOneFraq];
    phase_plot = [phase_plot phase];
    subplot(3,1,3)
    plot(phase_plot, ZeroOneFreq_list, 'LineWidth',2)
    xlim([0 2*pi])
    ylim([0.1 0.7])
    xticks([0 pi 2*pi])
    xticklabels({'$0$', '$\pi$' '$2\pi$'})
    ax = gca;
    ax.XAxis.FontSize = NumFS;
    ax.YAxis.FontSize = NumFS;
    xlabel('Phase', 'FontSize', NumFS)
    ylabel('$E_y/E$', 'FontSize', NumFS)
    %
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