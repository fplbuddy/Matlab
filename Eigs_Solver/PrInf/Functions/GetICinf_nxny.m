function ThetaE = GetICinf_nxny(Ra, Data, AR, type,searchType)
RaS = RatoRaS(Ra);
if searchType == "CRa" % Closest Ra, same type and Ar
    RaString = string(fieldnames(Data.(AR).(type)));
    RaC = ClosestRa(Ra, RaString);
    ThetaE = Data.(AR).(type).(RaC).ThetaE;
elseif searchType == "Ctype" % Closest type, same Ra and Ar
    types = TypesinRainf(Data,AR,Ra);
    typeC = Closesttypeinf_nxny(type, types); % Getting closest type
    ThetaE = Data.(AR).(typeC).(RaS).ThetaE;
    % Need to extend as we do note have the same type
    [Nxnew,Nynew] = typetoNxNyinf(type);
    [Nxold,Nyold] = typetoNxNyinf(typeC);
    ThetaE = ExpandSteadyStateinf_nxny(ThetaE,Nxold,Nyold,Nxnew,Nynew);
elseif searchType == "CAr" % Closest Ar, same Ra and type
    ARs = ArinRainf(Data,type,Ra);
    ARC = ClosestAr(AR,ARs);
    ThetaE = Data.(ARC).(type).(RaS).ThetaE;
end
end
