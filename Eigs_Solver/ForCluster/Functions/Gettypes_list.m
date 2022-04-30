function types_list = Gettypes_list(Data,PrS, AR)
    types_list = string(fields(Data.(AR)));
    rem = [];
    for i=1:length(types_list)
        type = types_list(i);
        try
            Data.(AR).(type).(PrS);
        catch
            rem = [rem i];
        end       
    end
    types_list(rem) = [];
    types_list = Ordertypes_list(types_list);
end
