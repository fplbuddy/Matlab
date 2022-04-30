function types_list = Ordertypes_list(types_list)
    N_list = zeros(length(types_list),1);
    for i=1:length(N_list)
       inst = convertStringsToChars(types_list(i)); inst = inst(7:end); inst = str2num(inst);
       N_list(i) = inst;
    end
    [~,I] = sort(N_list);
    types_list = types_list(I);
end

