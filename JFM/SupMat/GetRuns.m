addpath('/Users/philipwinchester/Dropbox/Matlab/JFM')
run SetUp.m
% Get data and functions
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions';
addpath(fpath)
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
load(dpath);
%% Get normal data
GS = "AR_2";
Res_list = string(fields(Data.(GS)));
Pr_list = [];
Ra_list = [];
for i = 1:length(Res_list)
    PrS_list = string(fields(Data.(GS).(Res_list(i))));
    for j=1:length(PrS_list)
        PrS = PrS_list(j); Pr = PrStoPr(PrS);
        RaS_list = string(fields(Data.(GS).(Res_list(i)).(PrS)));
        for k=1:length(RaS_list)
            RaS = RaS_list(k); Ra = RaStoRa(RaS);
            Pr_list = [Pr_list Pr];
            Ra_list = [Ra_list Ra];
        end
    end
end
%% Get RaA data
RaC = RaCfunc(2);
Res_list = string(fields(PrZeroData.G_2));
for i = 1:length(Res_list)
    PrS_list = string(fields(PrZeroData.G_2.(Res_list(i))));
    for j=1:length(PrS_list)
        PrS = PrS_list(j); Pr = PrStoPrZero(PrS);
        RaAS_list = string(fields(PrZeroData.G_2.(Res_list(i)).(PrS)));
        for k=1:length(RaAS_list)
            RaAS = RaAS_list(k); RaA = RaAStoRaA(RaAS);
            Pr_list = [Pr_list Pr];
            Ra_list = [Ra_list RaA + RaC];
        end
    end
end
%% Make plot
figure('Renderer', 'painters', 'Position', [5 5 650 250])
Ra_list(Pr_list>= 1e7) = [];
Pr_list(Pr_list>= 1e7) = [];
loglog(Pr_list(Ra_list <= 3e3),Ra_list(Ra_list <= 3e3),'*','DisplayName','64'), hold on 
loglog(Pr_list(Ra_list <= 6e5 & Ra_list > 3e3),Ra_list(Ra_list <= 6e5 & Ra_list > 3e3),'*','DisplayName','152')
loglog(Pr_list(Ra_list <= 4e6 & Ra_list > 6e5),Ra_list(Ra_list <= 4e6 & Ra_list > 6e5),'*','DisplayName','256') 
loglog(Pr_list(Ra_list <= 1e8 & Ra_list > 4e6),Ra_list(Ra_list <= 1e8 & Ra_list > 4e6),'*','DisplayName','400')
lgnd = legend('Location', 'bestoutside', 'FontSize', lgndFS); title(lgnd,'$N$', 'FontSize', lgndFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$Pr$','FontSize', LabelFS)
ylabel('$Ra$','FontSize', LabelFS)
ylim([5e2 1e8])
yticks([1e3 1e4 1e5 1e6 1e7 1e8])
yticklabels({'$10^3$' '$10^4$' '$10^5$' '$10^6$' '$10^7$' '$10^8$'})
xticks([1e-6 1e-4 1e-2 1 1e2 1e4 1e6])
