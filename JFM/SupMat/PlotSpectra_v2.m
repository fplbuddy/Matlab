addpath('/Users/philipwinchester/Dropbox/Matlab/JFM')
run SetUp.m
% Get data and functions
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions';
addpath(fpath)
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
%load(dpath);
G = 2;
AR = ['AR_' num2str(G)];
N = 400;
type = ['OneOne' num2str(N)];
Ra = 1e8;
Pr = 1e-6;
PrT = RatoRaT(Pr);
RaT = RatoRaT(Ra);
%% Do the steady state
[psiSpec,thetaSpec,Kmax] = GetOneDSpecSteady(Data,N,N,G,Ra,Pr);
figure('Renderer', 'painters', 'Position', [5 5 700 200])
sgtitle(['$Ra = ' RaT ',\,Pr = ' PrT ',\, \Gamma = ' num2str(G) '$'],'FontSize',TitleFS)
%
subplot(1,2,1)
x_data = 1:Kmax;
x_data(psiSpec < 1e-20) = [];
psiSpec(psiSpec < 1e-20) = [];
loglog(x_data,psiSpec)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$\sqrt{k_x^2 + k_y^2}$','FontSize', LabelFS)
ylabel('$|K_{k_x,k_y} \widehat \psi^E_{k_x,k_y}|^2$','FontSize', LabelFS)
ylim([1e-12 1e8])
yticks([1e-12 1e-8 1e-4 1 1e4 1e8])
xticks([1 10 100])
%
subplot(1,2,2)
x_data = 1:Kmax;
x_data(thetaSpec < 1e-20) = [];
thetaSpec(thetaSpec < 1e-20) = [];
loglog(x_data,thetaSpec)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$\sqrt{k_x^2 + k_y^2}$','FontSize', LabelFS)
ylabel('$|\widehat \theta^E_{k_x,k_y}|^2$','FontSize', LabelFS)
ylim([1e-11 1e-1])
yticks([1e-11 1e-9 1e-7 1e-5 1e-3 1e-1])
xticks([1 10 100])