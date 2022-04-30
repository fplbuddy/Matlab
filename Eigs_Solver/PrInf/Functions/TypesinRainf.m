function types = TypesinRainf(Data,AR,Ra)
% Takes a Ra and AR finds which types we have for that Ra
types = [];
RaS = RatoRaS(Ra);
alltype = string(fieldnames(Data.(AR)));
for i=1:length(alltype)
    type = alltype(i);
    RaS_list = string(fieldnames(Data.(AR).(type)));
    for k=1:length(RaS_list)
        if RaS ==  RaS_list(k)
            types = [types type];
            break
        end
    end
end
end

