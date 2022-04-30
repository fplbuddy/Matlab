function M = MakeMatrix_MeanDNS(Nx,Ny,G,Gy, PsiE, ThetaE, Ra, Pr)
n = (-Nx/2):(Nx/2-1); n = repmat(n, Ny);  n = n(1,:);
m = 1:Ny; m = repelem(m, Nx);
[~,~,n,m] = GetRemGeneral_nxny(n,m,Nx,Ny); % This is integer wavenumbers for matrix
nmax = max(n);
positionMatrix = MakepositionMatrixEig(n,m);
kx = n*2*pi/G;
ky = m*pi;
Ktwo = kx.^2 + ky.^2;
Ktwoinv = Ktwo.^-1;
clear ky
nsteady = [0:(Nx/2-1)]; nsteady = repmat(nsteady, Ny);  nsteady = nsteady(1,:); % these are only used to make positionMatrixSteady 
msteady = 1:Ny; msteady = repelem(msteady, Nx/2);
[~,~,nsteady,msteady] = GetRemGeneral_nxny(nsteady,msteady,Nx,Ny);
positionMatrixSteady = MakepositionMatrix(nsteady,msteady);
psi1 = zeros(length(n),length(n)); psi2 = zeros(length(n),length(n)); theta1 = zeros(length(n),length(n)); % Make big now, will reduce later
for i=1:length(n)
    ninst = n(i); minst = m(i);
    OnesWeWant = NLTermMaker(ninst, minst, Nx,Ny,n,m); % Gets all the non-linear terms we want for this ninst and minst
    
    iktfact = ((ninst*2*pi/G)^2 + (minst*pi)^2)^(-1);
    for j=1:length(OnesWeWant)
        modes = OnesWeWant(j,:);
        npert = modes(1); mpert = modes(2); nsi = modes(3); msi = modes(4); % nsi and msi stand for nsteadyinst and msteadyinst
        %if abs(neven) < N/2 % as we do not have this in the steady state.
        %will just add a 0 in the PsiE and ThetaE after we expand
        rowinst =  positionMatrix(minst, ninst + 1 + nmax);
        columninst = positionMatrix(mpert, npert + 1 + nmax);
        %steadypos = steadypositionnew(N, neven, meven);
        steadypos = positionMatrixSteady(msi,abs(nsi)+1);
        
        %iktfact = Ktwoinv(columninst);
        AFact = Anew(npert, mpert, nsi, msi, minst);
        %PsiFact = PsiEexp(steadypos); ThetaFact = ThetaEexp(steadypos);
        if sign(nsi) == -1
            PsiFact = conj(PsiE(steadypos)); 
            ThetaFact = conj(ThetaE(steadypos));
        else
            PsiFact = PsiE(steadypos);
            ThetaFact = ThetaE(steadypos);
        end
        
        % Adding to psi1
        psi1(rowinst,columninst) = psi1(rowinst,columninst) + (Square(npert,mpert,G) - Square(nsi,msi,G))*AFact*PsiFact*iktfact*(pi^2*1i/G);
        % Adding psi2
        psi2(rowinst,columninst) = psi2(rowinst,columninst) - AFact*ThetaFact*(pi^2*1i/G);
        % Adding theta1
        theta1(rowinst,columninst) = theta1(rowinst,columninst) + AFact*PsiFact*(pi^2*1i/G);
    end
end
clear OnesWeWant PsiEexp ThetaEexp n m

% Theta bit is the same as W
M6 = -diag(Ktwo+(2*pi/Gy)^2);
M3 = -Pr*diag(Ktwo+(2*pi/Gy)^2);
clear Ktwo
M5 = diag(1i*kx);
M2 = diag(-1i*Ra*Pr*Ktwoinv.*kx);
clear kx Ktwoinv
M = [M3+psi1 M2; M5+psi2 M6+theta1];
clearvars -except M
end

