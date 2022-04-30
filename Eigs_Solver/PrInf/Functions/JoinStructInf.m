function Data = JoinStructInf(d2,Data)
AR_list = string(fields(d2));
for i=1:length(AR_list) % Looping roudn aspect ratios
    ARS = AR_list(i);
    type_list = string(fields(d2.(ARS)));
    for i=1:length(type_list) % Looping round types
        type = type_list(i);
        RaS_list = string(fields(d2.(ARS).(type)));
        for i=1:length(RaS_list) % Looping round RaS
            RaS = RaS_list(i);
            fn_list = string(fields(d2.(ARS).(type).(RaS)));
            for i = 1:length(fn_list) % Looping round fields
                fn = fn_list(i);
                % Moving over data
                Data.(ARS).(type).(RaS).(fn) = d2.(ARS).(type).(RaS).(fn);
            end
        end
    end
end
end

