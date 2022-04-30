function RaA = StoNormal(RaAS,len)
    RaAS = convertStringsToChars(RaAS);
    if RaAS(end) == 'f' % dealing with inf case
        RaA = Inf;
    else
    eloc = find(RaAS == 'e');
    if RaAS(eloc+1) == '_'
        power = -str2double(RaAS(eloc+2:end));
    else
        power = str2double(RaAS(eloc+1:end));
    end
    numberbit = RaAS(len:eloc-1);
    numberbit = strrep(numberbit,'_','.');
    numberbit = str2double(numberbit);
    RaA = numberbit*10^(power);
    end
end

