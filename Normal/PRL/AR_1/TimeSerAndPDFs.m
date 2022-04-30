run SetUp.m
%% Getting data
TimeInterval = [0.5 2.5];
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
    xlower = AllData.(ARS).(PrS).(i).ICT;
    Signals.(i).Signal =  kpsmodes1(:,2); Signals.(i).Signal = Signals.(i).Signal(xlower:end)/AllData.(ARS).(PrS).(i).kappa; % Also include non-dim here
    Signals.(i).Time =  kpsmodes1(:,1); Signals.(i).Time =  Signals.(i).Time(xlower:end)*AllData.(ARS).(PrS).(i).kappa/pi^2; % Also include non-dim here
    % PDF
    [y,x] = hist(Signals.(i).Signal, N);
    L = (max(Signals.(i).Signal) - min(Signals.(i).Signal))/N;
    Signals.(i).PDFx = x;
    Signals.(i).PDFy = y/(L*length(Signals.(i).Signal));
end

%% Make Plot
FS1 = 14;
FS2 = 14; 

figure('Renderer', 'painters', 'Position', [5 5 400 400])
subplot(4,1,1)
plot(Signals.Ra_1e5.Time,Signals.Ra_1e5.Signal, 'blue-')
xlim([1 3])
set(gca,'xtick',[])
title('$Ra = 10^5$', 'Fontsize', FS1, 'FontWeight', 'bold')
ylabel('$\hat \psi_{0,1}$', 'Fontsize', FS1, 'FontWeight', 'bold')

subplot(4,1,2)
plot(Signals.Ra_6e5.Time,Signals.Ra_6e5.Signal, 'red-')
xlim(TimeInterval)
set(gca,'xtick',[])
title('$Ra = 6 \times 10^5$', 'Fontsize', FS1, 'FontWeight', 'bold')
ylabel('$\hat \psi_{0,1}$', 'Fontsize', FS1, 'FontWeight', 'bold')

subplot(4,1,3)
plot(Signals.Ra_9e5.Time,Signals.Ra_9e5.Signal,'m-')
xlim(TimeInterval)
set(gca,'xtick',[])
title('$Ra = 9 \times 10^5$', 'Fontsize', FS1, 'FontWeight', 'bold')
ylabel('$\hat \psi_{0,1}$', 'Fontsize', FS1, 'FontWeight', 'bold')

subplot(4,1,4)
plot(Signals.Ra_2e6.Time,Signals.Ra_2e6.Signal, 'black-')
xlim(TimeInterval)
title('$Ra = 2 \times 10^6$', 'Fontsize', FS1, 'FontWeight', 'bold')
ylabel('$\hat \psi_{0,1}$', 'Fontsize', FS1, 'FontWeight', 'bold')
xlabel({'$t$'}, 'FontWeight', 'bold','Fontsize', FS1)

figure('Renderer', 'painters', 'Position', [5 5 400 400])
scale = 0.04;
pos = get(gca, 'Position');
pos(2) = pos(2)+scale*pos(4);
pos(4) = (1-scale)*pos(4);
set(gca, 'Position', pos)
h1 = semilogy(Signals.Ra_1e5.PDFx,Signals.Ra_1e5.PDFy, 'blue-s', 'DisplayName','$Ra = 10^5$'); hold on
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = semilogy(Signals.Ra_6e5.PDFx,Signals.Ra_6e5.PDFy, 'red-d', 'DisplayName','$Ra = 6 \times 10^5$');
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = semilogy(Signals.Ra_9e5.PDFx,Signals.Ra_9e5.PDFy,'-mo', 'DisplayName','$Ra = 9 \times 10^5$');
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = semilogy(Signals.Ra_2e6.PDFx,Signals.Ra_2e6.PDFy, 'black-h', 'DisplayName','$Ra = 2 \times 10^6$');
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
legend('Location', 'northwest'); legend('boxoff')
ylabel('$P(\hat \psi_{0,1})$', 'Fontsize', FS2, 'FontWeight', 'bold')
xlabel({'$\hat \psi_{0,1}$'}, 'Fontsize', FS2, 'FontWeight', 'bold')
ylim([1e-4, 1])
%%
