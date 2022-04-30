function [J,Eval] = EvaluationAndJac2_nxny(PsiE, ThetaE, Ra, Pr,G,n,m,Nx,Ny,positionMatrix)
    len = length(PsiE);
    J = zeros(len*2, len*2); % will make bigger now to help with positioning and will reduce later
    %[PsiEexp, ThetaEexp] = ExpandFields(Rem, PsiE, ThetaE); dont think we
    %want this now
    NLpsi = zeros(length(PsiE),1);
    NLtheta = zeros(length(PsiE),1);
    for i=1:length(n) % Only neeed to looop round psi bit
        ninst = n(i); minst = m(i);
        OnesWeWant = OWWee_nxny(ninst,minst, n,m,Nx,Ny);
        for j=1:length(OnesWeWant)
            n1 = OnesWeWant(j, 1);  m1 = OnesWeWant(j, 2);  n2 = OnesWeWant(j, 3);  m2 = OnesWeWant(j, 4);
            % do the NL stuff dor eveluatuon first
            % getting which regime we are in ee, oe, etc
            parity1 = rem(n1+m1,2); parity2 = rem(n2+m2,2);
            if not(parity1) && not(parity2) % eveneven
                sign1 = -f(m2,m1,minst)*f(n1,n2,ninst);
                sign2 = f(m1,m2,minst)*f(n2,n1,ninst);
            else % oddodd
                sign1 = f(m2,m1,minst)*f(n2,n1,ninst);
                sign2 = -f(m1,m2,minst)*f(n1,n2,ninst);
            end
            squareBracetAndOveralFact = (pi^2/2)*(n1*m2*sign1+n2*m1*sign2);
            if ninst == 0
                if rem(minst,2)
                    squareBracetAndOveralFact = squareBracetAndOveralFact*2; % adding the factor of 2 that I am not sure where it has come from in kx = 0 modes
                else
                    squareBracetAndOveralFact = 0;
                end
            end

            %pos1 = steadypossmall(N, n1, m1); pos2 = steadypossmall(N, n2, m2);
            pos1 = positionMatrix(m1,n1+1); pos2 = positionMatrix(m2,n2+1);
            % adding to psi
            NLpsi(i) = NLpsi(i) + squareBracetAndOveralFact*Ksquared(n2,m2,G)*PsiE(pos1)*PsiE(pos2);
            %possteady = steadypossmall(N, ninst, minst);
            possteady = positionMatrix(minst, ninst+1);
            J(possteady,pos1) = J(possteady,pos1) + squareBracetAndOveralFact*Ksquared(n2,m2,G)*PsiE(pos2);
            J(possteady,pos2) = J(possteady,pos2) + squareBracetAndOveralFact*Ksquared(n2,m2,G)*PsiE(pos1);

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

            J(possteady+len,pos1) = J(possteady+len,pos1) + squareBracetAndOveralFact*ThetaE(pos2); % the minus sign is here because sign1 and sign2 are reversed for the heat eq non-linearity
            J(possteady+len,pos2+len) = J(possteady+len,pos2+len) + squareBracetAndOveralFact*PsiE(pos1); % the minus sign is here because sign1 and sign2 are reversed for the heat eq non-linearity
        end
    end
    % adding non-linear terms
    % eval
    kx = (2*pi/G)*n';
    K2 = ((2*pi/G)*n').^2 + (pi*m').^2;
    K4 = K2.^2;
    Eval1 = NLpsi + (G/2)*(Ra*Pr*kx.*ThetaE + Pr*K4.*PsiE); % removed sign vector
    Eval2 = NLtheta + (G/2)*(kx.*PsiE + K2.*ThetaE);
    Eval = [Eval1; Eval2];
    % jacob
    J = J + (G/2)*[diag(Pr*K4) diag(Ra*Pr*kx); diag(kx) diag(K2)];
end

