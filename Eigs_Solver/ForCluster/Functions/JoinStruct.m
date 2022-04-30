function Data = JoinStruct(d2,Data)
AR_list = string(fields(d2));
for i=1:length(AR_list) % Looping roudn aspect ratios
    ARS = AR_list(i);
    type_list = string(fields(d2.(ARS)));
    for i=1:length(type_list) % Looping round types
        type = type_list(i);
        PrS_list = string(fields(d2.(ARS).(type)));
        for i=1:length(PrS_list) % Looping round PrS
            PrS = PrS_list(i);
            RaS_list = string(fields(d2.(ARS).(type).(PrS)));
            for i=1:length(RaS_list) % Looping round RaS
                RaS = RaS_list(i);
                fn_list = string(fields(d2.(ARS).(type).(PrS).(RaS)));
                for i = 1:length(fn_list) % Looping round fields
                    fn = fn_list(i);
                    % Moving over data
                    Data.(ARS).(type).(PrS).(RaS).(fn) = d2.(ARS).(type).(PrS).(RaS).(fn);
                end
            end
        end
    end
end
end

