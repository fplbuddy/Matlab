function typeC = Closesttype(type,types)
    typeN = convertStringsToChars(type); typeN = typeN(7:end); typeN = str2num(typeN);
    typesN = zeros(length(types),1);
    for i = 1:length(typesN)
       inst = types(i);
       inst = convertStringsToChars(inst); inst = inst(7:end); inst = str2num(inst);
       typesN(i) = inst;
    end
    check = typesN - typeN;
    types(check > 0) = [];
    check(check > 0) = []; % Remove types which have larger N
    check = abs(check);
    [~,I] = min(check);
    typeC = types(I);
end

