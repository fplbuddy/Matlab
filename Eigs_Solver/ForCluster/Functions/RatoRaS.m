function RaS = RatoRaS(Ra)
    RaChar = num2str(Ra);
    RaChar = strrep(RaChar,'.','');
    power = num2str(floor(log10(Ra)));
    dp = find(RaChar ~= '0', 1, 'last');
    RaStart = RaChar(1);
    if dp == 1
        RaS = convertCharsToStrings(['Ra_' RaStart 'e' power ]);
    else
        RaEnd = char(extractBetween(RaChar, 2, dp));
        RaS = convertCharsToStrings(['Ra_' RaStart '_' RaEnd 'e' power ]);
    end
end