function RaS = RatoRaS(Ra)
    RaChar = num2str(Ra);
    power = num2str(length(RaChar)-1);
    dp = find(RaChar ~= '0', 1, 'last');
    RaStart = RaChar(1);
    if dp == 1
        RaS = convertCharsToStrings(['Ra_' RaStart 'e' power ]);
    else
        RaEnd = char(extractBetween(RaChar, 2, dp));
        RaS = convertCharsToStrings(['Ra_' RaStart '_' RaEnd 'e' power ]);
    end
end