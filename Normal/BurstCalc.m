run Params.m
run SomeInputStuff.m

kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
t = kenergy(:,1);
Ey = kenergy(:,5);
xlower = AllData.(ARS).(PrS).(RaS).ICT;
Ey = Ey(xlower:end);
t = t(xlower:end);
kappa = AllData.(ARS).(PrS).(RaS).kappa;

L = length(Ey);
tdiff = diff(t);
T = mean(tdiff);
Fs = 1/T;
Y = fft(Ey);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
semilogy(f, P1, '-o');

totaltime = (t(end) - t(1))*kappa/pi^2

%% Move mean method
c = 50;
Eymean = movmean(Ey, c);
thres = 1e-3;
% count crossings
count = 0;
for i=1:length(Eymean)-1
    if or(and(Eymean(i) < thres,Eymean(i+1) > thres), and(Eymean(i) > thres,Eymean(i+1) < thres))
        count = count + 1;
    end
end
count = count/2;
TBB = totaltime/count
    
