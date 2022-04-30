run Params.m
run SomeInputStuff.m 
Decomp = 1;
if not(exist('type','var'))
    type = input('ps or theta? Input as char ');
end

if convertCharsToStrings(type) == "ps"
   Table = ['kpsmodes' num2str(mrow)];
   label = join(["$\psi$, " Mode],"");
   type = [type 'i']; % For label later
elseif convertCharsToStrings(type) == "theta"
   Table = ['kthetamodes' num2str(mrow)];
   label = join(["$\theta$" Mode],"");
end
Table = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/' Table '.txt']);
t = Table(:,1);
y = Table(:,mcolumn+1);

if isfield(AllData.(ARS).(PrS).(RaS),'ICT')
    xlower =  AllData.(ARS).(PrS).(RaS).ICT;
end
t = t(xlower:end);
y = y(xlower:end);

%Non-dimensionalsie
if NDT
    t = t*AllData.(ARS).(PrS).(RaS).kappa/pi^2;
end

figure('Renderer', 'painters', 'Position', [5 5 540 200])
if Decomp
    % Plot pos
    posshearing = [AllData.(ARS).(PrS).(RaS).calcs.pos];
    for j=1:length(posshearing)
        section = posshearing{j};
        section(section > length(t)) = [];
        plot(t(section), y(section), 'r-')
        hold on
    end
    
    % Plotting zero
    zeroshearing = AllData.(ARS).(PrS).(RaS).calcs.zero;
    for j=1:length(zeroshearing)
        section = zeroshearing{j};
        section(section > length(t)) = [];
        plot(t(section), y(section), 'g-')
    end
    

    % Plotting neg shearing
    negshearing = AllData.(ARS).(PrS).(RaS).calcs.neg;
    for j=1:length(negshearing)
        section = negshearing{j};
        section(section > length(t)) = [];
        plot(t(section), y(section), 'b-')
    end
else
    plot(t, y)
end
    
    
hold off
if NDT
    xlabel('$t (d^2/\kappa)$', 'FontSize', 14)
else
    xlabel('$t (s)$', 'FontSize', 14)
end
Mode = convertStringsToChars(Mode);
ylabel(['$\hat\' type '_{' Mode(4:6) '}$'], 'FontSize', 14)
title(join(['$' AllData.(ARS).(PrS).(RaS).title '$'],""), 'FontSize', 15)
clearvars -except AllData