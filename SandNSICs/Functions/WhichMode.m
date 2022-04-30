function [mrow, mcolumn, ModeAndTypeC] = WhichMode(Mode, type)
    % Finding where the mode is 
    ModeMatrix = [...
        "Re(0,1)", "Re(1,1)", "Re(2,1)", "Im(1,1)", "Im(2,1)"; ...
        "Re(0,2)", "Re(1,2)", "Re(2,2)", "Im(1,2)", "Im(2,2)"; ...
        "Re(0,3)", "Re(1,3)", "Re(2,3)", "Im(1,3)", "Im(2,3)";];
    while not(ismember(Mode,ModeMatrix))
       Mode = input('Which mode? (input at string) ');
    end

    [mrow,mcolumn] = find(Mode == ModeMatrix);
    ModeAndTypeC = convertStringsToChars(Mode);
       
    
    if convertCharsToStrings(type) == "ps"
        ModeAndTypeC = [ModeAndTypeC(1:2) ' (\psi' ModeAndTypeC(3:end) ')'];
    elseif convertCharsToStrings(type) == "theta"
       ModeAndTypeC = [ModeAndTypeC(1:2) ' (\theta' ModeAndTypeC(3:end) ')'];
    else
        type = input('ps or theta? (as char) ');
        [mrow, mcolumn, ModeAndTypeC] = WhichMode(Mode, type);
    end
        
end