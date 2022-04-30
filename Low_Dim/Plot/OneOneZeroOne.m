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
RaA_list = [1 10 30 100 200];
Pr = 1e-3;
frac = 0.5;
FS = 20;


for i=1:length(RaA_list)
    RaA = RaA_list(i);
    RaAS = RaAtoRaAS(RaA);
    PrS = PrtoPrSZero(Pr);
    OneOne = results.(RaAS).(PrS).y(1,:); OneOne = OneOne(round(end*frac):end);
    ZeroOne = results.(RaAS).(PrS).y(3,:); ZeroOne = ZeroOne(round(end*frac):end);
    plot(OneOne,ZeroOne, 'DisplayName', num2str(RaA), 'LineWidth', 2)
    hold on
end
lgnd = legend('Location', 'northeast', 'FontSize', FS); title(lgnd,'$\delta$Ra', 'FontSize', FS)
title('Pr $= 10^{-3}$', 'FontSize', FS)
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
ylabel('$\widehat \psi_{0,1}$', 'FontSize', FS)
xlabel('$\widehat \psi_{1,1}$', 'FontSize', FS)