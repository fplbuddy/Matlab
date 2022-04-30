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
figpath = '/Users/philipwinchester/Desktop/Figures/';

%%
ZoNZ = "Z";
split = 0;
G = 2;
Pr = 0.2;
point = "$q_1$";
PrS = PrtoPrS(Pr);
Ra = 3.32e5;
RaS = RatoRaS(Ra);
N = 152;
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
% put in in format so that we can plot it, ie remove complex conjugates
n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
I = find(n<0);
EigV([I I+length(n)]) = [];

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
h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = [convertStringsToChars(RaS) convertStringsToChars(PrS) convertStringsToChars(ZoNZ) '.eps'];
sgtitle(TopT, 'FontSize',TitleFS)
[Eigenfuntionpsi, Eigenfuntiontheta] = GetEigVPlot(EigV,N,0,G,ZoNZ);
subplot(2,1,1)
pcolor(Eigenfuntionpsi);
shading flat
colormap('jet')
%colorbar
caxis([-max(max(abs(Eigenfuntionpsi))) max(max(abs(Eigenfuntionpsi)))])
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
text(0,2*N*1.56,point,'FontSize', TitleFS, 'color', 'r');

subplot(2,1,2)
pcolor(Eigenfuntiontheta);
shading flat
colormap('jet')
%colorbar
caxis([-max(max(abs(Eigenfuntiontheta))) max(max(abs(Eigenfuntiontheta)))])
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

saveas(gcf,[figpath filename], 'epsc')