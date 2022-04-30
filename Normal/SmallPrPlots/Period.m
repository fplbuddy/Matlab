AR = 2; Pr = 0.01;
run SomeInputStuff.m
Ram = 1e3;
RaS_list = string(fieldnames(AllData.(ARS).(PrS)));
figsave = '/Users/philipwinchester/Desktop/Figs/';
FS = 20;
figure('Renderer', 'painters', 'Position', [5 5 540 200])
mm = 10;
m_list = [];
RaA_list = [];
MS = 10;
RaC = 8*pi^4; % might want this to be where the instability actually happens?
for i=1:length(RaS_list)
    if (AllData.(ARS).(PrS).(RaS_list(i)).Ra > Ram)
        Ra = RaStoRa((RaS_list(i)));
        RaA = Ra - RaC;
        kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS_list(i)).path) '/Checks/kpsmodes1.txt']);
        xlower = AllData.(ARS).(PrS).(RaS_list(i)).ICT;
        ZeroOne = kpsmodes1(:,2); ZeroOne = ZeroOne(xlower:end);
        t = kpsmodes1(:,1); t = t(xlower:end);
        kappa = AllData.(ARS).(PrS).(RaS_list(i)).kappa;
        ZeroOne = abs(ZeroOne)/kappa;
        t = t/(pi^2/kappa);
        ZeroOne(ZeroOne < 1) = 0;
        ZeroOne = movmean(ZeroOne,mm);
        [~,locs] = findpeaks(ZeroOne);
        peaksloct = t(locs);
        m = diff(peaksloct); m = mean(m);
        % collectiing data
        m_list = [m_list m];
        RaA_list = [RaA_list RaA];
        %
        plot(t,ZeroOne), hold on
        plot(t(locs),ZeroOne(locs),'*r' ), hold off
        pause
        close
    end
end
figure('Renderer', 'painters', 'Position', [5 5 600 250])
plot(RaA_list,m_list, '*', 'MarkerSize', MS)
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
xticks([2000 4000 6000 8000 10000])
ylabel('Period', 'FontSize', FS)
xlabel('$\delta$Ra = Ra - Ra$_c$', 'FontSize', FS)

saveas(gcf,[figsave 'Period.eps'], 'epsc')