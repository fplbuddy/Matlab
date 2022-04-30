run SetUp.m
run Params.m
run SomeInputStuff.m
file = 'zonalmean';

% Finding nondim factor
kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
t = kenergy(:,1);
Ey = kenergy(:,5);
Ex = kenergy(:,6);
urms = 2*Ex+2*Ey;
urms = MyMeanEasy(urms,t); urms = urms^(1/2);
h = pi;
ND = 1/(urms);

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

figure('Renderer', 'painters', 'Position', [5 5 600 400])
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
        plot1 = plot(Data*ND, y, 'Color', [1 0.7 0.7]);
        plot1.Color(4) = 0.3;
        pav = pav + Data;
    elseif ismembertol(Time, negt,1e-9) % Ie we are negative shearing
        nn = nn + 1;
        plot1 = plot(Data*ND, y, 'Color', [0.7 0.7 1]);
        plot1.Color(4) = 0.3;
        nav = nav + Data;
    elseif ismembertol(Time, zerot,1e-9) % Ie we are zero
        zn = zn + 1;
        plot1 = plot(Data*ND, y, 'Color', [0.35 0.5 0.35]);
        plot1.Color(4) = 0.3;
        zav = zav + Data;    
    end
end
plot([0 0], [0 1], 'black--');
yticks([0 0.5 1])
yticklabels({'$0$' '$0.5$' '$1$'})
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
plot([-1.5 0.5], [0.5 0.5], 'black--');
% Finding averages
pav = pav/pn;
nav = nav/nn;
zav = zav/zn;

% Plotting averages
p1 = plot(nav*ND, y, 'blue-','LineWidth', 2);
p2 = plot(zav*ND, y, 'Color', [0 0.5 0],'LineWidth', 2);
p3 = plot(pav*ND, y, 'red-','LineWidth', 2);
legend('Location', 'best'); legend('boxoff')


h = [p1; p2; p3];
 % Now call the legend function passing the handle h and specify the text
legend(h,'$\langle\widehat \psi_{0,1}\rangle < 0$','$\langle\widehat \psi_{0,1}\rangle \approx 0$' ,'$\langle\widehat \psi_{0,1}\rangle > 0$', 'Location', 'east', 'FontSize', lgndFS);


if convertCharsToStrings(file) == "Zonaltheta"
    xlabel('Temperature', 'FontSize', 13)
elseif convertCharsToStrings(file) == "zonalmean"
    xlabel('$U/(u_{rms})$', 'FontSize', LabelFS)
end
ylabel('$y/(\pi d)$', 'FontSize', LabelFS)
%title(['$' convertStringsToChars(AllData.(ARS).(PrS).(RaS).title) '$'], 'FontSize',14)


clearvars -except AllData