AR = 2;
Pr = 11;
run SomeInputStuff.m
SDList = []; RaList = []; RaRange = [3.25e4 5e4];
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
for i=1:length(Ra_list)
    if (AllData.(ARS).(PrS).(Ra_list(i)).Ra <= max(RaRange) && AllData.(ARS).(PrS).(Ra_list(i)).Ra >= min(RaRange))
        Ra = AllData.(ARS).(PrS).(Ra_list(i)).Ra;
        RaList = [Ra RaList];
        kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(Ra_list(i)).path) '/Checks/kpsmodes1.txt']);
        Signal = kpsmodes1(:,2);
        % Get rid of transient
        xlower = AllData.(ARS).(PrS).(Ra_list(i)).ICT;
        Signal = Signal(xlower:end);
        SDList = [std(Signal) SDList];
    end
end
% Finding difference
%RaList = RaList - RaC;
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(RaList,SDList.^2,'*'), hold on
xlabel('$Ra$', 'FontSize',14)
ylabel('$Var(\hat \psi_{0,1})$', 'FontSize',14)
title(['$Pr =' num2str(Pr) '$'], 'FontSize',15)
% Fit data
[alpha, A, xFitted, yFitted, Rval] = FitsLinear(RaList,SDList.^2);
plot(xFitted, yFitted, 'black--' )
gtext(['$Ra_c = ' sprintf('%.2e', -A/alpha) '$'],'FontSize',14,'color', 'black')
%clearvars -except AllData Data