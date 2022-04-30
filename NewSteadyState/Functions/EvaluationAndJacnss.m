function [J,Eval] = EvaluationAndJacnss(PsiE, ThetaE, Ra, Pr,G,Rem,n,m, signvector,lowPrScaling)
len = length(PsiE)+length(Rem);
J = zeros(len*2, len*2); % will make bigger now to help with positioning and will reduce later
[PsiEexp, ThetaEexp] = ExpandFields(Rem, PsiE, ThetaE);
nmax = max(n);
NLpsi = zeros(length(PsiE),1);
NLtheta = zeros(length(PsiE),1);
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
        
        % now do theta
        if not(parity1) && not(parity2) % eveneven
            sign1 = -h(m2,m1,minst);
            sign2 = -h(m1,m2,minst)*h(ninst,n1,n2);
        elseif parity1 && parity2 % oddodd
            sign1 = h(m2,m1,minst)*h(ninst,n1,n2);
            sign2 = h(m1,m2,minst);
        elseif parity1 && not(parity2) % oddeven
            sign1 = -h(m2,m1,minst)*h(n2,n1,ninst);
            sign2 = h(m1,m2,minst)*h(n1,n2,ninst);
        else % evenodd
            sign1 = h(m2,m1,minst)*h(n1,n2,ninst);
            sign2 = -h(m1,m2,minst)*h(n2,n1,ninst);
        end
        squareBracetAndOveralFact = (pi^2/2)*(n1*m2*sign1+n2*m1*sign2);
        if ninst == 0
            if not(rem(minst,2))
                squareBracetAndOveralFact = squareBracetAndOveralFact*2; % adding the factor of 2 that I am not sure where it has come from in kx = 0 modes.
            else
                squareBracetAndOveralFact = 0;
            end
        end
        
        NLtheta(i) = NLtheta(i) + squareBracetAndOveralFact*PsiEexp(pos1)*ThetaEexp(pos2);
        
        J(possteady+len,pos1) = J(possteady+len,pos1) + squareBracetAndOveralFact*ThetaEexp(pos2); % the minus sign is here because sign1 and sign2 are reversed for the heat eq non-linearity
        J(possteady+len,pos2+len) = J(possteady+len,pos2+len) + squareBracetAndOveralFact*PsiEexp(pos1); % the minus sign is here because sign1 and sign2 are reversed for the heat eq non-linearity
    end
end
% adding non-linear terms
% eval
kx = (2*pi/G)*n';
K2 = ((2*pi/G)*n').^2 + (pi*m').^2;
K4 = K2.^2;
J([Rem Rem+len],:) = []; % fist we clean it up
J(:,[Rem Rem+len]) = [];
W = Pr^(lowPrScaling-1); % from thualt
% Theta bit is the same as W
Eval1 = NLpsi + (G/2)*(Ra*kx.*ThetaE/W - K4.*PsiE.*signvector/W);
Eval2 = NLtheta + (G/2)*(kx.*PsiE/(Pr*W) + K2.*ThetaE.*(-signvector)/(Pr*W));
Eval = [Eval1; Eval2];
J = J + (G/2)*[diag(-K4.*signvector/W) diag(Ra*kx/W); diag(kx/(Pr*W)) diag(K2.*(-signvector)/(Pr*W))];
end

