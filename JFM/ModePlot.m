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


%% Make plot
G  = 2;
N = 400;
figure('Renderer', 'painters', 'Position', [5 5 600 250])
n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
I = find(n<0);
n = [0:2:(N/2-1) 1:2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/4);
[~,~,n,m] = GetRemGeneral(n,m,N);
zonal = find(n == 0);
K2 = ((2*pi/G)*n').^2 + (pi*m').^2;
fact = 4*ones(length(n),1);
fact(find(n) == 0) = 2;
Ra_list(Pr_list > 7e5) = [];
Pr_list(Pr_list > 7e5) = [];
Ra_list(Pr_list < 1e5) = [];
Pr_list(Pr_list < 1e5) = [];
Ra_list(Pr_list == 2e5) = [];
Pr_list(Pr_list == 2e5) = [];
Ra_list(Pr_list == 3e5) = [];
Pr_list(Pr_list == 3e5) = [];
Ra_list(Pr_list == 4e5) = [];
Pr_list(Pr_list == 4e5) = [];
Ra_list(Pr_list == 5e5) = [];
Pr_list(Pr_list == 5e5) = [];
Ra_list(Pr_list == 6.9e5) = [];
Pr_list(Pr_list == 6.9e5) = [];
% some random additions
Pr_list = [Pr_list 1e4 2e4 3e4 6e4 3e5 7.2e5 1e6]; 
Ra_list = [Ra_list 4.24e6 7e6 8.62e6 1.25e7 2.2e7 2.56e7 2.6e7]; % The one for Pr = 1e6 is not strickt right... will remove if needed


energy_list = zeros(length(Pr_list),1);
for i=1:length(energy_list)
    Pr = Pr_list(i); PrS = PrtoPrS(Pr);
    Ra = Ra_list(i); RaS = RatoRaS(Ra);
    if isfield(Data.AR_2.OneOne400.(PrS).(RaS), "Eigv")
        Eigv = Data.AR_2.OneOne400.(PrS).(RaS).Eigv;
    else
        if Pr == 6.9e5
            RaS = "Ra_2_54e7";
        end
        if Pr == 7e5
            RaS = "Ra_2_55e7";
        end
        Eigv = Data.AR_2.OneOne400.(PrS).(RaS).EigvZ;
    end
    PsiV = Eigv(1:length(Eigv)/2);
    PsiV(I) = [];
    phase = -angle(Eigv(1));
    energy = K2.*fact.*(real(PsiV*exp(1i*phase))).^2;
    energy_list(i) = sum(energy(zonal))/sum(energy);
end
%% above is what I had before. I guess it does also catch 2e4, 3e4 and 3e5? Now will add the rest
Pr_list2 = [10 20 30 60 1e2 2e2 3e2 6e2 1e3 2e3 3e3 6e3];
for i=1:length(Pr_list2)
    Pr = Pr_list2(i); PrS = PrtoPrS(Pr);
    if Pr <= 600
        N = 152;
    else
        N = 256;
    end
    % some set-up i need
    n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
    m = 1:N; m = repelem(m, N/2);
    [~,~,n,~] = GetRemGeneral(n,m,N);
    I = find(n<0);
    n = [0:2:(N/2-1) 1:2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
    m = 1:N; m = repelem(m, N/4);
    [~,~,n,m] = GetRemGeneral(n,m,N);
    zonal = find(n == 0);
    K2 = ((2*pi/G)*n').^2 + (pi*m').^2;
    fact = 4*ones(length(n),1);
    fact(find(n) == 0) = 2;
    % now we find the right Ra
    type = ['OneOne' num2str(N)];
    M = GetFullM(Data, PrS, AR,type);
    [Done,Ra] = GetNextRa2(M, "NonLinear",3);
    RaS = RatoRaS(Ra);
    Eigv = Data.AR_2.(type).(PrS).(RaS).Eigv;
    PsiV = Eigv(1:length(Eigv)/2);
    PsiV(I) = [];
    phase = -angle(Eigv(1));
    energy = K2.*fact.*(real(PsiV*exp(1i*phase))).^2;
    energy_list2(i) = sum(energy(zonal))/sum(energy);
end
%% combine
Pr_list = [Pr_list Pr_list2];
energy_list = [energy_list; energy_list2'];
[Pr_list,I] = sort(Pr_list);
energy_list = energy_list(I);

loglog(Pr_list, energy_list, '*'), hold on
% plot power law
% [alpha, ~, ~, ~, ~] = FitsPowerLaw(Pr_list,energy_list); 
% % looks like alpha is approx -1.25
% alpha = -1.25;
% y1 = 1e-2; x1 = 1e2; A = y1/x1^alpha;
% x2 = 1e4; y2 = A*x2^alpha;
% plot([x1 x2], [y1 y2], '--k')
yticks([1e-6 1e-4 1e-2 1])


ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$Pr$','FontSize', LabelFS)
title('$\frac{\sum_{k_y = 0} K_{k_x,k_y}^2|\widehat \psi_{k_x,k_y}|^2}{\sum K_{k_x,k_y}^2|\widehat \psi_{k_x,k_y}|^2}$, $E_{SB}$', 'FontSize', LabelFS)
%ylabel('$Ra$','FontSize', LabelFS)
% make text

saveas(gcf,[figpath 'ZonalEnergy.eps'], 'epsc')