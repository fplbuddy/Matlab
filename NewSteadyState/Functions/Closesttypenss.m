function [typeC, los] = Closesttypenss(type,types)
    [Nx,~] = typetoNxNy(type);
    typesN = zeros(length(types),1);
    for i = 1:length(typesN)
       inst = types(i);
       [inst,~] =  typetoNxNy(inst);
       typesN(i) = inst;
    end
    check = typesN - Nx;
    check = abs(check);
    [~,I] = min(check);
    typeC = types(I);
    [check,~] = typetoNxNy(typeC);
    if check < Nx
        los = 's';
    else
        los = 'l';
    end  
end

