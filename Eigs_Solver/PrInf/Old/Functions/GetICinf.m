function ThetaE = GetICinf(Ra, Data, AR, type) 
    try % Tries closest Ra 
        RaString = string(fieldnames(Data.(AR).(type)));
        RaC = ClosestRa(Ra, RaString)
        ThetaE = Data.(AR).(type).(RaC).ThetaE;
    catch % Go down i type
        types = string(fieldnames(Data.(AR)));
        typeC = Closesttypeinf(type, types); % Getting closest type
        RaString = string(fieldnames(Data.(AR).(typeC)));
        RaC = ClosestRa(Ra, RaString);
        ThetaE = Data.(AR).(typeC).(PrC).(RaC).ThetaE;
        % Need to extend as we do note have the same type
        Nnew = convertStringsToChars(type); Nnew = Nnew(3:end); Nnew = str2num(Nnew);
        Nold = convertStringsToChars(typeC); Nold = Nold(3:end); Nold = str2num(Nold);
        ThetaE = ExpandSteadyStateinf(ThetaE,Nold, Nnew);
    end
    clearvars -except ThetaE
end
