function M = MakeMatrixForEvenProblem(N,G, PsiE, ThetaE, Ra, Pr)
    n = [(-N/2+1):2:(N/2-1) (-N/2):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); 
    m = 1:N; m = repelem(m, N/2);
    kx = n*2*pi/G;
    ky = m*pi;
    Ktwo = kx.^2 + ky.^2;
    Ktwoinv = Ktwo.^-1;
    clear ky
    [PsiEexp, ThetaEexp] = Getexp(PsiE, ThetaE, N);
    clear PsiE ThetaE
    psi1 = zeros((N^2/2),(N^2/2)); psi2 = zeros((N^2/2),(N^2/2)); theta1 = zeros((N^2/2),(N^2/2));
    for i=1:length(n)
        ninst = n(i); minst = m(i);
        OnesWeWant = checkeenew(N,ninst, minst);
        iktfact = Ktwoinv(i);
        for j=1:length(OnesWeWant)
            modes = OnesWeWant(j,:);
            npert = modes(1); mpert = modes(2); nsteady = modes(3); msteady = modes(4);
            %if abs(neven) < N/2 % as we do not have this in the steady state.
            %will just add a 0 in the PsiE and ThetaE after we expand
            columninst = columnfindnew(N, npert, mpert);
            steadypos = steadypositionnew(N, nsteady, msteady);

            %iktfact = Ktwoinv(columninst);
            AFact = A(npert, mpert, nsteady, msteady,G, minst);
            PsiFact = PsiEexp(steadypos); ThetaFact = ThetaEexp(steadypos);
             
            % Adding to psi1
            psi1(i,columninst) = psi1(i,columninst) + (Square(npert,mpert,G) - Square(nsteady,msteady,G))*AFact*PsiFact*iktfact*(1i/2);
            % Adding psi2
            psi2(i,columninst) = psi2(i,columninst) + AFact*ThetaFact*(-1i/2);
            % Adding theta1
            theta1(i,columninst) = theta1(i,columninst) - AFact*PsiFact*(-1i/2);
        end   
    end
    clear OnesWeWant PsiEexp ThetaEexp n m

    M6 = -diag(Ktwo);
    M3 = Pr*M6;
    clear Ktwo
    M5 = diag(1i*kx);
    M2 = diag(-1i*Ra*Pr*Ktwoinv.*kx);
    clear kx Ktwoinv
    M = [M3+psi1 M2; M5+psi2 M6+theta1];
    clearvars -except M
end
