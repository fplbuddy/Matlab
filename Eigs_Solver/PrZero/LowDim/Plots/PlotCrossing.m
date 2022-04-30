LabelFS = 20;
numFS = 20;
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
fpath3 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/LowDim/Functions/';
fpath4 = '/Users/philipwinchester/Dropbox/Matlab/Normal/Functions/';
addpath(fpath)
addpath(fpath2)
addpath(fpath3)
addpath(fpath4)
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
load(dpath);
res = 'N_Low';
Pr_list = [];
cross_list = [];
PrS_list = string(fieldnames(PrZeroData.(res)));
RaC = 8*pi^4;

for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPrZero(PrS);
    Pr_list = [Pr_list Pr];
    D = GetFullMZeroLowDim(PrZeroData, PrS);
    [~,RaA] = GetNextRaA(D);     
    cross_list = [cross_list RaA];
end
figure('Renderer', 'painters', 'Position', [5 5 700 300])
[Pr_list,I] = sort(Pr_list);
cross_list = cross_list(I);
Pr_list = [min(Pr_list) Pr_list max(Pr_list)];
RaA_list = [max(cross_list) cross_list max(cross_list)];
patch(Pr_list,RaA_list,'blue','EdgeColor','blue')
set(gca,'yscale', 'log')
set(gca,'xscale', 'log')
xlabel('Pr','FontSize', LabelFS)
ylabel('$\delta$Ra/Ra$_c$','FontSize', LabelFS)
title('$\Gamma =2$, Low-dim model','FontSize', LabelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
hold on
xlim([min(Pr_list) max(Pr_list)])
ylim([min(RaA_list) max(RaA_list)])
yticks([1e-12 1e-10 1e-8 1e-6 1e-4 1e-2 1 100])
xticks([1e-4 1e-2 1])
xlim([1e-4 1])

analytical = zeros(1,length(Pr_list));
for i=1:length(analytical)
    analytical(i) = RaC*(39/10)*Pr_list(i)^2;
end
plot(Pr_list,analytical, 'r--','LineWidth',3 )

text(2e-5,1e-1,'Ra = Ra$_c$ + $\delta$Ra','FontSize', LabelFS, 'Color', 'white')
text(2e-3,1e-6,'$\delta$Ra $=$ Ra$_c\frac{39}{10}$Pr$^2$','FontSize', LabelFS, 'Color', 'red')

