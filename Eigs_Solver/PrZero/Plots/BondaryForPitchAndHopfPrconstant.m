run SetUp.m
load('/Volumes/Samsung_T5/OldData/PrZeroData.mat')
load('/Volumes/Samsung_T5/OldData/NewSteadyState.mat')
Pr = 1e-3;
N = 64;
prec = 3;
G_listp = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.21 2.22 2.23 2.24 2.25 2.26 2.27 2.28 2.29 2.3];
G_listp2 = [];
G_listh = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2];
%% Make pitch first
SearchType = "Simple";
res = ['N_' num2str(N)];
PrS = PrtoPrSZero(Pr);
pitch_list = [];
for i=1:length(G_listp)
    G = G_listp(i);
    GS = GtoGS(G);
    D = GetFullMZero(PrZeroData, GS,PrS, "Odd");
    CrossingPoints = GetCrossingPoints(D);
    pitch_list = [pitch_list CrossingPoints];
    G_listp2 = [G_listp2 G*ones(1,length(CrossingPoints))];
end
% fix order
pitch_list2 = [];
G_listp3 = [];
loc2 = find(G_listp2 == 2);
%
pitch_list2 = [pitch_list2 pitch_list(1:loc2)];
G_listp3 = [G_listp3 G_listp2(1:loc2)];
%
[pitch_list,I] = sort(pitch_list(loc2+1:end));
G_listp2 = G_listp2(loc2+1:end);
G_listp2 = G_listp2(I);
%
pitch_list2 = [pitch_list2 pitch_list];
G_listp3 = [G_listp3 G_listp2];

%% Now make hopf
SearchType = "NonLinear";
res = ['N_' num2str(N) 'x' num2str(N)];
PrS = PrtoPrS(Pr);
hopf_list = zeros(length(G_listh),1);
for i=1:length(G_listh)
        G = G_listh(i);
    GS = GtoGS(G);
    M = GetFullMZeronss(Data,GS,PrS,1);
    [~,RaA] = GetNextRaA2nss(M, SearchType,prec);
    hopf_list(i) = RaA;
end

%% Make plot
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(G_listp3,pitch_list2,'b-o'), hold on
plot(G_listh,hopf_list,'r-o')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$\delta Ra$','FontSize',LabelFS)
xlabel('$\Gamma$','FontSize',LabelFS)
title(['$Pr = ' num2str(Pr) '$'], 'FontSize',TitleFS)
lgnd = legend('Pitchfork', 'Hopf');
lgnd.FontSize = LabelFS;
lgnd.Location = 'best';
yticks([1e-2 1 1e2 1e4])

PrS = convertStringsToChars(PrtoPrSZero(Pr));
%saveas(gcf,[figpath 'PitchHopf' PrS '.eps'], 'epsc')
