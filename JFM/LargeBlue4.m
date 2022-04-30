AR = "AR_2";
type_list = ["OneOne400" "OneOne320" "OneOne256" "OneOne152" "OneOne128" "OneOne200" "OneOne172" "OneOne100" "OneOne88" "OneOne64"];
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions');
run SetUp.m
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);


%% cleaning
% above we might want to remove for good
% below are just for this bit
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_30000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_60000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_100000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_110000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_120000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_130000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_160000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_200000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_210000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_220000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_230000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_260000");


% FOR NOW ONLY
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_220000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_230000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_260000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_210000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_800000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_600000");

%%
maxPr = 1e6; % defining some max Pr we consider
minPr = 1e2; % defining some min Pr we consider
PrS_list = [];
for i = 1:length(type_list)
    type = type_list(i);
    try
        PrS_list_inst = string(fields(Data.(AR).(type)));
        PrS_list = [PrS_list; PrS_list_inst];
    catch
    end
end
PrS_list = RemoveStringDuplicatesPr(PrS_list, maxPr, minPr);
[PrS_list, ~]= OrderPrS_list(PrS_list); % Now we have all of our PrS;


%% get crossings


% for i=1:length(PrS_list)
%     PrS = PrS_list(i);
%     Pr = PrStoPr(PrS);
%     M = GetFullM(Data, PrS, AR,"");
%     PlotData.(PrS).v = CrossingVector(M);
% end


%%
Pr_zonal = [];
Ra_zonal = [];
Pr_nonzonal = [];
Ra_nonzonal = [];

% Do until we change method
PrSChange = "Pr_160000";
PrSChangeloc  = find(PrS_list == PrSChange );
for i=1:PrSChangeloc
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,"");
    v = CrossingVector(M);
    Ra_zonal = [Ra_zonal v];
    Pr_zonal = [Pr_zonal Pr*ones(1,length(v))];
end
% get remaining zonal
for i=PrSChangeloc+1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    try
        A = GetFullMZonal(Data, PrS);
        [~,Ra] = GetNextRaNonLinear(A);
        Ra_zonal = [Ra_zonal Ra];
        Pr_zonal = [Pr_zonal Pr];
    catch
    end
end
% get remaining nonzonal
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    try
        A = GetFullMNonZonal(Data, PrS);
        [~,Ra] = GetNextRaNonLinear(A);
        Ra_nonzonal = [Ra_nonzonal Ra];
        Pr_nonzonal = [Pr_nonzonal Pr];
    catch
    end
end
Ra_nonzonal = [Ra_nonzonal 2.54e7];
Pr_nonzonal = [Pr_nonzonal 1e6];

%% making minimum
Pr_list = [];
Ra_list = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    try
        I =  find(Pr_zonal == Pr);
        zonal = Ra_zonal(I);
    catch
        zonal = 1e8; % some large number
    end
    try
        I =  find(Pr_nonzonal == Pr);
        nonzonal = Ra_nonzonal(I);
    catch
        nonzonal = 1e8; % some large number
    end
    Pr_list = [Pr_list Pr];
    Ra_list = [Ra_list min([nonzonal zonal])];
end

%% Getting inserts
N = 400;
Pr = 1e5; Ra = 1.56e7; PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
EigV = Data.AR_2.OneOne400.(PrS).(RaS).Eigv;
n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
I = find(n<0);
EigV([I I+length(n)]) = [];
% set phase to maximize zonal flow
phase = -angle(EigV(1)); % 1 is where 0,1 is
[Eigenfuntionpsi1, ~,~] = GetEigVPlot(EigV,400,phase,2,"Z",0,1.1);
%
Pr = 7e5; Ra = 2.54e7; PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
EigV = Data.AR_2.OneOne400.(PrS).(RaS).EigvNZ;
EigV([I I+length(n)]) = [];
phase = -angle(EigV(2))+pi/2; % 2 is where 2,1 is
[Eigenfuntionpsi2, ~,~] = GetEigVPlot(EigV,400,phase,2,"NZ",0,1.1);


%% Make plot
xstart = 0.08;
width = 0.4;
height = 0.24;
dif = 0.06;
ystart = 0.68;
figure('Renderer', 'painters', 'Position', [5 5 500 250])
Pr_list = [1e2 Pr_list 1e6];
Ra_list = [1e8 Ra_list 1e8];

patch(Pr_list,Ra_list,'blue','EdgeColor','blue'), hold on
set(gca, 'Layer', 'top')
plot(Pr_zonal,Ra_zonal, '--r', 'LineWidth',2)
plot(Pr_nonzonal,Ra_nonzonal, '--green', 'LineWidth',2)
set(gca,'yscale', 'log')
set(gca,'xscale', 'log')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([1e5 1e6])
ylim([1.5e7 2.7e7])
xlabel('$Pr$','FontSize', LabelFS)
ylabel('$Ra$','FontSize', LabelFS)
% make text
text(1.2e5,2.4e7,'$E_{PD}$', 'FontSize', LabelFS, 'Color', 'green' )
text(1.4e5,2e7,'$E_{SB}$', 'FontSize', LabelFS, 'Color', 'r' )
text(2e5,2.3e7,'$US$', 'FontSize', LabelFS, 'Color', 'white' )
text(3.5e5,2.1e7,'$S$', 'FontSize', LabelFS )
xq = 6e5;
yq = 2.7e7;
arrow([xq yq],[6.9e5 2.55e7],5,'color','r')
text(xq,yq*1.05, '$q_4$', 'FontSize',LabelFS, 'Color','r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')

arrow([3e5 1.8e7],[1.05e5 1.57e7],5)
arrow([7e5 2e7],[7.5e5 2.5e7],5)

% make boxes
x1 = 0.35;
y1 = 0.23;
width = 0.28;
height = 0.25;
axes('Position',[x1 y1 width height])
box on
pcolor(Eigenfuntionpsi1);
shading flat
colormap('jet')
caxis([-max(max(abs(Eigenfuntionpsi1))) max(max(abs(Eigenfuntionpsi1)))])
xticks([])
yticks([])
axes('Position',[x1+width y1+height width height])
box on
pcolor(Eigenfuntionpsi2);
shading flat
colormap('jet')
caxis([-max(max(abs(Eigenfuntionpsi2))) max(max(abs(Eigenfuntionpsi2)))])
xticks([])
yticks([])

%export_fig([figpath 'LargeBlue.eps'], '-eps')
saveas(gcf,[figpath 'LargeBlue.eps'], 'epsc')