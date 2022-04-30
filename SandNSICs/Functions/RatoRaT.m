function RaT = RatoRaT(Ra)
    RaChar = num2str(Ra);
    power = num2str(length(RaChar)-1);
    dp = find(RaChar ~= '0', 1, 'last');
    RaStart = RaChar(1);
    if dp == 1
        RaT = [RaStart ' \times 10^' power ];
    else
        RaEnd = char(extractBetween(RaChar, 2, dp));
        RaT = [RaStart '.' RaEnd ' \times 10^' power ];
    end
end