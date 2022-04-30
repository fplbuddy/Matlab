pathcheck = '/Volumes/Samsung_T5/CheckJmax/check';
RB1 = '/Volumes/Samsung_T5/CheckJmax/RBC2D_v2.14';
RB2 = '/Volumes/Samsung_T5/CheckJmax/RBC2D_v2.14_2';
FS = 20;

%% check - RB1
figure('Renderer', 'painters', 'Position', [5 5 800 350])
kenergycheck = importdata([pathcheck '/Checks/kenergy.txt']); kenergycheck = kenergycheck(1:10001,1:8);
kenergyRB1 = importdata([RB1 '/Checks/kenergy.txt']);

Echeck = kenergycheck(:,2);
ERB1 = kenergyRB1(:,2);
semilogy(abs(Echeck-ERB1), 'DisplayName', 'abs(old1 - new)'), hold on

%% RB2 - RB1
kenergyRB2 = importdata([RB2 '/Checks/kenergy.txt']);
ERB2 = kenergyRB2(:,2);
semilogy(abs(ERB2-ERB1),'DisplayName', 'abs(old1 - old2)')
xlim([0 1000])
legend('Location', 'Best', 'FontSize', FS)
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
xlabel('Steps/500','FontSize', FS )
title('Difference in total kinetic energy between runs', 'FontSize', FS)

%%
% semilogy(abs(ERB2-Echeck))
%
%
% %%
% kpsmodes1check = importdata([pathcheck '/Checks/kpsmodes1.txt']);
% plot(kpsmodes1check(:,2))
%
% kpsmodes1RB1 = importdata([RB1 '/Checks/kpsmodes1.txt']);
% plot(kpsmodes1RB1(:,2))





