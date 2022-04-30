function Data = FunctionGetCloserCrossing(Data,G,Pr,Nx,Ny,thresh,SearchType,rempitch,prec,GetEigV,stab,lowPrScaling,res_list)
    GS = GtoGS(G);
    PrS = PrtoPrS(Pr);
    M = GetFullMZeronss(Data,GS,PrS,rempitch,res_list);
    [Done,RaA] = GetNextRaA2nss(M, SearchType,prec);
    while not(Done)
        Data = FunctionSolveSomeParam_nxny(Data,G,RaA,Pr,Nx,Ny,thresh,GetEigV,stab,lowPrScaling);
         M = GetFullMZeronss(Data,GS,PrS,rempitch,res_list);
        [Done,RaA] = GetNextRaA2nss(M, SearchType,prec);   
    end 
end

