run Params.m
run SomeInputStuff.m

prints = AllData.(ARS).(PrS).(RaS).Spectra.Times;
prints = prints(end,1);
mean = zeros(length(AllData.(ARS).(PrS).(RaS).Spectra.Zonaltheta.Zonaltheta1),1);
for i=1:prints % Looping round outputs
    String = join(["Zonaltheta" num2str(i)], "");
    Add = AllData.(ARS).(PrS).(RaS).Spectra.Zonaltheta.(String);
    for i=1:length(mean) % Looping rounds points
       mean(i) = mean(i) + Add(i); 
    end
end
mean = mean/prints; % Finding average
y = linspace(0, 1, length(mean));
for i=1:length(mean)
    mean(i) = mean(i) + 1 - (i-0.5)/length(mean);
end
figure
plot(mean,y);
ylabel('$y$','Interpreter','latex', 'FontSize', 17)
xlabel('$\bar{T}^t(y)$','Interpreter','latex', 'FontSize', 17)
title(AllData.(ARS).(PrS).(RaS).title)
clearvars -except AllData