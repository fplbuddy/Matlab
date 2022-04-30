run Params.m
run SomeInputStuff.m

% kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
% penergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/penergy.txt']);
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
% kpsmodes2 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes2.txt']);
% kpsmodes3 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes3.txt']);
% kthetamodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kthetamodes1.txt']);
% kthetamodes2 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kthetamodes2.txt']);
% kthetamodes3 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kthetamodes3.txt']);

plot(kpsmodes1(:,2))
clearvars -except AllData