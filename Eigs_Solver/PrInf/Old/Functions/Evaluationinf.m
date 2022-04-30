function Evaluation = Evaluationinf(ThetaE, N, G, Ra)
% Works without stencils.
n = [1:2:(N/2-1) 0:2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:);
m = 1:N; m = repelem(m, N/4);
ThetaEexp = Getexpinf(ThetaE, N);

Evaluation = zeros(length(ThetaE),1);
clear ThetaE
for i=1:length(n)
    ninst = n(i); minst = m(i);
    kxinst = 2*pi*ninst/G; kyinst = pi*minst;
    K2 = kxinst^2 +  kyinst^2;
    pos = steadypositionnew(N, ninst, minst);
    Evaluation(i) = Ra*NLinf(ThetaEexp, N, ninst, minst, G) + ThetaEexp(pos)*(Ra*kxinst^2/K2^2-K2);
end

