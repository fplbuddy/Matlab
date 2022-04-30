TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
%% Getting data
N = 400;
G = 2;
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(N)];
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
Pr = 1e-6;
Ra = 1e8;
PrS = PrtoPrS(Pr);
RaS = RatoRaS(Ra);
PsiE = Data.(AR).(type).(PrS).(RaS).PsiE;
ThetaE = Data.(AR).(type).(PrS).(RaS).ThetaE;

%% Calc
[~,~,n,m] = GetRemKeep_nxny(N,N,1);
Kenergy = zeros(N/2-1, N);
Penergy = zeros(N/2-1, N);
for i=1:length(n)
   ninst = n(i); minst = m(i);
    Kenergy(ninst+1, minst) = abs(PsiE(i))^2*(ninst*2*pi/G)^2*two(ninst);
    Penergy(ninst+1, minst) = abs(ThetaE(i))^2*two(ninst);       
end

%% Plot
% figure('Renderer', 'painters', 'Position', [5 5 400 300])
% pcolor(Kenergy');
% colormap('jet')
% colorbar
% %caxis([1e-5, max(max(Kenergy))])
% set(gca,'ColorScale','log')
% xlabel('$k_x$', 'FontSize', 16)
% ylabel('$k_y$', 'FontSize', 16)
% title({'Steady state with $Pr = 12$, $Ra = 3 \times 10^5$','$E(k)$'}, 'FontSize', 17)
% xlim([0 20])
% ylim([0 20])
%
figure('Renderer', 'painters', 'Position', [5 5 400 300])
pcolor(Penergy');
colormap('jet')
colorbar
caxis([1e-8, max(max(Penergy))])
set(gca,'ColorScale','log')
xlabel('$k_x$', 'FontSize', 16)
ylabel('$k_y$', 'FontSize', 16)
title({'SCRS with $Pr = 10^{-6}$, $Ra = 1 \times 10^8$','$|\widehat \theta_{k_x,k_y}|^2$'}, 'FontSize', 17)
xlim([1 20])
ylim([1 20])
xticks([1.5 3.5 5.5 7.5 9.5 11.5 13.5 15.5 17.5 19.5])
yticks([1.5 3.5 5.5 7.5 9.5 11.5 13.5 15.5 17.5 19.5])
yticklabels(["1" "3" "5" "7" "9" "11" "13" "15" "17" "19"])
xticklabels(["0" "2" "4" "6" "8" "10" "12" "14" "16" "18"])
%% Functions
function two = two(n)
    if n == 0
        two = 1;
    else
        two = 2;
    end
end