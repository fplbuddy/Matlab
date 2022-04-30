function Evaluation = EvaluationOld(PsiE, ThetaE, Nx, Ny, G, Ra, Pr)
n = [1:2:(Nx/2-1) 0:2:(Nx/2-2)]; n = repmat(n, Ny/2); n = n(1,:);
m = 1:Ny; m = repelem(m, Nx/4);

Evaluation = zeros(length(PsiE) + length(ThetaE),1);
for i=1:length(n)
    ninst = n(i); minst = m(i);
    kxinst = 2*pi*ninst/G; kyinst = pi*minst;
    %checkee = checkee(Nx, Ny, ninst, minst);
    pos = findposition(ninst, minst, Nx);
    Evaluation(i) = NLOld(PsiE, ThetaE, Nx, Ny, ninst, minst, 1, G) - 1i*kxinst*Ra*Pr*ThetaE(pos) - Pr*((kxinst^2 + kyinst^2)^2)*PsiE(pos);
    Evaluation(i + length(n)) = NLOld(PsiE, ThetaE, Nx, Ny, ninst, minst, 2, G) - 1i*kxinst*PsiE(pos) + (kxinst^2 + kyinst^2)*ThetaE(pos);
end
end

