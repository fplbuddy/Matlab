AR = 1;
Pr = 30;
Ra = 1.5e6;
PrintTimes = [4e4 5e4];
type = 'ps';
%xlower = 0;
Mode = "Re(0,1)";
NDT = 1; % Using non-dim time or not
nmpi = 8;

ModeMatrix = [...
    "Re(0,1)", "Re(1,1)", "Re(2,1)", "Im(1,1)", "Im(2,1)"; ...
    "Re(0,2)", "Re(1,2)", "Re(2,2)", "Im(1,2)", "Im(2,2)"; ...
    "Re(0,3)", "Re(1,3)", "Re(2,3)", "Im(1,3)", "Im(2,3)";];

[mrow,mcolumn, ModeAndTypeC] = WhichMode(Mode, type);