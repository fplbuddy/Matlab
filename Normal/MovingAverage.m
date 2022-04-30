run Params.m
run SomeInputStuff.m

if not(exist('type','var'))
    type = input('ps or theta? (1 = ps, else theta) ');
end
if type == 1
   Table = ['kpsmodes' num2str(mrow)];
   label = join(["\psi" Mode],"");
else
   Table = ['kthetamodes' num2str(mrow)];
   label = join(["\theta" Mode],"");
end
 
Table = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/' Table '.txt']);
t = Table(:,1);
y = Table(:,mcolumn+1);


t = t(xlower:end);
y = y(xlower:end);

% Do the moving average stuff
mmy = movmean(y,3000);
%m = max(abs(y));
%mmy(abs(mmy)<m/5)=0;

%Non-dimensionalsie
if NDT
    t = t*AllData.(ARS).(PrS).(RaS).kappa/pi^2;
end

figure
plot(t,mmy)
ylabel(label)
if NDT
    xlabel('time (d^2/\kappa)')
else
    xlabel('time (s)')
end
title(AllData.(ARS).(PrS).(RaS).title)
clearvars -except AllData