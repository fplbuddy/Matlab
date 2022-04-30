function M = MakeMatrixForOddProblemWNLcheck(N,G, PsiE, ThetaE, Ra, Pr)
    n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); 
    m = 1:N; m = repelem(m, N/2);
    [~,~,n,m] = GetRemGeneral(n,m,N);
    nmax = max(n);
    positionMatrix = MakepositionMatrixEig(n,m);
    nevenlist = [-(N/2-1):2:(N/2-1) -(N/2):2:(N/2-2)]; nevenlist = repmat(nevenlist, N/2); nevenlist = nevenlist(1,:); % We want the negative ones here also, they might not appear actually... they will!
    mevenlist = 1:N; mevenlist = repelem(mevenlist, N/2);
    [~,~,nevenlist,mevenlist] = GetRemGeneral(nevenlist,mevenlist,N);
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
        OnesWeWant = checkoenew2(ninst, minst, N,nevenlist,mevenlist);
        %iktfact = Ktwoinv(i);
        iktfact = ((ninst*2*pi/G)^2 + (minst*pi)^2)^(-1);
        for j=1:length(OnesWeWant)
            modes = OnesWeWant(j,:);
            nodd = modes(1); modd = modes(2); neven = modes(3); meven = modes(4);
            %if abs(neven) < N/2 % as we do not have this in the steady state.
            %will just add a 0 in the PsiE and ThetaE after we expand
            rowinst =  positionMatrix(minst, ninst + 1 + nmax);
            columninst = positionMatrix(modd, nodd + 1 + nmax);
            steadypos = steadypositionnew(N, neven, meven);

            %iktfact = Ktwoinv(columninst);
            AFact = A(nodd, modd, neven, meven,G, minst);
            PsiFact = PsiEexp(steadypos); ThetaFact = ThetaEexp(steadypos);
             
            % Adding to psi1
            psi1(rowinst,columninst) = psi1(rowinst,columninst) + (Square(nodd,modd,G) - Square(neven,meven,G))*AFact*PsiFact*iktfact*(1i/2);
            % Adding psi2
            psi2(rowinst,columninst) = psi2(rowinst,columninst) + AFact*ThetaFact*(-1i/2);
            % Adding theta1
            theta1(rowinst,columninst) = theta1(rowinst,columninst) - AFact*PsiFact*(-1i/2);
        end   
    end
    clear OnesWeWant PsiEexp ThetaEexp n m

    M6 = -diag(Ktwo)/Pr;
    M3 = Pr*M6; % dont want a Pr overall
    clear Ktwo
    M5 = diag(1i*kx)/Pr;
    M2 = diag(-1i*Ra*Ktwoinv.*kx);
    clear kx Ktwoinv
    M = [M3+psi1 M2; M5+psi2 M6+theta1];
    clearvars -except M
end

