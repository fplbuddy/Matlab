run SetUp.m
AR = 1;
Pr = 30;
run SomeInputStuff.m
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
SDM = []; Ra = [];
ND = 1;
for i=1:length(Ra_list)
    RaS = Ra_list(i);
    PosShear = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.pos{1})) == 1);
    NegShear = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.neg{1})) == 1);
    if isfield(AllData.(ARS).(PrS).(RaS),'ICT') && NegShear && PosShear
        kappa = AllData.(ARS).(PrS).(RaS).kappa;
        xlower = AllData.(ARS).(PrS).(RaS).ICT;
        kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
        Signal = kpsmodes1(:,2); t = kpsmodes1(:,1);
        Signal = Signal(xlower:end); t = t(xlower:end);
        if ND
            Signal = Signal/kappa;
            t = t*kappa/pi^2; 
        end
        M = MyMeanEasy(abs(Signal), t);
        SD = std(abs(Signal));
        SDM = [SD/M SDM];
        Ra = [Ra AllData.(ARS).(PrS).(RaS).Ra];
    end
end
figure
plot(Ra, SDM, '*')
clearvars -except AllData