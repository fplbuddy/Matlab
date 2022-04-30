function typeC = Closesttypeinf_nxny(type,types)
    [Nxwant,Nywant] = typetoNxNyinf(type);  
    check = zeros(length(types),1);
    for i=1:length(check)
        typecheck = types(i);
        [Nxcheck,Nycheck] = typetoNxNyinf(typecheck);
        check = max(Nxwant/Nxcheck, (Nxwant/Nxcheck)^(-1)) + max(Nywant/Nycheck, (Nywant/Nycheck)^(-1));         
    end
    [~,I] = min(check);
    typeC = types(I);
end

