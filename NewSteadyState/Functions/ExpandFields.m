function [PsiEexp, ThetaEexp] = ExpandFields(Rem, PsiE, ThetaE)
PsiEexp = PsiE;
ThetaEexp = ThetaE;
for i=1:length(Rem)
   add = Rem(i);
   PsiEexp = [PsiEexp(1:add-1); 0; PsiEexp(add:end)]; 
   ThetaEexp = [ThetaEexp(1:add-1); 0; ThetaEexp(add:end)]; 
end
end

