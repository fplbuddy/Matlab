function Pr = PrStoPr(PrS)
if length(PrS) == 1
    PrS = convertStringsToChars(PrS); % Making sure it is chars
end
if contains(PrS,'e') % do zero version
    
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
    
else
    under = strfind(PrS,'_'); % Checking location of underscore
    if length(under) == 2 % we have two underscorsed, so there are decimal points
        Start = str2double(PrS(under(1)+1:under(2)-1)); % We be zero if < 1
        End = str2double(PrS(under(2)+1:end)); % The actual number, now we only need power
        %div = ceil(log10(End))
        div = length(PrS) - (under(2));
        Pr = Start + End/(10^div);
    else
        Pr = str2double(PrS(4:end));
    end
end
end

