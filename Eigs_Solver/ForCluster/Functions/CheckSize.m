function [PsiE, ThetaE] = CheckSize(PsiE, ThetaE,N)
if length(PsiE) == N^2/4 % then we need to reduce size
    [Rem,~,~,~] = GetRemKeep(N,1);
    PsiE(Rem) = [];
    ThetaE(Rem) = [];   
end

end

