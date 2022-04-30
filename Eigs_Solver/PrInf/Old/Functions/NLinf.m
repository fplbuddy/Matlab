function NL = NLinf(ThetaEexp, N, ninst, minst, G)
NL = 0;
OnesWeWant = checkeenew(N, ninst, minst);
for i=1:length(OnesWeWant)
    n1 = OnesWeWant(i, 1);  m1 = OnesWeWant(i, 2);  n2 = OnesWeWant(i, 3);  m2 = OnesWeWant(i, 4);
    pos1 = steadypositionnew(N, n1, m1);
    pos2 = steadypositionnew(N, n2, m2);
    Factor1 = ThetaEexp(pos1);
    Factor2 = ThetaEexp(pos2);
    NL = NL + Factor1*Factor2*A2inf(n1, m1, n2, m2, G,  minst);
end
NL = NL*1i/2;
end

