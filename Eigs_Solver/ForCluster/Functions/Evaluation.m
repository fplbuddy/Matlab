function Evaluation = Evaluation(PsiE, ThetaE, N, G, Ra, Pr)
% Works without stencils.
n = [1:2:(N/2-1) 0:2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:);
m = 1:N; m = repelem(m, N/4);
[PsiEexp, ThetaEexp] = Getexp(PsiE, ThetaE, N);

Evaluation = zeros(length(PsiE) + length(ThetaE),1);
clear PsiE ThetaE
for i=1:length(n)
    ninst = n(i); minst = m(i);
    kxinst = 2*pi*ninst/G; kyinst = pi*minst;
    pos = steadypositionnew(N, ninst, minst);
    Evaluation(i) = NL(PsiEexp, ThetaEexp, N, ninst, minst, 1, G) - 1i*kxinst*Ra*Pr*ThetaEexp(pos) - Pr*((kxinst^2 + kyinst^2)^2)*PsiEexp(pos);
    Evaluation(i + length(n)) = NL(PsiEexp, ThetaEexp, N, ninst, minst, 2, G) - 1i*kxinst*PsiEexp(pos) + (kxinst^2 + kyinst^2)*ThetaEexp(pos);
end
end

