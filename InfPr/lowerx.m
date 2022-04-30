h = figure;
kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
Ek = kenergy(:,2);
plot(Ek);
xlabel('Step, not time')
ylabel('$E_K$')
xlower = input('Where do we start? ');
close(h)