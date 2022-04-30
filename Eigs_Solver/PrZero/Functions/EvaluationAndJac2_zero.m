function [J,Eval] = EvaluationAndJac2_zero(PsiE, Ra,G,n,m,Nx,Ny,positionMatrix)
    len = length(PsiE);
    J = zeros(len, len); % will make bigger now to help with positioning and will reduce later
    %[PsiEexp, ThetaEexp] = ExpandFields(Rem, PsiE, ThetaE); dont think we
    %want this now
    NLpsi = zeros(length(PsiE),1);
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
        end
    end
    % adding non-linear terms
    % eval
    kx = (2*pi/G)*n';
    kx2 = kx.^2;
    K2 = ((2*pi/G)*n').^2 + (pi*m').^2;
    K4 = K2.^2;
    Eval = NLpsi + (G/2)*(-Ra*kx2.*PsiE./K2 + K4.*PsiE); % removed sign vector
    % jacob
    J = J + (G/2)*diag(K4-Ra*kx2./K2);
end

