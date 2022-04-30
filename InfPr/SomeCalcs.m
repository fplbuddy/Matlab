run Params.m
run SomeInputStuff.m
mode = input('Which mode? (2 for (0,1) 3 for (1,1)) ');
Neg = 0;
Pos = 0;

% time spent in each sign
TimeSpen = [0 0]; % Will fill first column with positive and other with negative

% Getting mode
signal = AllData.(ARS).(PrS).(RaS).kpsmodes1(:,mode);
t = AllData.(ARS).(PrS).(RaS).kpsmodes1(:,1);
% Getting injection rate to calculate Nu
Ik = AllData.(ARS).(PrS).(RaS).kenergy(:,4);
% Finding steady state
h = figure;
plot(signal);
xlabel('Step, not time')
xlower = input('Where do we start? ');
close(h)
pause
% Getting rid of transient
t = t(xlower:end);
signal = signal(xlower:end);
Ik = Ik(xlower:end);
%% Extreme values and setting what we define to be a reversal
minval = min(signal);
maxval = max(signal);
FT = max([maxval abs(minval)])/100;
%%
dt = zeros(length(t)-1, 1);
for i=1:length(dt)
    dt(i) = t(i+1) - t(i);
end
% Integrate
mean = 0;
Nu = 0;
Flag = sign(1);
if Flag
    Pos = 1;
else
    Neg = 1;
end
for i=1:length(dt)
    mean = mean + signal(i)*dt(i)/sum(dt);
    Nu = Nu + (1 + pi*Ik(i)/AllData.(ARS).(PrS).(RaS).kappa)*dt(i)/sum(dt);
    % Time spent
    OldF = Flag;
    if signal(i)> FT
        Flag = 1;
        TimeSpen(1) = TimeSpen(1) + dt(i)/sum(dt);
    elseif signal(i)< -FT
        Flag = -1;
        TimeSpen(2) = TimeSpen(2) + dt(i)/sum(dt);
    else
        if Flag == 1
            TimeSpen(1) = TimeSpen(1) + dt(i)/sum(dt);
        else
            TimeSpen(2) = TimeSpen(2) + dt(i)/sum(dt);
        end           
    end
    if OldF == 1 & Flag == -1
        Neg = Neg + 1;
    elseif OldF == -1 & Flag == 1
        Pos = Pos + 1;
    end
end
%% Plotting reversals
y = find(abs(signal) < FT); % Finding points less than bound
z = signal; % Making copy of signal and time
tt = t; 
z(y) = []; % Removing small points
tt(y) =[];
x = find(z(1:end-1)>0 & z(2:end) < 0  | z(1:end-1)<0 & z(2:end) > 0); % finding reversals (in index of modefied ones)
% figure 
% plot(t, signal)
% hold ons
% plot(tt(x), zeros(length(x)),'r.')
% hold off
NumReversals = length(x);
%% Time of reversal
PosRevTime = TimeSpen(1)*sum(dt)/Pos;
NegRevTime = TimeSpen(1)*sum(dt)/Neg;
%% Results, make it before zeros(x,12)
% Find first non zero value
if not(exist('Results','var'))
    x = 1;
else    
    [x, y] = size(Results);
    x = x + 1;
end
Results(x,1) = AR;
Results(x,2) = Pr;
Results(x,3) = Ra;
Results(x,4) = mode;
Results(x,5) = PosRevTime;
Results(x,6) = NegRevTime;
Results(x,7) = PosRevTime*AllData.(ARS).(PrS).(RaS).kappa/pi^2;
Results(x,8) = NegRevTime*AllData.(ARS).(PrS).(RaS).kappa/pi^2;
Results(x,9) = mean;
Results(x,10) = minval;
Results(x,11) = maxval;
Results(x,12) = NumReversals;
Results(x,13) = Nu; % Nusselt number 
Results(x,14) = sum(dt); % Total time
Results(x,15) = sum(dt)*AllData.(ARS).(PrS).(RaS).kappa/pi^2; %Total time in thermal diffusive time units
Results(x,16) =  Results(x,14)/NumReversals; % Time (s) for each reversal
Results(x,17) =  Results(x,15)/NumReversals; % Time (thermal diffusive time units) for each reversal
%clearvars -except AllData Results
stop
%% Write file
writematrix(Results,'Results.csv')

