run Params.m
run SomeInputStuff.m

prints = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/spec_times.txt']);
prints = prints(end,1);

Res = convertStringsToChars(AllData.(ARS).(PrS).(RaS).Res);
ny = '';
for i=find('x' == Res)+1:length(Res)
   ny = [ny Res(i)];
end
ny = str2num(ny);
mean = zeros(ny,1);
for i=1:prints % Looping round outputs
    node = num2str(i);
    while length(node) < 4
        node = ['0' node];
    end
    Add = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/zonalmean.' node '.txt']);
    for i=1:length(mean) % Looping rounds points
       mean(i) = mean(i) + Add(i); 
    end
end
mean = mean/prints; % Finding average
A = max(abs(mean));
mean = mean/A; % Normalising
y = linspace(0, 1, ny); % not strictly correct
figure
plot(mean,y);
ylabel('$y$','Interpreter','latex', 'FontSize', 17)
xlabel('$\bar{u}^t/\bar{u}^t_{max}$','Interpreter','latex', 'FontSize', 17)
title(join(["$" AllData.(ARS).(PrS).(RaS).title "$"],""))
clearvars -except AllData