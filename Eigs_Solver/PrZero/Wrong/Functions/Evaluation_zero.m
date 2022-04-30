function Evaluation = Evaluation_zero(PsiE, N, G, Ra)
% Works without stencils.
n = [1:2:(N/2-1) 0:2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:);
m = 1:N; m = repelem(m, N/4);
PsiEexp = Getexp_zero(PsiE, N);

Evaluation = zeros(length(PsiE),1);
clear PsiE 
for i=1:length(n)
    ninst = n(i); minst = m(i);
    kxinst = 2*pi*ninst/G; kyinst = pi*minst;
    pos = steadypositionnew(N, ninst, minst);
    K2 = kxinst^2 + kyinst^2;
    Evaluation(i) = NL_zero(PsiEexp, N, ninst, minst, G) + (Ra*K2^(-1)*kxinst^2-K2^2)*PsiEexp(pos);
end
end

