run Params.m
run SomeInputStuff.m

kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);

t = kenergy(:,1);
Ey = kenergy(:,5);
Ex = kenergy(:,6);
Ek = kenergy(:,2);

t = t(xlower:end);
Ey = Ey(xlower:end);
Ex = Ex(xlower:end);

% Making sure everything is the same length
top = min([length(t) length(Ex) length(Ey)]);
t = t(1:top);
Ex = Ex(1:top);
Ey = Ey(1:top);

% Non dimensionalise
if NDT
    t = AllData.(ARS).(PrS).(RaS).kappa/pi^2*t;
end
Ex  = Ex*pi^2/AllData.(ARS).(PrS).(RaS).kappa^2;
Ey  = Ey*pi^2/AllData.(ARS).(PrS).(RaS).kappa^2;
 
figure
semilogy(t, Ex, 'DisplayName', 'E_x'), hold on
plot(t, Ey, 'DisplayName', 'E_y'), hold off
if NDT
    xlabel('time (d^2/\kappa)')
else
    xlabel('time (s)')
end
ylabel('Energy')
legend show
legend('Location', 'best')
title(AllData.(ARS).(PrS).(RaS).title)

clearvars -except AllData