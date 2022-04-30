function thing = GetClosestPrWithSomething(Data,AR, type, myPrS, Something, RaS)
PrS_list = string(fields(Data.(AR).(type)));
PrS_list(PrS_list == myPrS) = [];
ngot = 1;
while ngot
    PrS = ClosestPr(PrStoPr(myPrS), PrS_list);
    try
    if isfield(Data.(AR).(type).(PrS).(RaS), Something)
        thing = Data.(AR).(type).(PrS).(RaS).(Something);
        ngot = 0;
    else
        PrS_list(PrS_list == PrS) = [];
    end
    catch
        PrS_list(PrS_list == PrS) = [];
        if length(PrS_list) == 0
            Error % Checking if we do not have any PrS left.. In which case, we will have to solve the whole problem to find xodd
        end
    end
end
end

