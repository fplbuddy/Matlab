function [PsiE, ThetaE] = GetICZero(RaA, Pr, res,GS,PrZeroData)
    % Check that we GS, otherwise get closest
    try
       PrZeroData.(GS);
    catch
        G = GStoG(GS);
        GS = ClosestG(G, PrZeroData,0);
        GS
    end
    % Check that we have res, otherwise get closest
    try
       PrZeroData.(GS).(res);
       expand = 0;
    catch
        Nnew = restoN(res);
        res_list = string(fields( PrZeroData.(GS)));
        res = Closestres(res, res_list);
        Nold = restoN(res);
        expand  = 1;
    end
           

    PrS = PrtoPrSZero(Pr);  
    try % Tries closest Ra in same Pr
        RaAString_list = string(fieldnames(PrZeroData.(GS).(res).(PrS)));
        RaAC = ClosestRaAS(RaA, RaAString_list)
        PsiE = PrZeroData.(GS).(res).(PrS).(RaAC).PsiE;
        ThetaE = PrZeroData.(GS).(res).(PrS).(RaAC).ThetaE;
    catch % Tries closest Ra in closest Pr
        PrString = string(fieldnames(PrZeroData.(GS).(res)));
        PrC = ClosestPrZero(Pr, PrString)
        RaAString = string(fieldnames(PrZeroData.(GS).(res).(PrC)));
        RaAC = ClosestRaAS(RaA, RaAString)
        PsiE = PrZeroData.(GS).(res).(PrC).(RaAC).PsiE;
        ThetaE = PrZeroData.(GS).(res).(PrC).(RaAC).ThetaE;  
    end
    
    if expand
        [PsiE, ThetaE] = ExpandSteadyState2(PsiE,ThetaE,Nold, Nnew);
    end
    clearvars -except PsiE ThetaE
end
