function M = MakeMatrixForOddProbleminf(N,G, ThetaE, Ra)
    n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); 
    m = 1:N; m = repelem(m, N/2);
    kx = n*2*pi/G;
    ky = m*pi;
    Ktwo = kx.^2 + ky.^2;
    Kfour = (kx.^2 + ky.^2).^2;
    Kfourinv = Kfour.^-1;
    kx2 = kx.^2;
    kx2Kfour = kx2./Kfour;
    clear ky
    ThetaEexp = Getexpinf(ThetaE, N);
    clear ThetaE
    theta1 = zeros((N^2/2),(N^2/2));
    for i=1:length(n)
        ninst = n(i); minst = m(i);
        OnesWeWant = checkoenew(ninst, minst, N);;
        for j=1:length(OnesWeWant)
            modes = OnesWeWant(j,:);
            npert = modes(1); mpert = modes(2); nsteady = modes(3); msteady = modes(4);
            %if abs(neven) < N/2 % as we do not have this in the steady state.
            %will just add a 0 in the PsiE and ThetaE after we expand
            columninst = columnfindnew(N, npert, mpert);
            steadypos = steadypositionnew(N, nsteady, msteady);

            %iktfact = Ktwoinv(columninst);
            AFact = A(npert, mpert, nsteady, msteady,G, minst);
            ThetaFact = ThetaEexp(steadypos);
            theta1(i,columninst) = theta1(i,columninst) + (PreFact(npert,mpert,G) - PreFact(nsteady,msteady,G))*AFact*ThetaFact*(1i/2);
        end   
    end
    clear OnesWeWant ThetaEexp n m
    M = diag(Ra*kx2Kfour - Ktwo) + theta1;
    clearvars -except M
end
