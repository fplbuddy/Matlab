AR = 3;
Pr = Inf;
Ra = 1e8;
PrintTimes = [100 600];
type = 'ps';
xlower = 2000;
Mode = "Re(1,1)";
NDT = 0; % Using non-dim time or not

ModeMatrix = [...
    "Re(0,1)", "Re(1,1)", "Re(2,1)", "Im(1,1)", "Im(2,1)"; ...
    "Re(0,2)", "Re(1,2)", "Re(2,2)", "Im(1,2)", "Im(2,2)"; ...
    "Re(0,3)", "Re(1,3)", "Re(2,3)", "Im(1,3)", "Im(2,3)";];

[mrow,mcolumn, ModeAndTypeC] = WhichMode(Mode, type);