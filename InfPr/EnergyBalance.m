run Params.m
run SomeInputStuff.m
 
type = input('Potential or kinetic? (char) ');
kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);

if convertCharsToStrings(type) == "ps"
    t = kenergy(:,1);
    Ik = kenergy(:,4);
    %nu = AllData.(ARS).(PrS).(RaS).nu; 
    eps = kenergy(:,3);
    %eps = eps*nu;
    tit = join(["Kinetic Energy Balance, $" AllData.(ARS).(PrS).(RaS).title "$"],"");
elseif convertCharsToStrings(type) == "theta"
    penergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/penergy.txt']);
    t = kenergy(:,1);
    Ik = sqrt(AllData.(ARS).(PrS).(RaS).Ra)*kenergy(:,4);
    %kappa = AllData.(ARS).(PrS).(RaS).kappa; 
    eps = penergy(:,3);
    %eps = eps*kappa*pi;
    tit = join(["Potential Energy Balance, $" AllData.(ARS).(PrS).(RaS).title "$"],"");
end

if not(exist('xlower','var'))
    run lowerx.m
end
 
t = t(xlower:end);
Ik = Ik(xlower:end);
eps = eps(xlower:end);

% Making sure everything is the same length
top = min([length(t) length(Ik) length(eps)]);
t = t(1:top);
Ik = Ik(1:top);
eps = eps(1:top);

% Non dimensionalsie
if NDT
    t = t*AllData.(ARS).(PrS).(RaS).kappa/pi^2;
end
 
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(t, Ik, 'DisplayName', 'Injection'), hold on
plot(t, eps, 'DisplayName', 'Dissipation'), hold off
if NDT
    xlabel('time (d^2/\kappa)')
else
    xlabel('time (s)')
end
%ylabel('Dimensional')
legend show
legend('Location', 'best')
title(tit)

clearvars -except AllData