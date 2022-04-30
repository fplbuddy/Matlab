function [J,Eval] = EvaluationAndJacPrZss(PsiE, Ra,G,Rem,n,m, signvector)
len = length(PsiE)+length(Rem);
J = zeros(len, len); % will make bigger now to help with positioning and will reduce later
[PsiEexp, ~] = ExpandFields(Rem, PsiE, PsiE);
nmax = max(n);
NLpsi = zeros(length(PsiE),1);
for i=1:length(n) % Only neeed to looop round psi bit
    ninst = n(i); minst = m(i);
    OnesWeWant = OWWoldnss(ninst,minst, n,m);
    for j=1:length(OnesWeWant)
        n1 = OnesWeWant(j, 1);  m1 = OnesWeWant(j, 2);  n2 = OnesWeWant(j, 3);  m2 = OnesWeWant(j, 4);
        % do the NL stuff dor eveluatuon first
        % getting which regime we are in ee, oe, etc
        parity1 = rem(n1+m1,2); parity2 = rem(n2+m2,2);
        if not(parity1) && not(parity2) % eveneven
            sign1 = -h(m2,m1,minst)*h(n1,n2,ninst);
            sign2 = h(m1,m2,minst)*h(n2,n1,ninst);
        elseif parity1 && parity2 % oddodd
            sign1 = h(m2,m1,minst)*h(n2,n1,ninst);
            sign2 = -h(m1,m2,minst)*h(n1,n2,ninst);
        elseif parity1 && not(parity2) % oddeven
            sign1 = -h(m2,m1,minst)*h(ninst,n1,n2);
            sign2 = -h(m1,m2,minst);
        else % evenodd
            sign1 = h(m2,m1,minst);
            sign2 = h(m1,m2,minst)*h(ninst,n1,n2);
        end
        squareBracetAndOveralFact = (pi^2/2)*(n1*m2*sign1+n2*m1*sign2);
        if ninst == 0
            if rem(minst,2)
                squareBracetAndOveralFact = squareBracetAndOveralFact*2; % adding the factor of 2 that I am not sure where it has come from in kx = 0 modes
            else
                squareBracetAndOveralFact = 0;
            end
        end
        
        
        pos1 = GetPos(n1,m1,nmax); pos2 = GetPos(n2,m2,nmax);
        % adding to psi
        
        NLpsi(i) = NLpsi(i) + squareBracetAndOveralFact*Ksquared(n2,m2,G)*PsiEexp(pos1)*PsiEexp(pos2);
        possteady = GetPos(ninst,minst,nmax);
        J(possteady,pos1) = J(possteady,pos1) + squareBracetAndOveralFact*Ksquared(n2,m2,G)*PsiEexp(pos2);
        J(possteady,pos2) = J(possteady,pos2) + squareBracetAndOveralFact*Ksquared(n2,m2,G)*PsiEexp(pos1);
    end
end
% adding non-linear terms
% eval
kx = (2*pi/G)*n';
K2 = ((2*pi/G)*n').^2 + (pi*m').^2;
K4 = K2.^2;
J(Rem,:) = []; % fist we clean it up
J(:,Rem ) = [];
Eval = NLpsi + (G/2)*(Ra*kx.^2.*K2.^(-1) - K4).*PsiE.*signvector;
J = J + (G/2)*diag((Ra*kx.^2.*K2.^(-1)-K4).*signvector);
end

