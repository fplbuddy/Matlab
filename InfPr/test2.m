% Input
ARS = "AR_2";
PrS = "Pr_30";
RaS = "Ra_6_5e6";

mm = 3000;
SS = 0.65;
xlower = AllData.(ARS).(PrS).(RaS).ICT;
% Getting data
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
signal = kpsmodes1(:,2);
t1 = kenergy(:,1);
t2 = kpsmodes1(:,1);
E = kenergy(:,2);
Ex = kenergy(:,6);
clear kpsmodes1 kenergy

% Removing ICS and making sure all same length
if length(t1) < length(t2)
    xupper = length(t1);
    t = t1;
    clear t2 t1
    t = t(xlower:xupper);
    Ex = Ex(xlower:xupper);
    E = E(xlower:xupper);
    signal = signal(xlower:xupper);
else
    xupper = length(t2);
    t = t2;
    clear t2 t1
    t = t(xlower:xupper);
    Ex = Ex(xlower:xupper);
    E = E(xlower:xupper);
    signal = signal(xlower:xupper);
end
ExE = Ex./E;

% Moving average
MovingAv = movmean(ExE,mm);

% Add sign
MovingAv = MovingAv.*sign(movmean(signal,mm));

% Finding where we are positive, negative or zero
pos = find(MovingAv > SS);
neg = find(MovingAv < -SS);
zero = find(MovingAv <= SS & MovingAv >= -SS);
dt = diff(t);
dt = [dt
    dt(end)]; % Add one last one to make it the same dimensions

% Reshaping
pos = reshape(pos, 1, length(pos));
neg = reshape(neg, 1, length(neg));
zero = reshape(zero, 1, length(zero));

plot(MovingAv)
hold on
plot(signal)
plot([1 length(signal)], [SS SS])
plot([1 length(signal)], [-SS -SS])