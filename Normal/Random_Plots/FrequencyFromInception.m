AR = 2; Pr = 30;
run SomeInputStuff.m
RaC = 4.77e4; RaMax = 6e4;
FreqList = []; RaList = [];
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
for i=1:length(Ra_list)
    if (AllData.(ARS).(PrS).(Ra_list(i)).Ra <= RaMax && AllData.(ARS).(PrS).(Ra_list(i)).Ra > RaC)
        RaList = [AllData.(ARS).(PrS).(Ra_list(i)).Ra RaList];
        kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(Ra_list(i)).path) '/Checks/kpsmodes1.txt']);
        Signal = kpsmodes1(:,2); t = kpsmodes1(:,1);
        % Get rid of transient
        xlower = AllData.(ARS).(PrS).(Ra_list(i)).ICT;
        Signal = Signal(xlower:end); t = t(xlower:end);
        % Find Frequency
        L = length(Signal);
        tdiff = diff(t);
        T = mean(tdiff);
        Fs = 1/T;
        Y = fft(Signal);
        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        [M, I] = max(P1);
        f = Fs*(0:(L/2))/L;
        Freq = f(I);
        % Adding to list
        FreqList = [Freq FreqList];
    end
end
% Finding difference
RaList = RaList - RaC;
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(RaList,FreqList,'*'), hold on
xlabel('$Ra - Ra_c$', 'FontSize',14)
ylabel('$\hat \psi_{0,1}$, Frequency, $F$, (Hz)', 'FontSize',14)
title(['$Pr =' num2str(Pr) '$'], 'FontSize',15)
% Fit data
% [alpha, A, xFitted, yFitted, Rval] = FitsLinear(RaList,FreqList);
% plot(xFitted, yFitted, 'black--' )
% gtext(['$F= A ' num2str(alpha,3) '(Ra - Ra_c)$'],'FontSize',14,'color', 'black')
clearvars -except AllData










%% Old version
AR = 2; Pr = 30;
run SomeInputStuff.m
RaC = 4.77e4; RaMax = 6e4;
PeriodList = []; RaList = [];
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
for i=1:length(Ra_list)
    if (AllData.(ARS).(PrS).(Ra_list(i)).Ra <= RaMax && AllData.(ARS).(PrS).(Ra_list(i)).Ra > RaC)
        RaList = [AllData.(ARS).(PrS).(Ra_list(i)).Ra RaList];
        kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(Ra_list(i)).path) '/Checks/kpsmodes1.txt']);
        Signal = kpsmodes1(:,2); t = kpsmodes1(:,1);
        % Get rid of transient
        xlower = AllData.(ARS).(PrS).(Ra_list(i)).ICT;
        Signal = Signal(xlower:end); t = t(xlower:end);
        % Find period
        zeros = zerosindex(Signal);
        TimeOfZeros = t(zeros);
        TBZ = diff(TimeOfZeros);
        Period = 2*sum(TBZ)/length(TBZ);
        % Adding to list
        PeriodList = [Period PeriodList];
    end
end
% Finding difference
RaList = RaList - RaC;
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(RaList,PeriodList.^(-1),'*'), hold on
xlabel('$Ra - Ra_c$', 'FontSize',14)
ylabel('$\hat \psi_{0,1}$, Frequency, $F$, (Hz)', 'FontSize',14)
title(['$Pr =' num2str(Pr) '$'], 'FontSize',15)
% Fit data
% [alpha, A, xFitted, yFitted, Rval] = FitsLinear(RaList,PeriodList.^(-1));
% plot(xFitted, yFitted, 'black--' )
% gtext(['$F= A ' num2str(alpha,3) '(Ra - Ra_c)$'],'FontSize',14,'color', 'black')
clearvars -except AllData