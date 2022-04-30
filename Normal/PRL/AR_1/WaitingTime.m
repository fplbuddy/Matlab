run SetUp.m
AR = 1;
Pr = 30;
run SomeInputStuff.m
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
WT = []; Ra = [];
ND = 1;
for i=1:length(Ra_list)
    RaS = Ra_list(i);
    PosShear = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.pos{1})) == 1);
    NegShear = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.neg{1})) == 1);
    if isfield(AllData.(ARS).(PrS).(RaS),'ICT') && NegShear && PosShear
        xlower = AllData.(ARS).(PrS).(RaS).ICT;
        kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
        Signal = kpsmodes1(:,2); t = kpsmodes1(:,1);
        Signal = Signal(xlower:end); t = t(xlower:end);
        Signal = movmean(Signal, 100);
        Zeros = 0;
        for i=1:(length(Signal)-1)
           if sign(Signal(i)) ~= sign(Signal(i+1))
               Zeros = Zeros + 1;
           end
        end
        if ND
            WT = [WT ((t(end) - t(1))/(Zeros+1))*AllData.(ARS).(PrS).(RaS).kappa/pi^2]; 
        else
            WT = [WT ((t(end) - t(1))/(Zeros+1))]; 
        end
        Ra = [Ra AllData.(ARS).(PrS).(RaS).Ra];
    end
end
figure
plot(Ra, WT, '*')
clearvars -except AllData