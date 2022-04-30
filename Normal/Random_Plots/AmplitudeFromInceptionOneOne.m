AR = 2; Pr = 30;
run SomeInputStuff.m
RaC = 8*pi^4; RaMax = RaC +100;
AmpList = []; RaList = [];
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
for i=1:length(Ra_list)
    if (AllData.(ARS).(PrS).(Ra_list(i)).Ra <= RaMax && AllData.(ARS).(PrS).(Ra_list(i)).Ra > RaC)
        kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(Ra_list(i)).path) '/Checks/kpsmodes1.txt']);
        RealSignal = kpsmodes1(:,3); % Dont need to consider transient here as we just look at last value
        ImagSignal = kpsmodes1(:,5);
        % Check if we have converged
        if RealSignal(end) ==  RealSignal(end-1) || ImagSignal(end) ==  ImagSignal(end-1)
            RaList = [AllData.(ARS).(PrS).(Ra_list(i)).Ra RaList]; 
            AmpList = [sqrt(RealSignal(end)^2 + ImagSignal(end)^2) AmpList];
        end
    end
end
% Finding difference
RaList2 = RaList - RaC;
figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(RaList2,AmpList,'*'), hold on
xlabel('$Ra - 8\pi^4$', 'FontSize',14)
ylabel('$\hat \psi_{1,1}$', 'FontSize',14)
title(['$Pr =' num2str(Pr) '$'], 'FontSize',15)
% Fit data
[alpha, A, xFitted, yFitted, Rval] = FitsPowerLaw(RaList2,AmpList);
plot(xFitted, yFitted, 'black--' )
gtext(['$\hat \psi_{1,1} \propto (Ra - 8\pi^4)^{'  num2str(alpha,3) '}$'],'FontSize',14,'color', 'black')
%clearvars -except AllData 