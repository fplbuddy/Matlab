run SetUp.m
%% Getting data
AR = 2; Pr = 30; RaL = [2e6 4.5e6 6.4e6 9e6]; RaS = []; h = pi;
run SomeInputStuff.m
for i=RaL
    RaS = [RaS RatoRaS(i)];
end
% Getting the signals and time
for i=RaS
    kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(i).path) '/Checks/kpsmodes1.txt']);
    kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(i).path) '/Checks/kenergy.txt']);
    xlower = AllData.(ARS).(PrS).(i).ICT;
    % Calculating urms
    Ex = kenergy(:,6); Ex = Ex(xlower:end);
    Ey = kenergy(:,5); Ey = Ey(xlower:end);
    tE = kenergy(:,1); tE = tE(xlower:end);
    urms = 2*Ex+2*Ey;
    urms = MyMeanEasy(urms,tE); urms = urms^(1/2);
    Signals.(i).urms = urms;
    Signals.(i).Signal =  2*kpsmodes1(:,2); Signals.(i).Signal = Signals.(i).Signal(xlower:end); % dont non dime yet
    Signals.(i).Time =  kpsmodes1(:,1); Signals.(i).Time =  Signals.(i).Time(xlower:end); %/(h/urms); % Also include non-dim here
    % PDF
%     if isfield(AllData.(ARS).(PrS).(i).calcs,'PWW')
%         HistSignal = Signals.(i).Signal(AllData.(ARS).(PrS).(i).calcs.PWW);
%         if i == "Ra_6_4e6"
%             HistSignal = Signals.(i).Signal; % Use full time series for this one
%         end
%     else
%         HistSignal = Signals.(i).Signal;
%     end
%     if i == "Ra_3_6e6"
%         [x,y] = MyHist(HistSignal, AllData, ARS, PrS, i, 10, 15);
%     else
%         [x,y] = MyHist(HistSignal, AllData, ARS, PrS, i, 18, 25);
%     end
    HistSignal = Signals.(i).Signal;
    if i == "Ra_4_5e6"
       HistSignal = HistSignal(3.5e4:2.9e5);
    end
    
    [x,y] = MyHist(HistSignal, AllData, ARS, PrS, i, 18, 25);
    x = x/(h*urms); 
    Signals.(i).PDFx = x;
    Signals.(i).PDFy = y;
    %Signals.(i).Signal = Signals.(i).Signal/(h*urms); % non-dim here
    if i == "Ra_6_4e6"
        %kpsmodes1ext = importdata('/Volumes/Samsung_T5/Residue/Ra_6_4e6_ext/Checks/kpsmodes1.txt');
        kpsmodes1ext = importdata('/Users/philipwinchester/Documents/Data/Residue/Ra_6_4e6_ext/Checks/kpsmodes1.txt');
        Signalext = 2*kpsmodes1ext(:,2); text = kpsmodes1ext(:,1);
        Signals.(i).Signal = vertcat(Signals.(i).Signal, Signalext);
        Signals.(i).Time = vertcat(Signals.(i).Time, text);
    end
    % non-dim
    Signals.(i).Signal = Signals.(i).Signal/(h*urms);
    Signals.(i).Time = Signals.(i).Time/(h/urms);
    
    % Extend non-shearing ones
    if i == "Ra_2e6" || i == "Ra_9e6"
        tadd = Signals.(i).Time(1:end-1); tadd = flip(tadd); tadd = 2*Signals.(i).Time(end) - tadd;
        sadd = Signals.(i).Signal(1:end-1); sadd = flip(sadd);
        Signals.(i).Signal = [Signals.(i).Signal' sadd'];
        Signals.(i).Time = [Signals.(i).Time' tadd'];
    end  
end

%% Make Plot
HA = -0.01;
TC = 0.1;
LR = 0.01;
TimeInterval = [0 1.4e4];
figure('Renderer', 'painters', 'Position', [5 5 600 400])
hej = subplot(4,1,1);
hej.Position(4) = hej.Position(4) + HA;
hej.Position(1) = hej.Position(1) + LR;
plot(Signals.Ra_2e6.Time,Signals.Ra_2e6.Signal, 'blue-')
xlim(TimeInterval)
%xlim([0.001e4 1.001e4]) % Custom time
%set(gca,'xtick',[])
xticklabels({'' '' '' '' '' '' '' ''})
title('Ra $= 2 \times 10^6$', 'Fontsize', TitleFS, 'FontWeight', 'bold')
ylabel({'$\widehat \psi_{0,1}$','$/(\pi du_{rms})$'}, 'Fontsize', LabelFS, 'FontWeight', 'bold')
%xlim([Signals.Ra_2e6.Time(1), Signals.Ra_2e6.Time(end)])
%hp4 = get(gca,'title').Position;
%set(get(gca,'title'),'Position', [hp4(1)-0.7 hp4(2) hp4(3)])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ax.Title.Position(2) = ax.Title.Position(2) - TC;

hej = subplot(4,1,2);
hej.Position(4) = hej.Position(4) + HA;
hej.Position(1) = hej.Position(1) + LR;
plot(Signals.Ra_4_5e6.Time,Signals.Ra_4_5e6.Signal, 'Color', [0 0.7 0.4])
xlim(TimeInterval)
%xlim([Signals.Ra_3_6e6.Time(end)-1e4 Signals.Ra_3_6e6.Time(end)]) % Custom time
ylim([-0.5 0.5])
xticklabels({'' '' '' '' '' '' '' ''})
title('Ra $= 4.5 \times 10^6$', 'Fontsize', TitleFS, 'FontWeight', 'bold')
ylabel({'$\widehat \psi_{0,1}$','$/(\pi du_{rms})$'}, 'Fontsize', LabelFS, 'FontWeight', 'bold')
%xlim([Signals.Ra_4_5e6.Time(1), Signals.Ra_4_5e6.Time(end)])
%hp4 = get(gca,'title').Position;
%set(get(gca,'title'),'Position', [hp4(1)-0.7 hp4(2) hp4(3)])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ax.Title.Position(2) = ax.Title.Position(2) - TC;


hej = subplot(4,1,3);
hej.Position(4) = hej.Position(4) + HA;
hej.Position(1) = hej.Position(1) + LR;
plot(Signals.Ra_6_4e6.Time,Signals.Ra_6_4e6.Signal, 'Color', [0 0.5 0])
xlim([1.4e4 TimeInterval(end)+1.4e4 ])
%ylim([-10 10])
xticklabels({'' '' '' '' '' '' '' ''})
title('Ra $= 6.4 \times 10^6$', 'Fontsize', TitleFS, 'FontWeight', 'bold')
ylabel({'$\widehat \psi_{0,1}$','$/(\pi du_{rms})$'}, 'Fontsize', LabelFS, 'FontWeight', 'bold')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ax.Title.Position(2) = ax.Title.Position(2) - TC;
%xlim([Signals.Ra_6_4e6.Time(1), Signals.Ra_6_4e6.Time(end)])
%hp4 = get(gca,'title').Position;
%set(get(gca,'title'),'Position', [hp4(1)-0.7 hp4(2) hp4(3)])

hej = subplot(4,1,4);
hej.Position(4) = hej.Position(4) + HA;
hej.Position(1) = hej.Position(1) + LR;
plot(Signals.Ra_9e6.Time-Signals.Ra_9e6.Time(1),Signals.Ra_9e6.Signal, 'red-')
xlim(TimeInterval)
%xlim(TimeInterval) % Custom time
xticks(TimeInterval(1):2e3:TimeInterval(end))
xticklabels({'10000' '12000' '14000' '16000' '18000' '20000' '22000' '24000'})
title('Ra $= 9 \times 10^6$', 'Fontsize', TitleFS)
ylabel({'$\widehat \psi_{0,1}$','$/(\pi du_{rms})$'}, 'Fontsize', LabelFS, 'FontWeight', 'bold')
xlabel({'$t/(\pi d/u_{rms})$'},'Fontsize', LabelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ax.Title.Position(2) = ax.Title.Position(2) - TC*(2/10);
ax.XLabel.Position(2) = ax.XLabel.Position(2) + 0.01
%set(gca,'xtick',[])
%xlim([Signals.Ra_9e6.Time(1), Signals.Ra_9e6.Time(end)])
%ylim([-0.3 -0.1])
%yticks([-0.3 -0.1])
%yticklabels({'-0.3' '-0.1'})
%hp4 = get(gca,'title').Position;
%set(get(gca,'title'),'Position', [hp4(1)-0.7 hp4(2) hp4(3)])

%hp4 = get(subplot(4,1,4),'Position');
%set(get(gca,'Position'), 'Position', [hp4(1) hp4(2) hp4(3) hp4(4)])

%%
figure('Renderer', 'painters', 'Position', [5 5 600 400])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
% scale = 0.04;
% pos = get(gca, 'Position');
% pos(2) = pos(2)+scale*pos(4);
% pos(4) = (1-scale)*pos(4);
% set(gca, 'Position', pos)
h1 = semilogy(Signals.Ra_2e6.PDFx,Signals.Ra_2e6.PDFy, 'blue-s', 'DisplayName','Ra = $2 \times 10^6$'); hold on
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = semilogy(Signals.Ra_4_5e6.PDFx,Signals.Ra_4_5e6.PDFy, 'Color', [0.0 0.7 0.4], 'LineStyle','-', 'Marker', 'd','DisplayName','Ra $= 4.5 \times 10^6$');
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = semilogy(Signals.Ra_6_4e6.PDFx,Signals.Ra_6_4e6.PDFy, 'Color', [0 0.5 0],'LineStyle','-', 'Marker', 'o' ,'DisplayName','Ra $= 6.4 \times 10^6$');
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = semilogy(Signals.Ra_9e6.PDFx,Signals.Ra_9e6.PDFy, 'red-h', 'DisplayName','Ra $= 9 \times 10^6$');
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
legend('Location', 'northeast', 'FontSize', lgndFS); legend('boxoff')
ylabel('PDF', 'Fontsize', LabelFS, 'FontWeight', 'bold')
xlabel({'$\widehat \psi_{0,1}/(\pi du_{rms})$'}, 'Fontsize', LabelFS, 'FontWeight', 'bold')
ylim([5e-2, 3e1])
xlim([-0.5 0.5])
xticks([-0.5 -0.25 0 0.25 0.5 ])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
%clearvars -except AllData
%% Residual calcs
%[x,y] = MyHist(signal, AllData, "AR_2", "Pr_30", "Ra_3_6e6", 18, 25);
%semilogy(x,y)
ARS = "AR_2"; PrS = "Pr_30"; RaS = "Ra_9e6";
xlower = AllData.(ARS).(PrS).(RaS).ICT;
Shearing = [AllData.(ARS).(PrS).(RaS).calcs.pos AllData.(ARS).(PrS).(RaS).calcs.neg];
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
top = kpsmodes1(:,2); bot = kenergy(:,2);
top = top(xlower:end); bot = bot(xlower:length(top)+xlower-1);
Thing = top.^2./bot;

section = [];
for j=1:length(Shearing)
    section = [section Shearing{j}];
end
mean(Thing(section))

