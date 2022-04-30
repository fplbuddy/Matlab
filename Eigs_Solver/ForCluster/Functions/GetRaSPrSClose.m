function [RaC, PrC] = GetRaSPrSClose(Ra, Pr, Data, AR, type)
PrS = PrtoPrS(Pr);  
try % Tries closest Ra in same Pr
    RaString = string(fieldnames(Data.(AR).(type).(PrS)));
    RaC = ClosestRa(Ra, RaString);
    PrC = PrS;
catch 
    % Tries closest Ra in closest Pr
    PrString = string(fieldnames(Data.(AR).(type)));
    PrC = ClosestPr(Pr, PrString);
    RaString = string(fieldnames(Data.(AR).(type).(PrC)));
    RaC = ClosestRa(Ra, RaString);      
end
end