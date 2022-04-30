function tit = Modetit(Mode, type)
    Mode = convertStringsToChars(Mode);
    
    if convertCharsToStrings(type) == "ps"
        tit = ['\hat \psi_{' Mode(4) ',' Mode(6) '}'];
    elseif convertCharsToStrings(type) == "theta"
       tit = ['\hat \theta_{' Mode(4) ',' Mode(6) '}'];
    else
        type = input('ps or theta? (as char) ');
        tit = Modetit(Mode, type);
    end
end