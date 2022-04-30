run Params.m
run SomeInputStuff.m
file = 'zonalmean';

% Getting how many points in y
Res = convertStringsToChars(AllData.(ARS).(PrS).(RaS).Res);
[nx, ny] = nxny(Res);

PrintTimes = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/spec_times.txt']);
First = PrintTimes(1,1);
Last = PrintTimes(end,1);
Times = PrintTimes(:,2);
Prints = PrintTimes(:,1);
t = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
t = t(:,1);
t = t(xlower:end);
t = reshape(t, 1, length(t));

% Setting up the time vectors, number is there for tollerance later
post = [1e8];
negt = [1e8];
zerot = [1e8];

% Finding pos shearing times 
for i=1:length(AllData.(ARS).(PrS).(RaS).calcs.pos)
   section = AllData.(ARS).(PrS).(RaS).calcs.pos{i};
   post = [post t(AllData.(ARS).(PrS).(RaS).calcs.pos{i})];
end
% Finding neg shearing times 
for i=1:length(AllData.(ARS).(PrS).(RaS).calcs.neg)
   section = AllData.(ARS).(PrS).(RaS).calcs.neg{i};
   negt = [negt t(AllData.(ARS).(PrS).(RaS).calcs.neg{i})];
end
% Finding zero times 
for i=1:length(AllData.(ARS).(PrS).(RaS).calcs.zero)
   section = AllData.(ARS).(PrS).(RaS).calcs.zero{i};
   zerot = [zerot t(AllData.(ARS).(PrS).(RaS).calcs.zero{i})];
end


% Setting up how many we have of each
pn = 0;
nn = 0;
zn = 0;

% Setting up the averages
pav = zeros(ny,1);
nav = zeros(ny,1);
zav = zeros(ny,1);

figure('Renderer', 'painters', 'Position', [5 5 540 200])
y = linspace(0 + 1/(2*ny), 1 - 1/(2*ny), ny);

if convertCharsToStrings(file) == "Zonaltheta" % Add to y for boundary conditions if we are plotting TT.
   y = [0 y 1]; 
end
    
    
hold on
% Looping around print times, ASSUMES WELL BEHAVED HERE. Ie start at 1 etc.
for i=First:Last
    Time = Times(i);
    Print = Prints(i);
    % Convert print to format we want
    Print = num2str(Print);
    while length(Print) < 4
        Print = ['0' Print];
    end
    % Extracting data
    Data = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/' file '.' Print '.txt']);   
    if convertCharsToStrings(file) == "Zonaltheta" 
        Data = reshape(Data, 1, ny);
        Data = Data + (1-linspace(0 + 1/(2*ny), 1 - 1/(2*ny), ny)); % Converting to TT
        % Adding BCs
        Data = [1 Data 0];
    end
    
    
    if ismembertol(Time, post,1e-9) % Ie we are positive shearing
        pn = pn + 1;
        plot1 = plot(Data, y, 'red-');
        plot1.Color(4) = 0.1;
        pav = pav + Data;
    elseif ismembertol(Time, negt,1e-9) % Ie we are negative shearing
        nn = nn + 1;
        plot1 = plot(Data, y, 'green-');
        plot1.Color(4) = 0.1;
        nav = nav + Data;
    elseif ismembertol(Time, zerot,1e-9) % Ie we are zero
        zn = zn + 1;
        plot1 = plot(Data, y, 'blue-');
        plot1.Color(4) = 0.1;
        zav = zav + Data;    
    end
end
% Finding averages
pav = pav/pn;
nav = nav/nn;
zav = zav/zn;

% Plotting averages
plot(pav, y, 'black-','LineWidth', 2)
plot(nav, y, 'black-','LineWidth', 2)
plot(zav, y, 'black-','LineWidth', 2)

if convertCharsToStrings(file) == "Zonaltheta"
    xlabel('Temperature', 'FontSize', 13)
elseif onvertCharsToStrings(file) == "zonalmean"
    xlabel('$u$ $(m/s)$', 'FontSize', 13)
end
ylabel('$y$', 'FontSize', 13)
yticks([0 1])
yticklabels({'$0$' '$\pi L_y $'})
title(['$' convertStringsToChars(AllData.(ARS).(PrS).(RaS).title) '$'], 'FontSize',14)

clearvars -except AllData