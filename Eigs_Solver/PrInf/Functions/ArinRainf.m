function ARs = ArinRainf(Data,type,Ra)
% Takes a Ra and AR finds which types we have for that Ra
ARs = [];
RaS = RatoRaS(Ra);
allARs = string(fieldnames(Data));
for i=1:length(allARs)
    AR = allARs(i);
    alltype = string(fieldnames(Data.(AR)));
    for k=1:length(alltype)
        if alltype(k) == type
            RaS_list = string(fieldnames(Data.(AR).(type)));
            for j=1:length(RaS_list)
                if RaS ==  RaS_list(j)
                    ARs = [ARs AR];
                    break
                end
            end
        end
    end
end

