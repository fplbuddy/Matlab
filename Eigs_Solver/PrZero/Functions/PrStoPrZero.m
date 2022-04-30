function Pr = PrStoPrZero(PrS)
    PrS = convertStringsToChars(PrS);
    power = str2double(PrS(end));
    if PrS(end-1) == '_'
        power = -power;
    end
    if PrS(end-1) == '1'
        power = str2double(PrS(end-1:end));
    end
    eloc = find(PrS == 'e');
    numberbit = PrS(4:eloc-1);
    numberbit = strrep(numberbit,'_','.');
    numberbit = str2double(numberbit);
    Pr = numberbit*10^(power);
end

