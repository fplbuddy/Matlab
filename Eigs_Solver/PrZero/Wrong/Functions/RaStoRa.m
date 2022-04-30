function Ra = RaStoRa(RaS)
    RaS = convertStringsToChars(RaS);
    RaS = RaS(4:end);
    power = str2num(RaS(end));
    Ra = str2num(RaS(1))*10^power;
    % adding other numbers
    if length(RaS) > 3
        ON = RaS(3:(end-2));
        for i=1:length(ON)
            Ra = Ra + str2num(ON(i))*10^(power-i);
        end
    end
end