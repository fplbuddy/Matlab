run Params.m
run SomeInputStuff.m

if not(exist('type','var'))
    type = input('ps or theta? Input as char ');
end

if convertCharsToStrings(type) == "ps"
   Table = ['kpsmodes' num2str(mrow)];
   label = join(["$\psi$, " Mode],"");
elseif convertCharsToStrings(type) == "theta"
   Table = ['kthetamodes' num2str(mrow)];
   label = join(["$\theta$" Mode],"");
end
Table = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/' Table '.txt']);
t = Table(:,1);
y = Table(:,mcolumn+1);

 
t = t(xlower:end);
y = y(xlower:end);

%Non-dimensionalsie
if NDT
    t = t*AllData.(ARS).(PrS).(RaS).kappa/pi^2;
end

figure
%lg = input('log plot? (1 = log) ');
lg = 0;
if lg
    semilogy(t,abs(y))
    ylabel(join(["abs" label],""))
else
    plot(t,y)
    ylabel(label)
end
if NDT
    xlabel('$t (d^2/\kappa)$')
else
    xlabel('$t (s)$')
end
title(join(['$' AllData.(ARS).(PrS).(RaS).title '$'],""))
clearvars -except AllData