function NL = NLOld(PsiE, ThetaE, Nx, Ny, ninst, minst, type, G)
NL = 0;
modepairs = checkeeOld(Nx, Ny, ninst, minst);
s = size(modepairs);
for i=1:s(1)
    n1 = modepairs(i, 1);  m1 = modepairs(i, 2);  n2 = modepairs(i, 3);  m2 = modepairs(i, 4);
    Factor1 = PsiE(findposition(n1, m1, Nx)); if sign(n1) == -1; Factor1 = conj(Factor1); end % Taking complex conjugate if needed
    if type == 1
        Factor2 = PsiE(findposition(n2, m2, Nx)); if sign(n2) == -1; Factor2 = conj(Factor2); end
        NL = NL + Factor1*Factor2*A2(n1, m1, n2, m2, type, G,  minst);
    elseif type == 2
        Factor2 = ThetaE(findposition(n2, m2, Nx)); if sign(n2) == -1; Factor2 = conj(Factor2); end
        NL = NL + Factor1*Factor2*A2(n1, m1, n2, m2, type, G,  minst);
    end
end
NL = NL*1i/2;
end

