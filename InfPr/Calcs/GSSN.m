% Input
mm = 2000;
SS = 0.6;

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
MovingAv = MovingAv.*signal;

% Finding where we are positive, negative or zero
pos = find(MovingAv > SS);
neg = find(MovingAv < -AA);
zero = find(MovingAv <= SS & MovingAv >= -SS);
dt = diff(t);
dt = [dt
    dt(end)]; % Add one last one to make it the same dimensions

% Reshaping
pos = reshape(pos, 1, length(pos));
neg = reshape(neg, 1, length(neg));
zero = reshape(zero, 1, length(zero));

% Putting it into AllData
AllData.(ARS).(PrS).(RaS).calcs.pos = mat2cell( pos, 1,diff( [0, find(diff(pos) ~= 1), length(pos)] ) );
AllData.(ARS).(PrS).(RaS).calcs.neg = mat2cell( neg, 1,diff( [0, find(diff(neg) ~= 1), length(neg)] ) );
AllData.(ARS).(PrS).(RaS).calcs.zero = mat2cell( zero, 1,diff( [0, find(diff(zero) ~= 1), length(zero)] ) );
TIP = size(AllData.(ARS).(PrS).(RaS).calcs.pos);
TIN = size(AllData.(ARS).(PrS).(RaS).calcs.neg);
TIZ = size(AllData.(ARS).(PrS).(RaS).calcs.zero);
AllData.(ARS).(PrS).(RaS).calcs.posT = sum(dt(pos));
AllData.(ARS).(PrS).(RaS).calcs.negT = sum(dt(neg));
AllData.(ARS).(PrS).(RaS).calcs.zeroT = sum(dt(zero));
AllData.(ARS).(PrS).(RaS).calcs.TIP = min([TIP(2) length(pos)]);
AllData.(ARS).(PrS).(RaS).calcs.TIN = min([TIN(2) length(neg)]);
AllData.(ARS).(PrS).(RaS).calcs.TIZ = min([TIZ(2) length(zero)]);
AllData.(ARS).(PrS).(RaS).calcs.pmean = MyMean(signal, t,AllData.(ARS).(PrS).(RaS).calcs.pos);
AllData.(ARS).(PrS).(RaS).calcs.nmean = MyMean(signal, t,AllData.(ARS).(PrS).(RaS).calcs.neg);
AllData.(ARS).(PrS).(RaS).calcs.zmean = MyMean(signal, t,AllData.(ARS).(PrS).(RaS).calcs.zero);
AllData.(ARS).(PrS).(RaS).calcs.pExEmean = MyMean(ExE, t, AllData.(ARS).(PrS).(RaS).calcs.pos);
AllData.(ARS).(PrS).(RaS).calcs.nExEmean = MyMean(ExE, t, AllData.(ARS).(PrS).(RaS).calcs.neg);
AllData.(ARS).(PrS).(RaS).calcs.zExEmean = MyMean(ExE, t, AllData.(ARS).(PrS).(RaS).calcs.zero);
AllData.(ARS).(PrS).(RaS).calcs.sExEmean = MyMean(ExE, t, [AllData.(ARS).(PrS).(RaS).calcs.pos AllData.(ARS).(PrS).(RaS).calcs.neg]);