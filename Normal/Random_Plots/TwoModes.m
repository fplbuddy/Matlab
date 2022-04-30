run Params.m
run SomeInputStuff.m
% Inputs
Mode1 = 'psRe(0,1)';
Mode2 = 'psRe(1,1)';
% Get data
[Signal1, t1, tit1] = TimeSer(Mode1, AllData, ARS, PrS, RaS,0);
[Signal2, t2, tit2] = TimeSer(Mode2, AllData, ARS, PrS, RaS,1);
% Plot
figure('Renderer', 'painters', 'Position', [5 5 540 200])
shearing = [AllData.(ARS).(PrS).(RaS).calcs.pos AllData.(ARS).(PrS).(RaS).calcs.neg];
for j=1:length(shearing)
    section = shearing{j};
    section(section > length(Signal1) | section > length(Signal2)) = [];
    plot(Signal1(section), Signal2(section), 'r-')
    hold on
end
nonshearing = AllData.(ARS).(PrS).(RaS).calcs.zero;
for j=1:length(nonshearing)
    section = nonshearing{j};
    section(section > length(Signal1) | section > length(Signal2)) = [];
    plot(Signal1(section), Signal2(section), 'b-')
end
xlabel(['$' tit1 '$'], 'Fontsize',14)
ylabel(['$' tit2 '$'], 'Fontsize',14)
title(['$' AllData.(ARS).(PrS).(RaS).title '$'], 'FontSize', 15)

hold off
clearvars -except AllData