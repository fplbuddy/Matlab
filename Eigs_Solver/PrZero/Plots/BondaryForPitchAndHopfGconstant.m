run SetUp.m
load('/Volumes/Samsung_T5/OldData/PrZeroData.mat')
load('/Volumes/Samsung_T5/OldData/NewSteadyState.mat')
G = 2; GS = GtoGS(G);
N = 64;
prec = 3;
%% Make pitch first
SearchType = "Simple";
res = ['N_' num2str(N)];
PrS_list = string(fields(PrZeroData.(GS).(res)));
pitch_list = zeros(length(PrS_list),1);
Pr_list1 = zeros(length(PrS_list),1);
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    D = GetFullMZero(PrZeroData, GS,PrS, "Odd");
    [~,RaA] = GetNextRaA2(D,SearchType,prec);
    pitch_list(i) = RaA;
    Pr_list1(i) = PrStoPrZero(PrS);
end
[Pr_list1,I] = sort(Pr_list1);
pitch_list = pitch_list(I);
%% Now make hopf
SearchType = "NonLinear";
res = ['N_' num2str(N) 'x' num2str(N)];
PrS_list = string(fields(Data.(GS).(res)));
hopf_list = zeros(length(PrS_list),1);
Pr_list2 = zeros(length(PrS_list),1);
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    M = GetFullMZeronss(Data,GS,PrS,1);
    [~,RaA] = GetNextRaA2nss(M, SearchType,prec);
    hopf_list(i) = RaA;
    Pr_list2(i) = PrStoPr(PrS);
end
[Pr_list2,I] = sort(Pr_list2);
hopf_list = hopf_list(I);

%% Make plot
figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(Pr_list1,pitch_list,'b-o'), hold on
loglog(Pr_list2,hopf_list,'r-o')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$\delta Ra$','FontSize',LabelFS)
xlabel('$Pr$','FontSize',LabelFS)
title(['$\Gamma = ' num2str(G) '$'], 'FontSize',TitleFS)
lgnd = legend('Pitchfork', 'Hopf');
lgnd.FontSize = LabelFS;
lgnd.Location = 'best';

saveas(gcf,[figpath 'PitchHopf' GS '.eps'], 'epsc')
