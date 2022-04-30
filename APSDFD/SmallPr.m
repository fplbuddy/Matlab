run SetUp.m
AR = "AR_2";
type_list = ["OneOne400" "OneOne320" "OneOne256" "OneOne152" "OneOne128" "OneOne200" "OneOne172" "OneOne100" "OneOne88" "OneOne64"];
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions');
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);
myBlue = [41 170 225]/255;

%% do zero stuff
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
fpath4 = '/Users/philipwinchester/Dropbox/Matlab/Normal/Functions/';
addpath(fpath)
addpath(fpath2)
addpath(fpath4)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
load(dpath);
RaC = 8*pi^4;


PrS_list = [string(fields(PrZeroData.G_2.N_32)); string(fields(PrZeroData.G_2.N_64))];
PrS_list(PrS_list == "Pr_2_6e_2") = [];
PrS_list(PrS_list == "Pr_2_5e_2") = [];
PrS_list(PrS_list == "Pr_2_4e_2") = [];
PrS_list(PrS_list == "Pr_2_3e_2") = [];
PrS_list(PrS_list == "Pr_3e_2") = [];
PrS_list(PrS_list == "Pr_1e14") = [];

Pr_list = [];
RaA_list = [];





for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPrZero(PrS);
    D = GetFullMZero(PrZeroData,"G_2",PrS,"Odd", ["N_32" "N_64"]);
    RaA_add = GetCrossings(D);
    Pr_add = ones(1,length(RaA_add))*Pr;
    Pr_list = [Pr_list Pr_add];
    RaA_list = [RaA_list RaA_add];
end


[RaA_list, I] = sort(RaA_list);
Pr_list = Pr_list(I);

%% make plot
figure('Renderer', 'painters', 'Position', [5 5 600 200])
xlim([1e-6 2e-2])
ylim([1e-8 1e2])
Pr_list = [1e-6 Pr_list 1e-1];
RaA_list = [1e5 RaA_list 1e5];
patch(Pr_list,RaA_list,myBlue,'EdgeColor',myBlue)
set(gca,'yscale', 'log')
set(gca,'xscale', 'log')
xlabel('$Pr$','FontSize', LabelFS, 'Color', 'w')
ylabel('$\delta Ra$','FontSize', LabelFS, 'Color', 'w')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
yticks([1e-8 1e-6 1e-4 1e-2 1 1e2 1e4])
hold on

% power law
Pr1 = 1e-6;
Pr2 = 2e-2;
A = 6.35e4;
RaA1 = A*Pr1^2;
RaA2 = A*Pr2^2;
plot([Pr1 Pr2], [RaA1 RaA2], '--red', 'linewidth', 2)
text(2e-5, 1, '$\delta Ra = 6.35 \times 10^4 Pr^2$', 'FontSize',LabelFS, 'Color','red')
set(gca,'XColor',[1 1 1])
set(gca,'YColor',[1 1 1])

set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Color',[0 0 0]);
print(gcf,[pwd '/SmallPr.png'],'-dpng','-r300');




%saveas(gcf,[figpath 'SmallPr.eps'], 'epsc')
