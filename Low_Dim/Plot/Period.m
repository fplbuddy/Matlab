% Getting functions we need
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
fpath3 = '/Users/philipwinchester/Dropbox/Matlab/Normal/Functions/';
fpath4 = '/Users/philipwinchester/Dropbox/Matlab/Low_Dim/Functions';
addpath(fpath)
addpath(fpath2)
addpath(fpath3)
addpath(fpath4)
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
%%
load('/Volumes/Samsung_T5/OldData/LowDim.mat')
MS = 10;
FS = 20;
Pr = 1e-3;
PrS = PrtoPrSZero(Pr);
RaAS_list = string(fields(results));
RaAS_list(RaAS_list == "RaA_2e2") = [];
m_list = [];
RaA_list = [];
for i=1:length(RaAS_list)
    RaAS = RaAS_list(i);
    RaA = RaAStoRaA(RaAS);
    tlower = results.(RaAS).(PrS).tlower;
    t = results.(RaAS).(PrS).t;
    y = results.(RaAS).(PrS).y(3,:); y(tlower > t) = [];
    t(tlower > t) = [];
    [~,locs] = findpeaks(y);
    peaksloct = t(locs);
    m = diff(peaksloct); m = mean(m);
    % collectiing data
    m_list = [m_list m];
    RaA_list = [RaA_list RaA]; 
end
figure('Renderer', 'painters', 'Position', [5 5 600 250])
loglog(RaA_list,m_list, '*', 'MarkerSize', MS)
ylim([1e3 2e5])
yticks([1e3 1e4 1e5])
title('Pr $= 10^{-3}$', 'FontSize', FS)
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
ylabel('Period/$((\pi d)^2/\kappa)$', 'FontSize', FS)
xlabel('$\delta$Ra', 'FontSize', FS)

% higlight power law
hold on
plot([4 40], [8e4 8e3], 'k--', 'LineWidth',2)
text(20,6e4,'Period $\propto \delta$Ra$^{-1}$','FontSize',FS)