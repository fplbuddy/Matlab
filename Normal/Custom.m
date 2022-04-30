FS = 20;
run Params.m
run SomeInputStuff.m
 %kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
%penergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/penergy.txt']);
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
% kpsmodes2 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes2.txt']);
% kpsmodes3 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes3.txt']);
% kthetamodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kthetamodes1.txt']);
% kthetamodes2 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kthetamodes2.txt']);
% kthetamodes3 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kthetamodes3.txt']);
%conv = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/conv.txt']);

%figure('Renderer', 'painters', 'Position', [5 5 540 200])
% signal = kpsmodes1(:,5);
% signal = diff(signal);
% semilogy(abs(signal) + 1e-20)
%plot(kenergy(:,1),kenergy(:,2), 'DisplayName', 'Energy'); hold on
plot(kpsmodes1(:,2), 'DisplayName', 'Ex');
%figure('Renderer', 'paintçers', 'Position', [5 5 540 200])
%plot(kenergy(:,5), 'DisplayName', 'Ey');
%plot(kpsmodes1(:,2), '-'), hold on

% plot(conv(:,1), conv(:,4))
xlabel('$t (s)$', 'FontSize', FS)
%ylabel('$\widehat \psi_{0,1}$', 'FontSize', FS')

ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;

%plot(kenergy(:,8))
%plot(kpsmodes1(:,1), kpsmodes1(:,2),'DisplayName', 'Psi(0,1)')
%semilogy(abs(kpsmodes1(:,2)),'DisplayName', 'Psi(0,1)')

% xlower = AllData.(ARS).(PrS).(RaS).ICT;
% top = kpsmodes1(:,2); bot = kenergy(:,2);
% top = top(xlower:end); bot = bot(xlower:end-3);
% plot(top.^2./bot)
% % 
% section = AllData.(ARS).(PrS).(RaS).calcs.neg{1};
% top = top(section); bot = bot(section);
% plot(top.^2./bot)
% % 
%  mean(top.^2./bot)

title(['$' AllData.(ARS).(PrS).(RaS).title '$'], 'FontSize',FS)
hold off
%clearvars -except AllData


