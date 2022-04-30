function RaAS = RaAtoRaAS(RaA)
    RaAChar = num2str(RaA,'%0.5e');
    RaAStart = RaAChar(1);
    RaAChar = strrep(RaAChar,'.','');
    power = num2str(floor(log10(RaA)));
    dp = find(RaAChar(1:6) ~= '0', 1, 'last');
    if dp == 1
       RaAS = convertCharsToStrings(['RaA_' RaAStart 'e' power ]);        
    else
       PrEnd = char(extractBetween(RaAChar, 2, dp)); 
       RaAS = convertCharsToStrings(['RaA_' RaAStart '_' PrEnd 'e' power ]);
        
    end
    RaAS = strrep(RaAS,'-','_'); % Does not like minus sign in naming
end