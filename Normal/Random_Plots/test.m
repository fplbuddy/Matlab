run Params.m
run SomeInputStuff.m
%kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
% penergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/penergy.txt']);
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
%kpsmodes2 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes2.txt']);
%kpsmodes3 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes3.txt']);
% kthetamodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kthetamodes1.txt']);
% kthetamodes2 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kthetamodes2.txt']);
% kthetamodes3 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kthetamodes3.txt']);
conv = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/conv.txt']);
%%
figure(), hold on
subplot(1,2,2)
plot(kpsmodes1(:,1), kpsmodes1(:,2));
xlim([1e4, 1.01e4])
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
xlabel('$t$', 'FontSize', 25)
subplot(1,2,1)
plot(kpsmodes1(:,1), kpsmodes1(:,2));
xlim([0, 400])
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
ylabel('$\widehat \psi_{0,1}$', 'FontSize', 25)
xlabel('$t$', 'FontSize', 25)
sgtitle('Pr = 8, Ra = $4 \times 10^6$', 'FontSize',25)
%%
figure(), hold on
subplot(1,2,2)
plot(kpsmodes1(:,1), 2*kpsmodes1(:,5));
xlim([0, 1.01e4])
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
xlabel('$t$', 'FontSize', 25)
subplot(1,2,1)
plot(kpsmodes1(:,1), 2*kpsmodes1(:,5));
xlim([0, 400])
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
ylabel('$\widehat \psi_{1,1}$', 'FontSize', 25)
xlabel('$t$', 'FontSize', 25)
sgtitle('Pr = 8, Ra = $4 \times 10^6$', 'FontSize',25)