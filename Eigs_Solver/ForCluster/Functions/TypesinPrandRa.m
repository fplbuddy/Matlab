function types = TypesinPrandRa(Data,PrS,AR,RaS)
% Takes a Pr and Ra and finds which types we have for that Pr and Ra
types = [];
alltype = string(fieldnames(Data.(AR)));
for i=1:length(alltype)
    type = alltype(i);
    PrS_list = string(fieldnames(Data.(AR).(type)));
    for j=1:length(PrS_list)
        if PrS ==  PrS_list(j)
            RaS_list = string(fieldnames(Data.(AR).(type).(PrS_list(j))));
            for k=1:length(RaS_list)
                if RaS ==  RaS_list(k)
                    types = [types type];
                    break
                end
            end
        end
    end   
end
end

