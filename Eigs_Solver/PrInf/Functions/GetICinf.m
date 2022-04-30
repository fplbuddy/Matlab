function ThetaE = GetICinf(Ra, Data, AR, type,searchType)
RaS = RatoRaS(Ra);
if searchType == "CRa" % Closest Ra, same type and Ar
    RaString = string(fieldnames(Data.(AR).(type)));
    RaC = ClosestRa(Ra, RaString);
    ThetaE = Data.(AR).(type).(RaC).ThetaE;
elseif searchType == "Ctype" % Closest type, same Ra and Ar
    types = TypesinRainf(Data,AR,Ra);
    typeC = Closesttypeinf(type, types); % Getting closest type
    ThetaE = Data.(AR).(typeC).(RaS).ThetaE;
    % Need to extend as we do note have the same type
    Nnew = convertStringsToChars(type); Nnew = Nnew(3:end); Nnew = str2num(Nnew);
    Nold = convertStringsToChars(typeC); Nold = Nold(3:end); Nold = str2num(Nold);
    ThetaE = ExpandSteadyState2inf(ThetaE,Nold, Nnew);
elseif searchType == "CAr" % Closest Ar, same Ra and type
    ARs = ArinRainf(Data,type,Ra);
    ARC = ClosestAr(AR,ARs);
    ThetaE = Data.(ARC).(type).(RaS).ThetaE;
else
    try % Tries closest Ra in AR
        RaString = string(fieldnames(Data.(AR).(type)));
        RaC = ClosestRa(Ra, RaString);
        ThetaE = Data.(AR).(type).(RaC).ThetaE;
    catch % go down N
            types = string(fieldnames(Data.(AR)));
            typeC = Closesttypeinf(type, types); % Getting closest type   
            RaString = string(fieldnames(Data.(AR).(typeC)));
            RaC = ClosestRa(Ra, RaString)
            ThetaE = Data.(AR).(typeC).(RaC).ThetaE;      
            Nnew = convertStringsToChars(type); Nnew = Nnew(3:end); Nnew = str2num(Nnew);
            Nold = convertStringsToChars(typeC); Nold = Nold(3:end); Nold = str2num(Nold);
            ThetaE = ExpandSteadyState2inf(ThetaE,Nold, Nnew);
    end
    clearvars -except PsiE ThetaE
end
end
