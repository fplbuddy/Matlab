function RaT = RatoRaT(Ra)
    if Ra == 0
        RaT = '0';
    else


    RaChar = num2str(Ra);
    RaChar = strrep(RaChar,'.','');
    power = num2str(floor(log10(Ra)));
    if Ra >= 1
        dp = find(RaChar ~= '0', 1, 'last');
    elseif Ra >= 1e-4 && Ra < 1
        dp = length(RaChar) - find(RaChar ~= '0', 1, 'first') + 1;
        RaChar = RaChar(find(RaChar ~= '0', 1, 'first'):end);
    else
        I = find(RaChar == 'e', 1, 'first');
        RaChar = RaChar(1:I-1);
        dp = length(RaChar);
    end
        
    RaStart = RaChar(1);
    if dp == 1
        RaT = [RaStart ' \times 10^{' power '}'];
        if RaT(1:8) == '1 \times'
           RaT = RaT(9:end);
        end
    else
        RaEnd = char(extractBetween(RaChar, 2, dp));
        RaT = [RaStart '.' RaEnd ' \times 10^{' power '}'];
    end
    end
end