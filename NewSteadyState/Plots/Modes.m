fpath = '/Users/philipwinchester/Dropbox/Matlab/NewSteadyState/Functions';
addpath(fpath);
path = '/Volumes/Samsung_T5/OldData/NewSteadyState.mat';
load(path)
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
FS = 20;
Pr = 0.01;
PrS = PrtoPrS(Pr);
type = 'N_64';
RaS_list = string(fields(Data.(type).(PrS)));
Ra_list = [];
OneOne = [];
ZeroOne = [];
%RaC = 8*pi^4+56.3;
for i=1:length(RaS_list)
    RaS = RaS_list(i);
    Ra = RaStoRa(RaS);
    Ra_list = [Ra Ra_list];
    PsiE = Data.(type).(PrS).(RaS).PsiE;
    OneOne = [PsiE(2) OneOne];
    ZeroOne = [PsiE(1) ZeroOne];
end
figure('Renderer', 'painters', 'Position', [10 10 600 250])
plot(Ra_list, OneOne, 'blue*'), hold on
plot(Ra_list, ZeroOne, 'red*'), hold on
xlim([785 790])
ylim([0 0.2])
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
text(786, 0.15, '$|\widehat \psi_{1,1}|$', 'Color','blue', 'FontSize', FS)
text(786, 0.07, '$|\widehat \psi_{0,1}|$', 'Color','red', 'FontSize', FS)
title('$Pr = 10^{-2}$', 'FontSize', FS)
xlabel('$Ra$', 'FontSize', FS)
% x1 = 0.1;
% x2 = 1;
% y1 = 0.04;
% plot([x1 x2], [y1 (y1/sqrt(x1))*sqrt(x2)])