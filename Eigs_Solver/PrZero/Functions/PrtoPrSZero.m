function PrS = PrtoPrSZero(Pr)
    PrChar = num2str(Pr,'%0.5e');
    PrStart = PrChar(1);
    PrChar = strrep(PrChar,'.','');
    power = num2str(floor(log10(Pr)));
    dp = find(PrChar(1:6) ~= '0', 1, 'last');
    if dp == 1
       PrS = convertCharsToStrings(['Pr_' PrStart 'e' power ]);        
    else
       PrEnd = char(extractBetween(PrChar, 2, dp)); 
       PrS = convertCharsToStrings(['Pr_' PrStart '_' PrEnd 'e' power ]);
        
    end
    PrS = strrep(PrS,'-','_'); % Does not like minus sign in naming
end

