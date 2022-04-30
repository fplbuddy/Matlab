run Params.m
run SomeInputStuff.m

if not(exist('type','var'))
    type = input('ps or theta? (1 = ps, else theta) ');
end
if convertCharsToStrings(type) == "ps"
    Mode1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
    Mode2 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes2.txt']);
    Mode3 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes3.txt']);
    tit = join(["$\psi, " AllData.(ARS).(PrS).(RaS).title "$"],"");
elseif convertCharsToStrings(type) == "theta"
    Mode1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kthetamodes1.txt']);
    Mode2 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kthetamodes2.txt']);
    Mode3 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kthetamodes3.txt']);
    tit = join(["$\theta, " AllData.(ARS).(PrS).(RaS).title "$"],"");
end
%%
t = Mode1(:,1);
% Guessing that this will give the limit for outputs
top = length(t);

% Non-dimensinalise time
if NDT
	t = t*AllData.(ARS).(PrS).(RaS).kappa/pi^2;
end

col = size(Mode1);
col = col(2);
figure, hold on
for i=2:col 
    y = Mode1(:,i);
    plot(t, y(1:top), 'DisplayName', ModeMatrix(1,i-1))
end
for i=2:col 
    y = Mode2(:,i);
    plot(t, y(1:top), 'DisplayName', ModeMatrix(2,i-1))
end
for i=2:col 
    y = Mode3(:,i);
    plot(t, y(1:top), 'DisplayName', ModeMatrix(3,i-1))
end
legend('Location', 'bestoutside')

if NDT
    xlabel('time (d^2/\kappa)')
else
    xlabel('time (s)')
end
title(tit)
xlim([t(xlower) t(end)])
legend show
clearvars -except AllData
