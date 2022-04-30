Pr_list2 = [3 5 10 30 50 100 150 200 250 300];
data = GetExpAndPF(Pr_list2, 2, AllData);
AE = data.AE;
Ay = data.Ay;
aE = data.aE;
ay = data.ay;
ax = data.ax;
Ax = data.Ax;
% Setting up figures
figure(1); % Will plot Ey here
set(gcf, 'Position',  [5 5 540 200])
figure(2); % Will plot E here
set(gcf, 'Position',  [5 5 540 200])
figure(3); % Will plot Ex here
set(gcf, 'Position',  [5 5 540 200])

for i=1:length(Pr_list2)
    Pr = Pr_list2(i);
    EShearing= data.(['Pr_' num2str(Pr)]).EShearing;
    Ra = data.(['Pr_' num2str(Pr)]).Ra;
    EyShearing = data.(['Pr_' num2str(Pr)]).EyShearing;
    ExShearing = data.(['Pr_' num2str(Pr)]).ExShearing;
    % Now we change E and Ey to how we want them
    F = Ay(i);
    f = ay(i);
    G = AE(i);
    g = aE(i);
    H = Ax(i);
    h = ax(i);
    EShearing = (EShearing./G).^(1/g);
    EyShearing = (EyShearing./F).^(1/f);
    ExShearing = (ExShearing./H).^(1/h);
    % Plot
    figure(1)
    loglog(Ra, EyShearing, '*', 'DisplayName', num2str(Pr)); hold on
    figure(2)
    loglog(Ra, EShearing, '*', 'DisplayName', num2str(Pr)); hold on
    figure(3)
    loglog(Ra, ExShearing, '*', 'DisplayName', num2str(Pr)); hold on
end  
% Ey
figure(1)
xlabel('$Ra$', 'FontSize',13)
ylabel('$\Big (  \frac{E_y}{F} \Big )^{1/f}$', 'FontSize',20)
lgnd = legend('Location', 'BestOutside'); title(lgnd,'$Pr$');
hold off
% E
figure(2)
xlabel('$Ra$', 'FontSize',13)
ylabel('$\Big (  \frac{E}{G} \Big )^{1/g}$', 'FontSize',20)
lgnd = legend('Location', 'BestOutside'); title(lgnd,'$Pr$');
hold off
% Ex
figure(3)
xlabel('$Ra$', 'FontSize',13)
ylabel('$\Big (  \frac{E_x}{H} \Big )^{1/h}$', 'FontSize',20)
lgnd = legend('Location', 'BestOutside'); title(lgnd,'$Pr$');
hold off
clearvars -except AllData