function RaAS = normaltoS(RaA,pre,c)
% c is if we want character or not
if RaA == Inf
    RaAS = [pre '_Inf'];
else
if RaA == 0
    RaAS = [pre '_0e1'];
else
    RaAChar = num2str(RaA,'%0.5e');
    RaAStart = RaAChar(1);
    RaAChar = strrep(RaAChar,'.','');
    power = num2str(floor(log10(RaA)));
    dp = find(RaAChar(1:6) ~= '0', 1, 'last');
    if dp == 1
        RaAS = convertCharsToStrings([pre '_' RaAStart 'e' power ]);
    else
        PrEnd = char(extractBetween(RaAChar, 2, dp));
        RaAS = convertCharsToStrings([pre '_' RaAStart '_' PrEnd 'e' power ]);   
    end
    RaAS = strrep(RaAS,'-','_'); % Does not like minus sign in naming
end
end


if c
    RaAS = convertStringsToChars(RaAS);
end
end