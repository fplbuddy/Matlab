run Params.m
run SomeInputStuff.m
 
if not(exist('PrintTimes','var'))
    PrintTimes = input('Times? (input as double) ');
end
while PrintTimes(1) > PrintTimes(2)
   PrintTimes = input('Times? (input as double) ');    
end

Times = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/spec_times.txt']);
ListTimes = Times(:,2);
% Non dime ListTimes
if NDT
    ListTimes = ListTimes*AllData.(ARS).(PrS).(RaS).kappa/pi^2;
end
NumberTimes = Times(:,1);
% Finding lower prints number
[~,~,idx]=unique(abs(ListTimes-PrintTimes(1)));
LowerPrint = NumberTimes(idx==1);
% Finding upper prints number
[~,~,idx]=unique(abs(ListTimes-PrintTimes(2)));
UpperPrint = NumberTimes(idx==1);

PerPlot =  10; % 10 spectrum per plot 

type = input('kinetic or potential? (as char) ');
if convertCharsToStrings(type) == "ps"
    Extension = "Ekspectrum";
    tit = join(["Ekspectrum, " "$" AllData.(ARS).(PrS).(RaS).title "$" ],"");
elseif convertCharsToStrings(type) == "theta"
    Extension = "Epspectrum";
    tit = join(["Epspectrum, " "$" AllData.(ARS).(PrS).(RaS).title "$"],"");
end


figure('Renderer', 'painters', 'Position', [5 5 540 200]), hold on % Start the loop
LIF = PerPlot;
for i = LowerPrint:UpperPrint
    if LIF > 0 % if we have one more in this figure
        node = num2str(i);
        while length(node) < 4
            node = ['0' node];
        end
        ExtensionChar = convertStringsToChars(Extension);
        data = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/' ExtensionChar '.' node '.txt']);
           
        k = data(:,1);
        k = k./k(1); % Have this here becuase of bug
        y = data(:,2);
        y = y.*k.^2; % Have this here becuase of bug
        plot(k,y,'DisplayName', ['t = ' num2str(ListTimes(i),3)])
        LIF = LIF-1;
    else % Start a new plot
        set(gca, 'YScale', 'log')
        set(gca, 'XScale', 'log')
        xlabel('$K$')
        ylabel('$E \times K^2$')
        legend show
        legend('Location', 'bestoutside')
        title(tit)
        hold off
        figure('Renderer', 'painters', 'Position', [5 5 540 200]), hold on
        LIF = 10;
        node = num2str(i);
        while length(node) < 4
            node = ['0' node];
        end
        ExtensionChar = convertStringsToChars(Extension);
        data = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/' ExtensionChar '.' node '.txt']);
        k = data(:,1);
        k = k./k(1); % Have this here becuase of bug
        y = data(:,2);
        y = y.*k.^2;
        loglog(k,y,'DisplayName', ['t = ' num2str(ListTimes(i),3)])
        LIF = LIF-1;  
    end
end
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
xlabel('$K$')
ylabel('$E \times K^2$')
legend show
legend('Location', 'bestoutside')
title(tit)
hold off

clearvars -except AllData
