function AmpS = AmptoAmpS(Amp)
    AmpChar = num2str(Amp,'%0.5e');
    AmpStart = AmpChar(1);
    AmpChar = strrep(AmpChar,'.','');
    power = num2str(floor(log10(Amp)));
    dp = find(AmpChar(1:6) ~= '0', 1, 'last');
    if dp == 1
       AmpS = convertCharsToStrings(['Amp_' AmpStart 'e' power ]);        
    else
       AmpEnd = char(extractBetween(AmpChar, 2, dp)); 
       AmpS = convertCharsToStrings(['Amp_' AmpStart '_' AmpEnd 'e' power ]);
        
    end
    AmpS = strrep(AmpS,'-','_'); % Does not like minus sign in naming
end

