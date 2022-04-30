TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
%%
n = [(-N/2+1):2:(N/2-1) (-N/2):2:(N/2-2)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2); m = m(1,:);
N = 64;
G = 2;
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(N)];
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Cluster_v2/Functions/';
addpath(fpath)
Pr = 12;
Ra = 3e5;
PrS = PrtoPrS(Pr);
RaS = RatoRaS(Ra);
eveneigf = Data.(AR).(type).(PrS).(RaS).eveneigf;
Psif = eveneigf(1:length(eveneigf)/2);
Thetaf = eveneigf(length(eveneigf)/2+1:end);

%% Calc
Kenergy = zeros(N/2-1, N);
Penergy = zeros(N/2-1, N);
for i=1:length(n)
    ninst = n(i); minst = m(i);
    if ninst >= 0
    Kenergy(ninst+1, minst) = abs(Psif(i))^2*(ninst*2*pi/G)^2*two(ninst);
    Penergy(ninst+1, minst) = abs(Thetaf(i))^2*two(ninst); 
    end
end

%% Plot
figure('Renderer', 'painters', 'Position', [5 5 400 300])
pcolor(Kenergy');
colormap('jet')
colorbar
caxis([1e-7, max(max(Kenergy))])
set(gca,'ColorScale','log')
xlabel('$k_x$', 'FontSize', 16)
ylabel('$k_y$', 'FontSize', 16)
title({'Most unstable even eigenfunction with', '$Pr = 12$, $Ra = 3 \times 10^5$','$E(k)$'}, 'FontSize', 17)
%
figure('Renderer', 'painters', 'Position', [5 5 400 300])
pcolor(Penergy');
colormap('jet')
colorbar
caxis([1e-10, max(max(Penergy))])
set(gca,'ColorScale','log')
xlabel('$k_x$', 'FontSize', 16)
ylabel('$k_y$', 'FontSize', 16)
title({'Most unstable even eigenfunction with', '$Pr = 12$, $Ra = 3 \times 10^5$','$E^{\theta}(k)$'}, 'FontSize', 17)
%%
function two = two(n)
    if n == 0
        two = 1;
    else
        two = 2;
    end
end