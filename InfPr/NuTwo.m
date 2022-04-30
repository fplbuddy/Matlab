run Params.m
run SomeInputStuff.m

Ra = AllData.(ARS).(PrS).(RaS).Ra;
kappa = AllData.(ARS).(PrS).(RaS).kappa;
tit = AllData.(ARS).(PrS).(RaS).title;
t = AllData.(ARS).(PrS).(RaS).kenergy(:,1);
epsk = AllData.(ARS).(PrS).(RaS).kenergy(:,3);
% Need to calculate how long each time step is
StepLength = zeros(1, length(t)-1);
New = t(1); % To initiate loop
for i=1:length(StepLength)
    Old = New;
    New = t(i+1);
    StepLength(i) = New - Old;
end

StepLength = StepLength(xlower:end);
t = t(xlower:end);
epsk = epsk(xlower:end);
% Calculate Nu at each stage
Nut = zeros(1, length(StepLength));
for i= 1:length(Nut)
    Nut(i) = 1 + pi^4*epsk(i)/(kappa^2*Ra); % We neeed to multipy with the dimensional stuff here
end
% Calculate average
Ans = 0;
for i=1:length(Nut)
    Ans = Nut(i)*StepLength(i) + Ans;
end
Ans = (Ans/(t(end)-t(1)));
if NDT
    t = t/(pi^2/kappa);
end
figure
semilogy(t(1:end-1), Nut, 'DisplayName', 'Nu(t)'), hold on
ylabel('Nu(t)')
xlabel('t (d^2/\kappa)')
title(tit)
plot([t(1) t(end)], [Ans Ans], 'DisplayName', ['Nu = ' num2str(Ans)])
legend show
legend('Location', 'best')
hold off
clearvars -except AllData