path = '/Volumes/Samsung_T5/EO_Decomp/256x256/AR_2/Pr_1/Ra_2e6/';
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
%% Plotting eo energy psi
kenergy = importdata([path 'Checks/kenergy.txt']);
Ee = kenergy(:,7);
Eo = kenergy(:,8);
t = kenergy(:,1);

figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(t, Ee, 'DisplayName', '$E_e$'), hold on
plot(t, Eo, 'DisplayName', '$E_o$'), hold off
legend('Location', 'bestoutside', 'FontSize', 14)
xlabel('$t$ $(s)$', 'FontSize', 14)
ylabel('$E$', 'FontSize', 14)
title('$Pr = 1, Ra = 2 \times 10^6$', 'FontSize', 15)
xlim([2.9e4 3.1e4])

%% Plotting mode
kpsmodes1 = importdata([path 'Checks/kpsmodes1.txt']);
s = kpsmodes1(:,2);
t = kpsmodes1(:,1);

figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(t,s)
xlabel('$t$ $(s)$', 'FontSize', 14)
ylabel('$\hat \psi_{0,1}$', 'FontSize', 14)
title('$Pr = 1, Ra = 2 \times 10^6$', 'FontSize', 15)
xlim([2.9e4 3.1e4])