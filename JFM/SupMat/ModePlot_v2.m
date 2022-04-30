addpath('/Users/philipwinchester/Dropbox/Matlab/JFM')
run SetUp.m
% Get data and functions
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions';
addpath(fpath)
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
%load(dpath);
[Ra_listMaster,Pr_listMaster] = GetStabBoundary(Data);
G = 2;
AR = ['AR_' num2str(G)];
lw = 1;
q1 = 0.2;
q2 = 4.97;
q3 = 8.58;
q4 = 7e5;
%% Region 1
Pr_plot = [];
ZeroOne = [];
TwoOne = [];
OneTwo = [];
% 152,  0.2 <= Pr <= 1 ,3.34e5 < Ra <= 6e5
% do 152 now
N = 152;
type = ['OneOne' num2str(N)];
Pr_list = Pr_listMaster;
Ra_list = Ra_listMaster;
Pr_lim = [0.2 1];
Ra_lim = [3.34e5 6e5];
Pr_list(Ra_list > max(Ra_lim) | Ra_list <= min(Ra_lim)) = [];
Ra_list(Ra_list > max(Ra_lim) | Ra_list <= min(Ra_lim)) = [];
Ra_list(Pr_list > max(Pr_lim) | Pr_list < min(Pr_lim)) = [];
Pr_list(Pr_list > max(Pr_lim) | Pr_list < min(Pr_lim)) = [];
% setting up locations
if N == 152
    ZeroOneloc = 26;
    TwoOneloc = 27;
    OneTwoloc = 77;
else % 256
    ZeroOneloc = 43;
    TwoOneloc = 44;
    OneTwoloc = 129;
end
for i=1:length(Pr_list)
    Pr = Pr_list(i); Ra = Ra_list(i);
    PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
    try % try the actualt one first
        Eigv = Data.(AR).(type).(PrS).(RaS).Eigv;
        Pr_plot = [Pr_plot Pr];
        ZeroOne = [ZeroOne Eigv(ZeroOneloc)];
        TwoOne = [TwoOne Eigv(TwoOneloc)];
        OneTwo = [OneTwo Eigv(OneTwoloc)];
    catch % then the cloesest
        RaString = string(fieldnames(Data.(AR).(type).(PrS)));
        RaC = ClosestRa(Ra, RaString);
        Eigv = Data.(AR).(type).(PrS).(RaC).Eigv;
        Pr_plot = [Pr_plot Pr];
        ZeroOne = [ZeroOne Eigv(ZeroOneloc)];
        TwoOne = [TwoOne Eigv(TwoOneloc)];
        OneTwo = [OneTwo Eigv(OneTwoloc)];
    end
end
% 256,  0.2 <= Pr <= 8.58 ,6e5 < Ra <= 4e6, and remove when Pr start to go
% back
% do 256 now
N = 256;
type = ['OneOne' num2str(N)];
Pr_list = Pr_listMaster;
Ra_list = Ra_listMaster;
Pr_lim = [0.2 8.58];
Ra_lim = [4e6 6e5];
Pr_list(Ra_list > max(Ra_lim) | Ra_list <= min(Ra_lim)) = [];
Ra_list(Ra_list > max(Ra_lim) | Ra_list <= min(Ra_lim)) = [];
Ra_list(Pr_list > max(Pr_lim) | Pr_list < min(Pr_lim)) = [];
Pr_list(Pr_list > max(Pr_lim) | Pr_list < min(Pr_lim)) = [];
rem = find(Pr_list == 8.58, 1 );
Pr_list = Pr_list(1:rem);
Ra_list = Ra_list(1:rem);
% setting up locations
if N == 152
    ZeroOneloc = 26;
    TwoOneloc = 27;
    OneTwoloc = 77;
else % 256
    ZeroOneloc = 43;
    TwoOneloc = 44;
    OneTwoloc = 129;
end
for i=1:length(Pr_list)
    Pr = Pr_list(i); Ra = Ra_list(i);
    PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
    try % try the actualt one first
        Eigv = Data.(AR).(type).(PrS).(RaS).Eigv;
        Pr_plot = [Pr_plot Pr];
        ZeroOne = [ZeroOne Eigv(ZeroOneloc)];
        TwoOne = [TwoOne Eigv(TwoOneloc)];
        OneTwo = [OneTwo Eigv(OneTwoloc)];
    catch % then the cloesest
        try % remove this eventually
            Pr
            RaString = string(fieldnames(Data.(AR).(type).(PrS)));
            RaC = ClosestRa(Ra, RaString);
            Eigv = Data.(AR).(type).(PrS).(RaC).Eigv;
            Pr_plot = [Pr_plot Pr];
            ZeroOne = [ZeroOne Eigv(ZeroOneloc)];
            TwoOne = [TwoOne Eigv(TwoOneloc)];
            OneTwo = [OneTwo Eigv(OneTwoloc)];
        catch
        end
    end
end
% make plot
figure('Renderer', 'painters', 'Position', [5 5 900 200])
subplot(1,2,1)
semilogy(Pr_plot,abs(ZeroOne), 'LineWidth', lw,'DisplayName','$|\widehat \psi_{0,1}|$'), hold on
semilogy(Pr_plot,abs(TwoOne), 'LineWidth', lw,'DisplayName','$|\widehat \psi_{2,1}|$')
semilogy(Pr_plot,abs(OneTwo), 'LineWidth', lw,'DisplayName','$|\widehat \psi_{1,2}|$')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
lgnd = legend('Location', 'Best', 'FontSize',  numFS);
xlabel('$Pr$','FontSize', LabelFS)
title('$q_1 \to q_3$','FontSize', LabelFS)
ylim([1e-3 1])
yticks([1e-3 1e-2 1e-1 1])
xlim([q1 max(Pr_plot)])
xticks([q1 2 4 q2 6 8 q3])
xticklabels(["$q_1$" "2" "4" "$q_2$" "6" "8" "$q_3$"])
%% Region 3
Pr_plot = [];
ZeroOne = [];
TwoOne = [];
OneTwo = [];
% 152,  6.16 <= Pr <= 8.58 ,0 < Ra <= 6e5, start at second 6.16
% do 152 now
N = 152;
type = ['OneOne' num2str(N)];
Pr_list = Pr_listMaster;
Ra_list = Ra_listMaster;
Pr_lim = [6.16 8.58];
Ra_lim = [0 6e5];
Pr_list(Ra_list > max(Ra_lim) | Ra_list <= min(Ra_lim)) = [];
Ra_list(Ra_list > max(Ra_lim) | Ra_list <= min(Ra_lim)) = [];
Ra_list(Pr_list > max(Pr_lim) | Pr_list < min(Pr_lim)) = [];
Pr_list(Pr_list > max(Pr_lim) | Pr_list < min(Pr_lim)) = [];
rem = find(Pr_list == 6.16, 1 );
Pr_list = Pr_list(rem+1:end);
Ra_list = Ra_list(rem+1:end);
% setting up locations
if N == 152
    ZeroOneloc = 26;
    TwoOneloc = 27;
    OneTwoloc = 77;
else % 256
    ZeroOneloc = 43;
    TwoOneloc = 44;
    OneTwoloc = 129;
end
for i=1:length(Pr_list)
    Pr = Pr_list(i); Ra = Ra_list(i);
    PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
    try % try the actualt one first
        Eigv = Data.(AR).(type).(PrS).(RaS).Eigv;
        Pr_plot = [Pr_plot Pr];
        ZeroOne = [ZeroOne Eigv(ZeroOneloc)];
        TwoOne = [TwoOne Eigv(TwoOneloc)];
        OneTwo = [OneTwo Eigv(OneTwoloc)];
    catch % then the cloesest
        RaString = string(fieldnames(Data.(AR).(type).(PrS)));
        RaC = ClosestRa(Ra, RaString);
        Eigv = Data.(AR).(type).(PrS).(RaC).Eigv;
        Pr_plot = [Pr_plot Pr];
        ZeroOne = [ZeroOne Eigv(ZeroOneloc)];
        TwoOne = [TwoOne Eigv(TwoOneloc)];
        OneTwo = [OneTwo Eigv(OneTwoloc)];
    end
end
% 256,  10 <= Pr <= 1e5 ,6e5 < Ra <= 4e6, and remove when Pr start to go
% back
% do 256 now
N = 256;
type = ['OneOne' num2str(N)];
Pr_list = Pr_listMaster;
Ra_list = Ra_listMaster;
Pr_lim = [10 1e5];
Ra_lim = [4e6 6e5];
Pr_list(Ra_list > max(Ra_lim) | Ra_list <= min(Ra_lim)) = [];
Ra_list(Ra_list > max(Ra_lim) | Ra_list <= min(Ra_lim)) = [];
Ra_list(Pr_list > max(Pr_lim) | Pr_list < min(Pr_lim)) = [];
Pr_list(Pr_list > max(Pr_lim) | Pr_list < min(Pr_lim)) = [];
% setting up locations
if N == 152
    ZeroOneloc = 26;
    TwoOneloc = 27;
    OneTwoloc = 77;
else % 256
    ZeroOneloc = 43;
    TwoOneloc = 44;
    OneTwoloc = 129;
end
for i=1:length(Pr_list)
    Pr = Pr_list(i); Ra = Ra_list(i);
    PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
    try % try the actualt one first
        Eigv = Data.(AR).(type).(PrS).(RaS).Eigv;
        Pr_plot = [Pr_plot Pr];
        ZeroOne = [ZeroOne Eigv(ZeroOneloc)];
        TwoOne = [TwoOne Eigv(TwoOneloc)];
        OneTwo = [OneTwo Eigv(OneTwoloc)];
    catch % then the cloesest
        try % remove this eventually
            Pr
            RaString = string(fieldnames(Data.(AR).(type).(PrS)));
            RaC = ClosestRa(Ra, RaString);
            Eigv = Data.(AR).(type).(PrS).(RaC).Eigv;
            Pr_plot = [Pr_plot Pr];
            ZeroOne = [ZeroOne Eigv(ZeroOneloc)];
            TwoOne = [TwoOne Eigv(TwoOneloc)];
            OneTwo = [OneTwo Eigv(OneTwoloc)];
        catch
        end
    end
end
% add large res stuff, 1e4 and above I guess. Ra > 4e6. zonal until Pr >
% 7e5. Then non zonal
N = 400;
ZeroOneloc = 67;
TwoOneloc = 68;
OneTwoloc = 201;
type = ['OneOne' num2str(N)];
Pr_list = Pr_listMaster;
Ra_list = Ra_listMaster;
Pr_list(Ra_list <= 4e6) = [];
Ra_list(Ra_list <= 4e6) = [];
Ra_list(Pr_list==3e4) = []; % this one sits in 300
Pr_list(Pr_list==3e4) = [];
bound = find(Pr_list == 7e5, 1 );
for i=1:bound-1
    Pr = Pr_list(i); Ra = Ra_list(i);
    PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
    try % try exact Ra
        try % try eigv
            Eigv = Data.(AR).(type).(PrS).(RaS).Eigv;
            Pr_plot = [Pr_plot Pr];
            ZeroOne = [ZeroOne Eigv(ZeroOneloc)];
            TwoOne = [TwoOne Eigv(TwoOneloc)];
            OneTwo = [OneTwo Eigv(OneTwoloc)];
        catch
            Eigv = Data.(AR).(type).(PrS).(RaS).EigvZ;
            Pr_plot = [Pr_plot Pr];
            ZeroOne = [ZeroOne Eigv(ZeroOneloc)];
            TwoOne = [TwoOne Eigv(TwoOneloc)];
            OneTwo = [OneTwo Eigv(OneTwoloc)];
        end
    catch % try closerone
        RaString = string(fieldnames(Data.(AR).(type).(PrS)));
        RaC = ClosestRa(Ra, RaString);
        try % try eigv
            Eigv = Data.(AR).(type).(PrS).(RaC).Eigv;
            Pr_plot = [Pr_plot Pr];
            ZeroOne = [ZeroOne Eigv(ZeroOneloc)];
            TwoOne = [TwoOne Eigv(TwoOneloc)];
            OneTwo = [OneTwo Eigv(OneTwoloc)];
        catch
            try % remove eventually
                Eigv = Data.(AR).(type).(PrS).(RaC).EigvZ;
                Pr_plot = [Pr_plot Pr];
                ZeroOne = [ZeroOne Eigv(ZeroOneloc)];
                TwoOne = [TwoOne Eigv(TwoOneloc)];
                OneTwo = [OneTwo Eigv(OneTwoloc)];
            catch
            end
        end
    end
end
% add non-zonal
for i=bound:length(Pr_list)
    Pr = Pr_list(i); Ra = Ra_list(i);
    PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
    try % try exact Ra
        Eigv = Data.(AR).(type).(PrS).(RaS).EigvNZ;
        Pr_plot = [Pr_plot Pr];
        ZeroOne = [ZeroOne Eigv(ZeroOneloc)];
        TwoOne = [TwoOne Eigv(TwoOneloc)];
        OneTwo = [OneTwo Eigv(OneTwoloc)];
    catch % try closerone
        RaString = string(fieldnames(Data.(AR).(type).(PrS)));
        RaC = ClosestRa(Ra, RaString);
        try % remove eventually
            Eigv = Data.(AR).(type).(PrS).(RaC).EigvNZ;
            Pr_plot = [Pr_plot Pr];
            ZeroOne = [ZeroOne Eigv(ZeroOneloc)];
            TwoOne = [TwoOne Eigv(TwoOneloc)];
            OneTwo = [OneTwo Eigv(OneTwoloc)];
        catch
        end
    end
end
% add one final points
Pr_plot = [Pr_plot 10^6];
ZeroOne = [ZeroOne 0];
TwoOne = [TwoOne TwoOne(end)];
OneTwo = [OneTwo OneTwo(end)];

% make plot
subplot(1,2,2)
loglog(Pr_plot,abs(ZeroOne), 'LineWidth', lw,'DisplayName','$|\widehat \psi_{0,1}|$'), hold on
loglog(Pr_plot,abs(TwoOne), 'LineWidth', lw,'DisplayName','$|\widehat \psi_{2,1}|$')
loglog(Pr_plot,abs(OneTwo), 'LineWidth', lw,'DisplayName','$|\widehat \psi_{1,2}|$')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
%lgnd = legend('Location', 'Best', 'FontSize',  numFS);
xlabel('$Pr$','FontSize', LabelFS)
title('$p_4 \to Pr =10^6$','FontSize', LabelFS)
ylim([1e-3 1])
xlim([min(Pr_plot) 1e6])
yticklabels(["" "" "" ""])
xticks([1e1 1e2 1e3 1e4 1e5 q4])
xticklabels(["$10^1$" "$10^2$" "$10^3$" "$10^4$" "$10^5$" "$q_4$"])