function RaA = RaAStoRaA(RaAS)
    RaAS = convertStringsToChars(RaAS);
    power = str2double(RaAS(end));
    if RaAS(end-1) == '_'
        power = -power;
    end
    eloc = find(RaAS == 'e');
    numberbit = RaAS(5:eloc-1);
    numberbit = strrep(numberbit,'_','.');
    numberbit = str2double(numberbit);
    RaA = numberbit*10^(power);
end

