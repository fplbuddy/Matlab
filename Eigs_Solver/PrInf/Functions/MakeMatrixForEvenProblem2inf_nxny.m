function M = MakeMatrixForEvenProblem2inf_nxny(Nx,Ny,G, ThetaE, Ra)
    n = [(-Nx/2+1):2:(Nx/2-1) (-Nx/2):2:(Nx/2-1)]; n = repmat(n, Ny/2);  n = n(1,:);
    m = 1:Ny; m = repelem(m, Nx/2);
    [~,~,n,m] = GetRemGeneral_nxny(n,m,Nx,Ny);
    nmax = max(n);
    positionMatrix = MakepositionMatrixEig(n,m);
    kx = n*2*pi/G;
    kxsquared = kx.^2;
    ky = m*pi;
    Ktwo = kx.^2 + ky.^2;
    Kfour = Ktwo.^2;
    clear ky
    [~,~,nsteady,msteady] = GetRemKeep_nxny(Nx,Ny,1);
    positionMatrixSteady = MakepositionMatrix(nsteady,msteady);
    %
    theta1 = zeros(length(n),length(n)); 
    TF = 2*pi^3/G^2;
    for i=1:length(n)
        ninst = n(i); minst = m(i);
        OnesWeWant = checkeenew2_nxny(ninst, minst, Nx,Ny,n,m);
        %iktfact = Ktwoinv(i);
        for j=1:length(OnesWeWant)
            modes = OnesWeWant(j,:);
            npert = modes(1); mpert = modes(2); neven = modes(3); meven = modes(4);
            %if abs(neven) < N/2 % as we do not have this in the steady state.
            %will just add a 0 in the PsiE and ThetaE after we expand
            rowinst =  positionMatrix(minst, ninst + 1 + nmax);
            columninst = positionMatrix(mpert, npert + 1 + nmax);
            steadypos = positionMatrixSteady(meven,abs(neven)+1);

            %iktfact = Ktwoinv(columninst);
            % probably need this thing bellow, but then again, maybe not if
            % ThetaE is real?
            if sign(neven) == -1
                ThetaFact = conj(ThetaE(steadypos));
            else
               ThetaFact = ThetaE(steadypos); 
            end
            
            SS = SignStuff(npert,mpert,neven,meven,minst);
            RF = RemainingFact(npert,mpert,neven,meven,G);
             
            % Adding theta1
            theta1(rowinst,columninst) = theta1(rowinst,columninst) + ThetaFact*TF*SS*RF*Ra;
        end   
    end
    clear OnesWeWant PsiEexp ThetaEexp n m
    
    M = theta1 - diag(Ktwo) + Ra*diag(kxsquared.*Kfour.^(-1));
    % have moved the non-linearity over
end

