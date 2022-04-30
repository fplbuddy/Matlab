function [PsiE,ThetaE] = CleanSteadyState(PsiE,ThetaE,N)
    [Rem,~,~,~] = GetRemKeep(N,0);
    PsiE(Rem) = 0;
    ThetaE(Rem) = 0;
end

