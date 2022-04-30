function [Signal,t] = GetSignal(Mode,type, AllData, ARS, PrS, RaS)
    ModeMatrix = [...
    "Re(0,1)", "Re(1,1)", "Re(2,1)", "Im(1,1)", "Im(2,1)"; ...
    "Re(0,2)", "Re(1,2)", "Re(2,2)", "Im(1,2)", "Im(2,2)"; ...
    "Re(0,3)", "Re(1,3)", "Re(2,3)", "Im(1,3)", "Im(2,3)";];
    [mrow,mcolumn] = find(Mode == ModeMatrix);
    Table  = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/k' type 'modes' num2str(mrow) '.txt']);
    Signal = Table(:,mcolumn+1);
    t = Table(:,1);
end