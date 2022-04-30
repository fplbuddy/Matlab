function bS = BtoBs(b)
    RaChar = num2str(b);
    RaChar = strrep(RaChar,'.','');
    power = num2str(floor(log10(b)));
    RaStart = RaChar(1);
    bS = convertCharsToStrings(['Bsmall_' RaStart 'e' power ]);
end