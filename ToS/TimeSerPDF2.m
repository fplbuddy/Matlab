run SetUp.m
%% Getting data
TimeInterval = [100 3100];
%TimeInterval = [0 5];
N = 40; % Number of bins
AR = 1; Pr = 30; RaL = [1e5 6e5 9e5 2e6]; RaS = [];
run SomeInputStuff.m
for i=RaL
    RaS = [RaS RatoRaS(i)];
end
% Getting the signals and time
for i=RaS
    kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(i).path) '/Checks/kpsmodes1.txt']);
    urms = AllData.(ARS).(PrS).(i).urms;
    xlower = AllData.(ARS).(PrS).(i).ICT;
    Signals.(i).Signal =  kpsmodes1(:,2); Signals.(i).Signal = Signals.(i).Signal(xlower:end)/(pi*urms); % Also include non-dim here
    Signals.(i).Time =  kpsmodes1(:,1); Signals.(i).Time =  Signals.(i).Time(xlower:end)/(pi/urms); % Also include non-dim here
    % PDF
    [y,x] = hist(Signals.(i).Signal, N);
    L = (max(Signals.(i).Signal) - min(Signals.(i).Signal))/N;
    Signals.(i).PDFx = x;
    Signals.(i).PDFy = y/(L*length(Signals.(i).Signal));
end

%% Make Plot
stretch = -0.01;
moveup1 = 0.03;
moveup2 = -0.03;
moveleft = 0.04;
titdown = 0.80;
xlabelup = 0.8;
ylabelmove = -60;

figure('Renderer', 'painters', 'Position', [5 5 600 400])
hej = subplot(4,1,1);
hej.Position(4) = hej.Position(4) + stretch;
hej.Position(2) = hej.Position(2) + moveup1;
hej.Position(1) = hej.Position(1) + moveleft;
plot(Signals.Ra_1e5.Time,Signals.Ra_1e5.Signal, 'blue-')
xlim([TimeInterval(1) TimeInterval(1)+(TimeInterval(2)-TimeInterval(1))/10])
xticks([100 200 300 400])
xticklabels({'1000' '1100' '1200' '1300'})
title('Ra $ = 10^5$', 'Fontsize', TitleFS, 'FontWeight', 'bold')
ylabel({'$\widehat \psi_{0,1}$','$/(\pi du_{rms})$'}, 'Fontsize', LabelFS, 'FontWeight', 'bold')
xlabel({'$t/(\pi d/u_{rms})$'},'Fontsize', LabelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ax.Title.Position(2) = ax.Title.Position(2)*titdown;
ax.XLabel.Position(2) = ax.XLabel.Position(2)*(xlabelup-0.2);

hej = subplot(4,1,2);
hej.Position(4) = hej.Position(4) + stretch;
hej.Position(2) = hej.Position(2) + moveup2;
hej.Position(1) = hej.Position(1) + moveleft;
plot(Signals.Ra_6e5.Time,Signals.Ra_6e5.Signal, 'Color', [0 0.7 0.4])
xlim(TimeInterval)
ylim([-0.2 0.2])
xticks(TimeInterval(1):(TimeInterval(2)-TimeInterval(1))/3:TimeInterval(2))
xticklabels({'' '' '' ''})
title('Ra $ = 6 \times 10^5$', 'Fontsize', TitleFS, 'FontWeight', 'bold')
ylabel({'$\widehat \psi_{0,1}$','$/(\pi du_{rms})$'}, 'Fontsize', LabelFS, 'FontWeight', 'bold')
ax = gca;
ax.YAxis.FontSize = numFS;
ax.Title.Position(2) = ax.Title.Position(2)*titdown;
ax.YLabel.Position(1) = ax.YLabel.Position(1)+ylabelmove;

hej = subplot(4,1,3);
hej.Position(4) = hej.Position(4) + stretch;
hej.Position(2) = hej.Position(2) + moveup2;
hej.Position(1) = hej.Position(1) + moveleft;
plot(Signals.Ra_9e5.Time,Signals.Ra_9e5.Signal,'Color', [0 0.5 0])
xlim(TimeInterval)
ylim([-0.2 0.2])
xticks(TimeInterval(1):(TimeInterval(2)-TimeInterval(1))/3:TimeInterval(2))
xticklabels({'' '' '' ''})
title('Ra $ = 9 \times 10^5$', 'Fontsize', TitleFS, 'FontWeight', 'bold')
ylabel({'$\widehat \psi_{0,1}$','$/(\pi du_{rms})$'}, 'Fontsize', LabelFS, 'FontWeight', 'bold')
ax = gca;
ax.YAxis.FontSize = numFS;
ax.Title.Position(2) = ax.Title.Position(2)*titdown;
ax.YLabel.Position(1) = ax.YLabel.Position(1)+ylabelmove;

hej = subplot(4,1,4);
hej.Position(4) = hej.Position(4) + stretch;
hej.Position(2) = hej.Position(2) + moveup2;
hej.Position(1) = hej.Position(1) + moveleft;
plot(Signals.Ra_2e6.Time,Signals.Ra_2e6.Signal, 'red-')

xlim([TimeInterval(1)+200, TimeInterval(2)+200])
title('Ra $ = 2 \times 10^6$', 'Fontsize', TitleFS, 'FontWeight', 'bold')
ylabel({'$\widehat \psi_{0,1}$','$/(\pi du_{rms})$'}, 'Fontsize', LabelFS, 'FontWeight', 'bold')
xlabel({'$t/(\pi d/u_{rms})$'},'Fontsize', LabelFS)
xticks(TimeInterval(1)+200:(TimeInterval(2)-TimeInterval(1))/3:TimeInterval(2)+200)
xticklabels({'1000' '2000' '3000' '4000'})
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ax.Title.Position(2) = ax.Title.Position(2)/titdown;
ax.XLabel.Position(2) = ax.XLabel.Position(2)*xlabelup;
ax.YLabel.Position(1) = ax.YLabel.Position(1)+ylabelmove+50;
%%
figure('Renderer', 'painters', 'Position', [5 5 600 400])
scale = 0.04;
pos = get(gca, 'Position');
pos(2) = pos(2)+scale*pos(4);
pos(4) = (1-scale)*pos(4);
set(gca, 'Position', pos)
h1 = semilogy(Signals.Ra_1e5.PDFx,Signals.Ra_1e5.PDFy, 'blue-s', 'DisplayName','Ra $ = 10^5$'); hold on
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = semilogy(Signals.Ra_6e5.PDFx,Signals.Ra_6e5.PDFy, 'Color', [0.0 0.7 0.4], 'LineStyle','-', 'Marker', 'd', 'DisplayName','Ra $ = 6 \times 10^5$');
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = semilogy(Signals.Ra_9e5.PDFx,Signals.Ra_9e5.PDFy,'Color', [0 0.5 0],'LineStyle','-', 'Marker', 'o' , 'DisplayName','Ra $ = 9 \times 10^5$');
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = semilogy(Signals.Ra_2e6.PDFx,Signals.Ra_2e6.PDFy, 'red-h', 'DisplayName','Ra $ = 2 \times 10^6$');
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
legend('Location', 'northeast', 'FontSize', numFS); legend('boxoff')
ylabel('PDF', 'Fontsize', LabelFS, 'FontWeight', 'bold')
xlabel({'$\widehat \psi_{0,1}/(\pi du_{rms})$'}, 'Fontsize', LabelFS, 'FontWeight', 'bold')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([-0.25 0.25])
ylim([1e-1, 10^2])
%%
