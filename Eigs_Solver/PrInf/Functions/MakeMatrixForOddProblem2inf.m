function M = MakeMatrixForOddProblem2inf(N,G, ThetaE, Ra)
    n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); 
    m = 1:N; m = repelem(m, N/2);
    [~,~,n,m] = GetRemGeneral(n,m,N);
    nmax = max(n);
    positionMatrix = MakepositionMatrixEig(n,m);
    nevenlist = [-(N/2-1):2:(N/2-1) -(N/2):2:(N/2-2)]; nevenlist = repmat(nevenlist, N/2); nevenlist = nevenlist(1,:); % We want the negative ones here also, they might not appear actually... they will!
    mevenlist = 1:N; mevenlist = repelem(mevenlist, N/2);
    [~,~,nevenlist,mevenlist] = GetRemGeneral(nevenlist,mevenlist,N);
    kx = n*2*pi/G;
    kxsquared = kx.^2;
    ky = m*pi;
    Ktwo = kx.^2 + ky.^2;
    Kfour = Ktwo.^2;
    clear ky
    [Remf,~,~,~] = GetRemKeep(N,1);
    % This is needed as I use steadypositionnew below
    ThetaE = ExpandFieldsinf(Remf, ThetaE);
    ThetaEexp = Getexpinf(ThetaE, N);
    %
    clear PsiE ThetaE
    theta1 = zeros(length(n),length(n)); 
    TF = 2*pi^3/G^2;
    for i=1:length(n)
        ninst = n(i); minst = m(i);
        OnesWeWant = checkoenew2(ninst, minst, N,nevenlist,mevenlist);
        %iktfact = Ktwoinv(i);
        for j=1:length(OnesWeWant)
            modes = OnesWeWant(j,:);
            nodd = modes(1); modd = modes(2); neven = modes(3); meven = modes(4);
            %if abs(neven) < N/2 % as we do not have this in the steady state.
            %will just add a 0 in the PsiE and ThetaE after we expand
            rowinst =  positionMatrix(minst, ninst + 1 + nmax);
            columninst = positionMatrix(modd, nodd + 1 + nmax);
            steadypos = steadypositionnew(N, neven, meven);

            %iktfact = Ktwoinv(columninst);
            ThetaFact = ThetaEexp(steadypos);
            SS = SignStuff(nodd,modd,neven,meven,minst);
            RF = RemainingFact(nodd,modd,neven,meven,G);
             
            % Adding theta1
            theta1(rowinst,columninst) = theta1(rowinst,columninst) + ThetaFact*TF*SS*RF*Ra;
        end   
    end
    clear OnesWeWant PsiEexp ThetaEexp n m
    
    M = theta1 - diag(Ktwo) + Ra*diag(kxsquared.*Kfour.^(-1));
    % have moved the non-linearity over
end

