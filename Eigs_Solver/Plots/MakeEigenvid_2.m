dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
%load(dpath);
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
addpath('/Users/philipwinchester/Dropbox/Matlab/github_repo')
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE);
NumFS = 18;
TitleFS = 20;

%%
L = 10;
num = 50;
div = 1.1;
ZoNZ = "NZ";
split = 1;
G = 2;
Pr = 7e5;
point = "$q_4$";
PrS = PrtoPrS(Pr);
Ra = 2.54e7;
RaS = RatoRaS(Ra);
N = 400;
type = ['OneOne' num2str(N)];
if ZoNZ == "Z"
    if split
        EigV = Data.AR_2.(type).(PrS).(RaS).EigvZ;
    else
        EigV = Data.AR_2.(type).(PrS).(RaS).Eigv;
    end
else
    EigV = Data.AR_2.(type).(PrS).(RaS).EigvNZ;
end
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
    phase = phase_list(i);
    [Eigenfuntionpsi, Eigenfuntiontheta] = GetEigVPlot(EigV,N,phase,G,ZoNZ,1,div);
    Psilim = max(max(max(abs(Eigenfuntionpsi))), Psilim);
    Thetalim = max(max(max(abs(Eigenfuntiontheta))), Thetalim);
    i
end
'Lim done'

%% make top title
RaChar = num2str(Ra);
RaChar = strrep(RaChar,'.','');
power = num2str(floor(log10(Ra)));
dp = find(RaChar ~= '0', 1, 'last');
RaStart = RaChar(1);
if dp == 1
    TopT = ['$Ra =' RaStart '\times 10^{' power '}$'];
else
    RaEnd = char(extractBetween(RaChar, 2, dp));
    TopT = ['$Ra = ' RaStart '.' RaEnd '\times 10^{' power '}$'];
end
%
PrChar = num2str(Pr);
PrChar = strrep(PrChar,'.','');
power = num2str(floor(log10(Pr)));
dp = find(PrChar ~= '0', 1, 'last');
PrStart = PrChar(1);
if dp == 1 
    TopT = [TopT ', $Pr = ' PrStart];
else
    PrEnd = char(extractBetween(PrChar, 2, dp));
    TopT = [TopT ', $Pr = ' PrStart '.' PrEnd];
end
if not(power == "0") && not(power == "-1")
    TopT = [TopT '\times 10^{' power '}$'];
else
    TopT = [TopT '$'];
end
phase_list = 0:2*pi/num:2*pi;
phase_list(end) = []; % dont actually need the last one
h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = [convertStringsToChars(RaS) convertStringsToChars(PrS) convertStringsToChars(ZoNZ) '.gif'];
DelayTime = L/length(phase_list);
for i=1:length(phase_list)
    if i ==  1
        Start = 1;
    else
        Start = 0;
    end
    sgtitle(TopT, 'FontSize',TitleFS)
    disp(i)
    phase = phase_list(i);
    [Eigenfuntionpsi, Eigenfuntiontheta] = GetEigVPlot(EigV,N,phase,G,ZoNZ,1,div);
    subplot(2,1,1)
    pcolor(Eigenfuntionpsi);
    shading interp
    colormap('jet')
    %colorbar
    caxis([-Psilim Psilim])
    xlabel('$x$', 'FontSize', NumFS)
    ylabel('$y$', 'FontSize', NumFS)
    xticks([1 N/(div+0.01)])
    xticklabels({'$0$' '$\Gamma$'})
    yticks([1 N/(div+0.01)])
    yticklabels({'$0$' '$1$'})
    title('$\psi^O$', 'FontSize', TitleFS)
    ax = gca;
    ax.XAxis.FontSize = NumFS;
    ax.YAxis.FontSize = NumFS;
    text(0,N*1.56/div,point,'FontSize', TitleFS, 'color', 'r');
    
    subplot(2,1,2)
    pcolor(Eigenfuntiontheta);
    shading interp
    colormap('jet')
    %colorbar
    caxis([-Thetalim Thetalim])
    xlabel('$x$', 'FontSize', NumFS)
    ylabel('$y$', 'FontSize', NumFS)
    xticks([1 N/(div+0.01)])
    xticklabels({'$0$' '$\Gamma$'})
    yticks([1 N/(div+0.01)])
    yticklabels({'$0$' '$1$'})
    title('$\theta^O$', 'FontSize', TitleFS)
    ax = gca;
    ax.XAxis.FontSize = NumFS;
    ax.YAxis.FontSize = NumFS;
    %
    f = export_fig('-nocrop',['-r','300']);
    [imind,cm] = rgb2ind(f,256,'dither'); 
    drawnow
    % Write to the GIF File
    if Start
        imwrite(imind,cm,filename,'gif', 'DelayTime',DelayTime, 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','DelayTime',DelayTime,'WriteMode','append');
    end
end