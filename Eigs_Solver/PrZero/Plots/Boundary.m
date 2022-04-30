%% Set up
LabelFS = 20;
numFS = 20;
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)

%%
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
fpath4 = '/Users/philipwinchester/Dropbox/Matlab/Normal/Functions/';
addpath(fpath)
addpath(fpath2)
addpath(fpath4)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
spath = dpath;
%load(dpath);
G = 2.36;
GS = GtoGS(G);
RaC = pi^4*(4+G^2)^3/(4*G^4);

PrS_list = [string(fields(PrZeroData.(GS).N_64)); string(fields(PrZeroData.(GS).N_128))];
%PrS_list = [string(fields(PrZeroData.(GS).N_128))];


Pr_list = [];
RaA_list = [];
prec = 4;




for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPrZero(PrS);
    D = GetFullMZero(PrZeroData, GS,PrS, "Odd");
    %RaA_add = GetCrossings(D);
    [Done,RaA_add] = GetNextRaA2(D,"Simple",prec);
    Pr_add = ones(1,length(RaA_add))*Pr;
    Pr_list = [Pr_list Pr_add];
    RaA_list = [RaA_list RaA_add];
end


[RaA_list, I] = sort(RaA_list);
Pr_list = Pr_list(I);

%% test
% figure()
% x = 0;
% power = (1/2);
% plot((Pr_list).^(power),RaA_list.^(power),'*')
%% Plot

figure('Renderer', 'painters', 'Position', [5 5 700 300])
[Pr_list,I] = sort(Pr_list);
RaA_list = RaA_list(I);
Pr_list = [1e-9 Pr_list 1e-4];
RaA_list = [1e4 RaA_list 1e4];
patch(Pr_list,RaA_list,'blue','EdgeColor','blue'), hold on
set(gca,'yscale', 'log')
set(gca,'xscale', 'log')
xlabel('Pr','FontSize', LabelFS)
ylabel('$\delta$Ra','FontSize', LabelFS)
title(['$\Gamma =' num2str(G) '$'],'FontSize', LabelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([1e-9 1e-4])
ylim([4e3 7e3])
plot(Pr_list(2:end-1),RaA_list(2:end-1), 'r*', 'MarkerSize', 20), hold on
%yticks([1e-10 1e-8 1e-6 1e-4 1e-2 1 1e2 1e4 1e6]), hold on
%yticklabels({'$10^{-10}$' '$10^{-8}$' '$10^{-6}$' '$10^{-4}$' '$10^{-2}$' '$1$' '$10^{2}$' '$10^{4}$'})
