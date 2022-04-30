AR = 2; Pr = 0.01;
run SomeInputStuff.m
RaC = 7.86e2; RaMax = 6e4;
AmpList = []; RaList = [];
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
for i=1:length(Ra_list)
    if (AllData.(ARS).(PrS).(Ra_list(i)).Ra <= RaMax && AllData.(ARS).(PrS).(Ra_list(i)).Ra > RaC)
        RaList = [AllData.(ARS).(PrS).(Ra_list(i)).Ra RaList];
        kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(Ra_list(i)).path) '/Checks/kpsmodes1.txt']);
        Signal = kpsmodes1(:,2); % Dont need to consider transient here as we just look at last hump
        % Find last hump
        pks = findpeaks(abs(Signal)); % Abs so we catch minima as well
        % Adding to list
        AmpList = [pks(end) AmpList];
    end
end
% Finding difference
RaList = RaList - RaC;
figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(RaList,AmpList,'*'), hold on
xlabel('$Ra - Ra_c$', 'FontSize',14)
ylabel('$\hat \psi_{0,1}$, Amplitude', 'FontSize',14)
title(['$Pr =' num2str(Pr) '$'], 'FontSize',15)
% Fit data
[alpha, A, xFitted, yFitted, Rval] = FitsPowerLaw(RaList,AmpList);
plot(xFitted, yFitted, 'black--' )
gtext(['$\hat \psi_{0,1} \propto (Ra - Ra_c)^{'  num2str(alpha,3) '}$'],'FontSize',14,'color', 'black')
clearvars -except AllData 