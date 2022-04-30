function rS = rtorS(r)
    RaChar = num2str(r);
    RaChar = strrep(RaChar,'.','');
    power = num2str(floor(log10(r)));
    dp = find(RaChar ~= '0', 1, 'last');
    RaStart = RaChar(1);
    if dp == 1
        rS = convertCharsToStrings(['r_' RaStart 'e' power ]);
    else
        RaEnd = char(extractBetween(RaChar, 2, dp));
        rS = convertCharsToStrings(['r_' RaStart '_' RaEnd 'e' power ]);
    end
end