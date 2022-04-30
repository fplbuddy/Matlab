AR = 2;
Pr = 0.01;
run SomeInputStuff.m
RaC = 7.86; RaMax = 1e6;
SDList = []; RaList = [];
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
for i=1:length(Ra_list)
    if (AllData.(ARS).(PrS).(Ra_list(i)).Ra <= RaMax && AllData.(ARS).(PrS).(Ra_list(i)).Ra > RaC)
        Ra = AllData.(ARS).(PrS).(Ra_list(i)).Ra;
        RaList = [Ra RaList];
        %kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(Ra_list(i)).path) '/Checks/kpsmodes1.txt']);
        %Signal = kpsmodes1(:,2);
        % Get rid of transient
        %xlower = AllData.(ARS).(PrS).(Ra_list(i)).ICT;
        %Signal = Signal(xlower:end);
        %SDList = [std(Signal) SDList];
        SDList = [AllData.(ARS).(PrS).(Ra_list(i)).calcs.zsd SDList];
    end
end
% Finding difference
%RaList = RaList - RaC;
figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(RaList,SDList.^2,'*'), hold on
xlabel('$Ra$', 'FontSize',14)
ylabel('$Var(\hat \psi_{0,1})$', 'FontSize',14)
title(['$Pr =' num2str(Pr) '$'], 'FontSize',15)
% Fit data
% [alpha, A, xFitted, yFitted, Rval] = FitsLinear(RaList,SDList.^2);
% plot(xFitted, yFitted, 'black--' )
%gtext(['$Var(\hat \psi_{0,1}) =' num2str(alpha,3) 'Ra - Ra_C$'],'FontSize',14,'color', 'black')
clearvars -except AllData Data
%% Other stuff
RaC = 1.743e4;
figure('Renderer', 'painters', 'Position', [5 5 540 200])
% Sorting
[RaList, I] = sort(RaList); SDList = SDList(I);
% plot
loglog(RaList - RaC,SDList,'r*'), hold on
[alpha, A, xFitted, yFitted, Rval] = FitsPowerLaw(RaList(1:(end-1))-RaC,SDList(1:(end-1)));
plot(xFitted, yFitted, 'black--') 
title('$Pr = 1$', 'FontSize', 15)
xlabel('$Ra$', 'FontSize', 14)
ylabel('$SD( \hat \psi_{0,1} )$', 'FontSize', 14)
gtext(['$SD( \hat \psi_{0,1} ) \propto Ra^{'  num2str(alpha,3) '}$'],'FontSize',17,'color', 'black')

