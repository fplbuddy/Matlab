function M = AddtoM(M,Ra,sigma)
    Ras = M(1,:);
    sigmas = M(2,:);
    bigger = find(Ras > Ra,1);
    Ras = [Ras(1:bigger-1) Ra Ras(bigger:end)];
    sigmas = [sigmas(1:bigger-1) sigma sigmas(bigger:end)];
    M = [Ras ; sigmas];

end

