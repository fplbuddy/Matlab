function OEEFS =  OEEFtoOEEFS(OEEF)
    OEEFChar = num2str(OEEF);
    OEEFChar = strrep(OEEFChar,'.','');
    power = num2str(floor(log10(OEEF)));
    dp = find(OEEFChar ~= '0', 1, 'last');
    OEEFStart = OEEFChar(1);
    if dp == 1
        OEEFS = convertCharsToStrings(['OEEF_' OEEFStart 'e' power ]);
    else
        OEEFEnd = char(extractBetween(OEEFChar, 2, dp));
        OEEFS = convertCharsToStrings(['OEEF_' OEEFStart '_' OEEFEnd 'e' power ]);
    end
end

