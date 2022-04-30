run SetUp.m
figure('Renderer', 'painters', 'Position', [5 5 800 500])
ax = gca;
ax.Position = [0 0 1 1];
set(gca,'visible','off'); % remove axis
elim = [1e1 1e9];
yt = [1e1 1e5 1e9];
yt2 = [1 10 100];
ychange = 0.00;
xchange = 0.02;%0.07;
xchange2 = 0;%0.03;
xstretch = 0.04;
%% Pr = 1, Ra = 2e6
PrS = 'Pr_1'; RaS = 'Ra_2e6'; ARS = 'AR_2';
kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
t = kenergy(:,1);
Ey = kenergy(:,5);
Ex = kenergy(:,6);
Ik = kenergy(:,4);

% get rid of transient
xlower = AllData.(ARS).(PrS).(RaS).ICT;
t = t(xlower:end);
Ey = Ey(xlower:end);
Ex = Ex(xlower:end);
Ik = Ik(xlower:end);

% Making sure everything is the same length
top = min([length(t) length(Ex) length(Ey) length(Ik)]);
t = t(1:top);
Ex = Ex(1:top);
Ey = Ey(1:top);
Ik = Ik(1:top);

% non-dim
kappa = AllData.(ARS).(PrS).(RaS).kappa;
Ex  = Ex*pi^2/kappa^2;
Ey  = Ey*pi^2/kappa^2;
t = t*kappa/pi^2;
Nut = 1 + pi*2*Ik/kappa;

plt = subplot(4,2,1);
plt.Position(1) = plt.Position(1) + xchange + xchange2;
plt.Position(4) = plt.Position(4) - ychange;
plt.Position(2) = plt.Position(2) - 3*ychange;
plt.Position(3) = plt.Position(3) + xstretch;
semilogy(t, Nut)
ylim([1 200])
xlim([2 2.5])
grid on
xticklabels({'' '' '' '' '' '' '' ''})
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xticks([2 2.25 2.5])
yticks(yt2)
ylabel('Nu$(t)$', 'FontSize', LabelFS)
text('String', 'Ra $= 2 \times 10^6$', 'Units', 'normalized','Position', [-0.33 -1.2] , 'FontSize', TitleFS, 'Rotation',90)
text('String', 'Pr $= 1$', 'Units', 'normalized','Position', [0.35 1.3] , 'FontSize', TitleFS)
%text('String', '{', 'Units', 'normalized','Position', [0.35 1.5] , 'FontSize', 100,'Rotation',90 )
plt = subplot(4,2,3);
plt.Position(1) = plt.Position(1) + xchange + xchange2;
plt.Position(4) = plt.Position(4) - ychange;
plt.Position(2) = plt.Position(2) - 2*ychange;
plt.Position(3) = plt.Position(3) + xstretch;
semilogy(t, Ex, 'DisplayName','$E_x$', 'Color', [0 0.5 0]), hold on, grid on
semilogy(t, Ey, 'r--','DisplayName','$E_y$'), hold off
xlim([2 2.5])
ylim(elim)
yticks(yt)
xticklabels({'' '' '' '' '' '' '' ''})
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xticks([2 2.25 2.5])
ylabel('Energy', 'FontSize', LabelFS)

%% Pr = 1, Ra = 2e8
PrS = 'Pr_1'; RaS = 'Ra_2e8'; ARS = 'AR_2';
kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
t = kenergy(:,1);
Ey = kenergy(:,5);
Ex = kenergy(:,6);
Ik = kenergy(:,4);

% get rid of transient
xlower = AllData.(ARS).(PrS).(RaS).ICT;
t = t(xlower:end);
Ey = Ey(xlower:end);
Ex = Ex(xlower:end);
Ik = Ik(xlower:end);

% Making sure everything is the same length
top = min([length(t) length(Ex) length(Ey) length(Ik)]);
t = t(1:top);
Ex = Ex(1:top);
Ey = Ey(1:top);
Ik = Ik(1:top);

% non-dim
kappa = AllData.(ARS).(PrS).(RaS).kappa;
Ex  = Ex*pi^2/kappa^2;
Ey  = Ey*pi^2/kappa^2;
t = t*kappa/pi^2;
Nut = 1 + pi*2*Ik/kappa;

plt = subplot(4,2,5);
plt.Position(4) = plt.Position(4) - ychange;
plt.Position(2) = plt.Position(2) - ychange;
plt.Position(1) = plt.Position(1) + xchange + xchange2;
plt.Position(3) = plt.Position(3) + xstretch;
semilogy(t, Nut), grid on
xticklabels({'' '' '' '' '' '' '' ''})
ylim([1 200])
xlim([0.5 1])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xticks([0.5 0.75 1])
yticks(yt2)
ylabel('Nu$(t)$', 'FontSize', LabelFS)
text('String', 'Ra $= 2 \times 10^8$', 'Units', 'normalized','Position', [-0.33 -1.2] , 'FontSize', TitleFS, 'Rotation',90)
plt = subplot(4,2,7);
plt.Position(1) = plt.Position(1) + xchange + xchange2;
plt.Position(4) = plt.Position(4) - ychange;
plt.Position(3) = plt.Position(3) + xstretch;
semilogy(t, Ex, 'DisplayName','$E_x$', 'Color', [0 0.5 0]), hold on, grid on
semilogy(t, Ey, 'r--','DisplayName','$E_y$'), hold off
xlim([0.5 1])
ylim(elim)
yticks(yt)
xticks([0.5 0.75 1])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('Energy', 'FontSize', LabelFS)
xlabel('$t/((\pi d)^2/\kappa)$', 'FontSize', LabelFS)

%% Pr = 10, Ra = 2e6
PrS = 'Pr_10'; RaS = 'Ra_2e6'; ARS = 'AR_2';
kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
t = kenergy(:,1);
Ey = kenergy(:,5);
Ex = kenergy(:,6);
Ik = kenergy(:,4);

% get rid of transient
xlower = AllData.(ARS).(PrS).(RaS).ICT;
t = t(xlower:end);
Ey = Ey(xlower:end);
Ex = Ex(xlower:end);
Ik = Ik(xlower:end);

% Making sure everything is the same length
top = min([length(t) length(Ex) length(Ey) length(Ik)]);
t = t(1:top);
Ex = Ex(1:top);
Ey = Ey(1:top);
Ik = Ik(1:top);

% non-dim
kappa = AllData.(ARS).(PrS).(RaS).kappa;
Ex  = Ex*pi^2/kappa^2;
Ey  = Ey*pi^2/kappa^2;
t = t*kappa/pi^2;
Nut = 1 + pi*2*Ik/kappa;

plt = subplot(4,2,2);
plt.Position(1) = plt.Position(1) + xchange2;
plt.Position(4) = plt.Position(4) - ychange;
plt.Position(2) = plt.Position(2) - 3*ychange;
plt.Position(3) = plt.Position(3) + xstretch;
semilogy(t, Nut)
xticklabels({'' '' '' '' '' '' '' ''})
xlim([0.05 0.1])
ylim([1 200])
xticks([1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100 200])
grid on
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xticks([0.05 0.075 0.1])
yticklabels({'' '' '' '' '' '' '' ''})
text('String', 'Pr $= 10$', 'Units', 'normalized','Position', [0.35 1.3] , 'FontSize', TitleFS)
plt = subplot(4,2,4);
plt.Position(1) = plt.Position(1) + xchange2;
plt.Position(4) = plt.Position(4) - ychange;
plt.Position(2) = plt.Position(2) - 2*ychange;
plt.Position(3) = plt.Position(3) + xstretch;
semilogy(t, Ex, 'DisplayName','$E_x$','Color', [0 0.5 0]), hold on, grid on
semilogy(t, Ey, 'r--','DisplayName','$E_y$'), hold off
xlim([0.05 0.1])
ylim(elim)
xticklabels({'' '' '' '' '' '' '' ''})
yticklabels({'' '' '' '' '' '' '' ''})
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xticks([0.05 0.075 0.1])

%% Pr = 10, Ra = 2e8
PrS = 'Pr_10'; RaS = 'Ra_2e8'; ARS = 'AR_2';
kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
t = kenergy(:,1);
Ey = kenergy(:,5);
Ex = kenergy(:,6);
Ik = kenergy(:,4);

% get rid of transient
xlower = AllData.(ARS).(PrS).(RaS).ICT;
t = t(xlower:end);
Ey = Ey(xlower:end);
Ex = Ex(xlower:end);
Ik = Ik(xlower:end);

% Making sure everything is the same length
top = min([length(t) length(Ex) length(Ey) length(Ik)]);
t = t(1:top);
Ex = Ex(1:top);
Ey = Ey(1:top);
Ik = Ik(1:top);

% non-dim
kappa = AllData.(ARS).(PrS).(RaS).kappa;
Ex  = Ex*pi^2/kappa^2;
Ey  = Ey*pi^2/kappa^2;
t = t*kappa/pi^2;
Nut = 1 + pi*2*Ik/kappa;

plt = subplot(4,2,6);
plt.Position(1) = plt.Position(1) + xchange2;
plt.Position(4) = plt.Position(4) - ychange;
plt.Position(2) = plt.Position(2) - ychange;
plt.Position(3) = plt.Position(3) + xstretch;
semilogy(t, Nut), grid on
xticklabels({'' '' '' '' '' '' '' ''})
xticks([0.05 0.075 0.1])
xlim([0.05 0.1])
ylim([1 200])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
yticklabels({'' '' '' '' '' '' '' ''})
plt = subplot(4,2,8);
plt.Position(1) = plt.Position(1) + xchange2;
plt.Position(4) = plt.Position(4) - ychange;
plt.Position(3) = plt.Position(3) + xstretch;
semilogy(t, Ex, 'DisplayName','$E_x$', 'Color', [0 0.5 0]), hold on, grid on
semilogy(t, Ey, 'r--','DisplayName','$E_y$'), hold off
ylim(elim)
xlim([0.05 0.1])
xticks([0.05 0.075 0.1])
yticklabels({'' '' '' '' '' '' '' ''})
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t/((\pi d)^2/\kappa)$', 'FontSize', LabelFS)



