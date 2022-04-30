function NL = NL(PsiEexp, ThetaEexp, N, ninst, minst, type, G)
NL = 0;
OnesWeWant = checkeenew(N, ninst, minst);
for i=1:length(OnesWeWant)
    n1 = OnesWeWant(i, 1);  m1 = OnesWeWant(i, 2);  n2 = OnesWeWant(i, 3);  m2 = OnesWeWant(i, 4);
    pos1 = steadypositionnew(N, n1, m1);
    pos2 = steadypositionnew(N, n2, m2);
    Factor1 = PsiEexp(pos1);
    if type == 1
        Factor2 = PsiEexp(pos2);
        NL = NL + Factor1*Factor2*A2(n1, m1, n2, m2, type, G,  minst);
    elseif type == 2
        Factor2 = ThetaEexp(pos2);
        NL = NL + Factor1*Factor2*A2(n1, m1, n2, m2, type, G,  minst);
    end
end
NL = NL*1i/2;
end

