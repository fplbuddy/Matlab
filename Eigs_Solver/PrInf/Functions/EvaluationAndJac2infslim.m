function [J,Eval] = EvaluationAndJac2infslim(ThetaE, Ra,G,n,m,N,positionMatrix)
    % making PsiE
    K2 = ((2*pi/G)*n').^2 + (pi*m').^2;
    K4 = K2.^2;
    kx = (2*pi/G)*n';
    PsiE = -Ra*ThetaE.*kx./K4;   
    len = length(ThetaE);
    J = zeros(len, len); 
    NLtheta = zeros(len,1);
    for i=1:length(n) 
        ninst = n(i); minst = m(i);
        OnesWeWant = OWWee(ninst,minst, n,m,N);
        for j=1:length(OnesWeWant)
            n1 = OnesWeWant(j, 1);  m1 = OnesWeWant(j, 2);  n2 = OnesWeWant(j, 3);  m2 = OnesWeWant(j, 4);
            % do the NL stuff dor eveluatuon first
            % getting which regime we are in ee, oe, etc
            parity1 = rem(n1+m1,2); parity2 = rem(n2+m2,2);
            pos1 = positionMatrix(m1,n1+1); pos2 = positionMatrix(m2,n2+1);
            possteady = positionMatrix(minst, ninst+1);

            % now do theta
            if not(parity1) && not(parity2) % eveneven
                sign1 = -f(m2,m1,minst);
                sign2 = -f(m1,m2,minst)*f(ninst,n1,n2);
            else  % oddodd
                sign1 = f(m2,m1,minst)*f(ninst,n1,n2);
                sign2 = f(m1,m2,minst);
            end
            squareBracetAndOveralFact = (pi^2/2)*(n1*m2*sign1+n2*m1*sign2);
            if ninst == 0
                if not(rem(minst,2))
                    squareBracetAndOveralFact = squareBracetAndOveralFact*2; % adding the factor of 2 that I am not sure where it has come from in kx = 0 modes.
                else
                    squareBracetAndOveralFact = 0;
                end
            end

            NLtheta(i) = NLtheta(i) + squareBracetAndOveralFact*PsiE(pos1)*ThetaE(pos2);

            J(possteady,pos1) = J(possteady,pos1) + squareBracetAndOveralFact*ThetaE(pos2); % the minus sign is here because sign1 and sign2 are reversed for the heat eq non-linearity
            J(possteady,pos2) = J(possteady,pos2) + squareBracetAndOveralFact*PsiE(pos1); % the minus sign is here because sign1 and sign2 are reversed for the heat eq non-linearity
        end
    end
    % adding non-linear terms
    % eval
    Eval = NLtheta + (G/2)*(kx.*PsiE + K2.*ThetaE);
    % jacob
    J = J + (G/2)*(diag(Ra*kx.^2./K4) + diag(K2)); % think there should be a minus sign here (first term). Think we have moved things over to the non-linearity side and not the other way round
    % somehow this minus sign seems to be correct
end

