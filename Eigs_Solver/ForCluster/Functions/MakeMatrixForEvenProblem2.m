function M = MakeMatrixForEvenProblem2(N,G, PsiE, ThetaE, Ra, Pr)
    % Dont need nevenlist, as the two lists we work with are the same in
    % the even problem
    n = [(-N/2+1):2:(N/2-1) (-N/2):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); 
    m = 1:N; m = repelem(m, N/2);
    [~,~,n,m] = GetRemGeneral(n,m,N);
    nmax = max(n);
    positionMatrix = MakepositionMatrixEig(n,m);
    kx = n*2*pi/G;
    ky = m*pi;
    Ktwo = kx.^2 + ky.^2;
    Ktwoinv = Ktwo.^-1;
    clear ky
    [Remf,~,~,~] = GetRemKeep(N,1);
    [PsiE, ThetaE] = ExpandFields(Remf, PsiE, ThetaE);
    [PsiEexp, ThetaEexp] = Getexp(PsiE, ThetaE, N);
    clear PsiE ThetaE
    psi1 = zeros(length(n),length(n)); psi2 = zeros(length(n),length(n)); theta1 = zeros(length(n),length(n)); % Make big now, will reduce later
    for i=1:length(n)
        ninst = n(i); minst = m(i);
        OnesWeWant = checkeenew2(ninst, minst, N,n,m);
        
        %iktfact = Ktwoinv(i);
        iktfact = ((ninst*2*pi/G)^2 + (minst*pi)^2)^(-1);
        for j=1:length(OnesWeWant)
            modes = OnesWeWant(j,:);
            npert = modes(1); mpert = modes(2); neven = modes(3); meven = modes(4);
            %if abs(neven) < N/2 % as we do not have this in the steady state.
            %will just add a 0 in the PsiE and ThetaE after we expand
            rowinst =  positionMatrix(minst, ninst + 1 + nmax);
            columninst = positionMatrix(mpert, npert + 1 + nmax);
            steadypos = steadypositionnew(N, neven, meven);

            %iktfact = Ktwoinv(columninst);
            AFact = A(npert, mpert, neven, meven,G, minst);
            PsiFact = PsiEexp(steadypos); ThetaFact = ThetaEexp(steadypos);
             
            % Adding to psi1
            psi1(rowinst,columninst) = psi1(rowinst,columninst) + (Square(npert,mpert,G) - Square(neven,meven,G))*AFact*PsiFact*iktfact*(1i/2);
            % Adding psi2
            psi2(rowinst,columninst) = psi2(rowinst,columninst) + AFact*ThetaFact*(-1i/2);
            % Adding theta1
            theta1(rowinst,columninst) = theta1(rowinst,columninst) - AFact*PsiFact*(-1i/2);
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

