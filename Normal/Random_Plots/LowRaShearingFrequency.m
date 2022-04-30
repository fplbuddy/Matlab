AR = 2; Pr = 1; 
run SomeInputStuff.m
RaMin = 1.744e4; RaMax = 9e4;
PeriodList1 = []; RaList = []; ZeroOneEnergy = []; 
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
for i=1:length(Ra_list)
    if (AllData.(ARS).(PrS).(Ra_list(i)).Ra <= RaMax && AllData.(ARS).(PrS).(Ra_list(i)).Ra >= RaMin)
        RaList = [AllData.(ARS).(PrS).(Ra_list(i)).Ra RaList];
        kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(Ra_list(i)).path) '/Checks/kpsmodes1.txt']);
        Signal = kpsmodes1(:,3); t = kpsmodes1(:,1); 
        % Get rid of transient
        xlower = AllData.(ARS).(PrS).(Ra_list(i)).ICT;
        Signal = Signal(xlower:end); t = t(xlower:end);
        % Find period 1
        zeros = zerosindex(Signal);
        TimeOfZeros = t(zeros);
        TBZ = diff(TimeOfZeros);
        Period = 2*sum(TBZ)/length(TBZ);
        % Adding to list
        PeriodList = [Period PeriodList];
        % Find period 2
        zeros = zerosindex(Signal);
        TimeOfZeros = t(zeros);
        TBZ = diff(TimeOfZeros);
        Period = 2*sum(TBZ)/length(TBZ);
        % Adding to list
        PeriodList = [Period PeriodList];
        % Finding averge enery held in (0,1) mode
        Signal = kpsmodes1(:,2); Signal = Signal(xlower:end);
        av = MyMeanEasy(Signal,t);
        ZeroOneEnergy = [av^2 ZeroOneEnergy];
    end
end
% Finding difference
%RaList = RaList - RaC;

% Sorting
[RaList, I] = sort(RaList);
ZeroOneEnergy = ZeroOneEnergy(I); PeriodList = PeriodList(I);

cmap = colormap(winter(length(RaList))); close
figure('Renderer', 'painters', 'Position', [5 5 540 250]), hold on
for i=1:length(RaList)
    plot(ZeroOneEnergy(i), PeriodList(i),'*','Color',cmap((length(RaList)-i+1),:), 'DisplayName', num2str(RaList(i)))
end
set(gca, 'xscale', 'log'), set(gca, 'yscale', 'log'), 
ylabel({'Period of oscillations';'in $Re(\hat \psi_{1,1})$'}, 'FontSize', 14)
xlabel('Energy held in $\hat \psi_{0,1}$', 'FontSize',14)
title(['$Pr =' num2str(Pr) '$'], 'FontSize',15)
xlim([1e-1, 4e-1])
lgnd = legend('Location', 'BestOutside'); title(lgnd,'$Ra$')
% Fit data
[alpha, A, xFitted, yFitted, Rval] = FitsPowerLaw(ZeroOneEnergy,PeriodList);
plot(xFitted, yFitted, 'black--' )
gtext(['Period $\propto$ Energy$^{' num2str(alpha,3) '}$'],'FontSize',16,'color', 'black')
%clearvars -except AllData