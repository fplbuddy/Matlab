function [Signal, t, title  ]= TimeSer(Modetype, AllData, ARS, PrS, RaS, abs)
% Finding where the mode is
ModeMatrix = [...
    "Re(0,1)", "Re(1,1)", "Re(2,1)", "Im(1,1)", "Im(2,1)"; ...
    "Re(0,2)", "Re(1,2)", "Re(2,2)", "Im(1,2)", "Im(2,2)"; ...
    "Re(0,3)", "Re(1,3)", "Re(2,3)", "Im(1,3)", "Im(2,3)";];

Mode = Modetype(end-6:end);
type = Modetype(1:end-7);


while not(ismember(convertCharsToStrings(Mode),ModeMatrix))
    Mode = input('Which mode? (input at string) ');
end

[mrow,mcolumn] = find(Mode == ModeMatrix);

if convertCharsToStrings(type) == "ps"
    Table = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/' ['kpsmodes' num2str(mrow)] '.txt']);
    t = Table(:,1);
    if abs
        Signal = Table(:,mcolumn+1).^2 + Table(:,mcolumn+3).^2;
        Signal = sqrt(Signal);
    else
        Signal = Table(:,mcolumn+1);
    end
    type = [type 'i']; % Used for title later
elseif convertCharsToStrings(type) == "theta"
    Table = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/' ['kthetamodes' num2str(mrow)] '.txt']);
    t = Table(:,1);
    if abs
        Signal = Table(:,mcolumn+1).^2 + Table(:,mcolumn+3).^2;
        Signal = sqrt(Signal);
    else
        Signal = Table(:,mcolumn+1);
    end
else
    type = input('ps or theta? (as char) ');
    Signal = TimeSer([type Mode]);
end
% Trim
if isfield(AllData.(ARS).(PrS).(RaS),'ICT')
    xlower = AllData.(ARS).(PrS).(RaS).ICT;
    t = t(xlower:end);
    Signal = Signal(xlower:end);
end


if abs
    title = ['\mid\hat\' type '_{' Mode(4:6) '}\mid'];
else
    title = [Mode(1:2) '(\hat\' type '_{' Mode(4:6) '})'];
end



end