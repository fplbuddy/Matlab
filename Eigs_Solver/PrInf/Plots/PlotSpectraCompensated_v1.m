run SetUp.m
% Get data and functions
dpath = '/Volumes/Samsung_T5/OldData/PrInfData.mat';
load(dpath);
G = 2;
AR = ['AR_' strrep(num2str(G),'.','_')];
Nx = 256;
Ny = 256;
type = ['N_' num2str(Nx) 'x' num2str(Ny)];
Ra = 3e6;
RaT = RatoRaT(Ra);
%% Do the steady state
[thetaSpec,xdata] = GetOneDSpecSteadyInf(PrInfData,Nx,Ny,G,Ra);
figure('Renderer', 'painters', 'Position', [5 5 700 200])
title(['$Ra = ' RaT ',\, \Gamma = ' num2str(G) '$'],'FontSize',TitleFS)
%
xdata(thetaSpec < 1e-20) = [];
thetaSpec(thetaSpec < 1e-20) = [];
loglog(xdata,thetaSpec.*(xdata').^2)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
%xlabel('$k=\sqrt{k_x^2 + k_y^2}$','FontSize', LabelFS)
ylabel('$|\widehat \theta^E_{k_x,k_y}|^2\times k^2$','FontSize', LabelFS)
%ylim([1e-4 1])
%yticks([1e-11 1e-9 1e-7 1e-5 1e-3 1e-1])
xticks([1 10 100])