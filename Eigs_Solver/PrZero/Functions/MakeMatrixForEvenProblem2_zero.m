function M = MakeMatrixForEvenProblem2_zero(Nx,Ny,G, PsiE, Ra)
% Dont need nevenlist, as the two lists we work with are the same in
% the even problem
n = [(-Nx/2+1):2:(Nx/2-1) (-Nx/2):2:(Nx/2-1)]; n = repmat(n, Ny/2);  n = n(1,:);
m = 1:Ny; m = repelem(m, Nx/2);
[~,~,n,m] = GetRemGeneral_nxny(n,m,Nx,Ny);
nmax = max(n);
positionMatrix = MakepositionMatrixEig(n,m);
kx = n*2*pi/G;
ky = m*pi;
Ktwo = kx.^2 + ky.^2;
Ktwoinv = Ktwo.^-1;
clear ky
[~,~,nsteady,msteady] = GetRemKeep_nxny(Nx,Ny,1);
positionMatrixSteady = MakepositionMatrix(nsteady,msteady);
%     [Remf,~,~,~] = GetRemKeep(N,1);
%     [PsiE, ThetaE] = ExpandFields(Remf, PsiE, ThetaE);
%     [PsiEexp, ThetaEexp] = Getexp(PsiE, ThetaE, N);
psi1 = zeros(length(n),length(n));
for i=1:length(n)
    ninst = n(i); minst = m(i);
    OnesWeWant = checkeenew2_nxny(ninst, minst, Nx,Ny,n,m);
    
    %iktfact = Ktwoinv(i);
    iktfact = ((ninst*2*pi/G)^2 + (minst*pi)^2)^(-1);
    for j=1:length(OnesWeWant)
        modes = OnesWeWant(j,:);
        npert = modes(1); mpert = modes(2); neven = modes(3); meven = modes(4);
        %if abs(neven) < N/2 % as we do not have this in the steady state.
        %will just add a 0 in the PsiE and ThetaE after we expand
        rowinst =  positionMatrix(minst, ninst + 1 + nmax);
        columninst = positionMatrix(mpert, npert + 1 + nmax);
        %steadypos = steadypositionnew(N, neven, meven);
        steadypos = positionMatrixSteady(meven,abs(neven)+1);
        
        %iktfact = Ktwoinv(columninst);
        AFact = A(npert, mpert, neven, meven,G, minst);
        %PsiFact = PsiEexp(steadypos); ThetaFact = ThetaEexp(steadypos);
        if sign(neven) == -1
            PsiFact = conj(PsiE(steadypos));
        else
            PsiFact = PsiE(steadypos);
        end
        
        % Adding to psi1
        psi1(rowinst,columninst) = psi1(rowinst,columninst) + (Square(npert,mpert,G) - Square(neven,meven,G))*AFact*PsiFact*iktfact*(1i/2);
    end
end
clear OnesWeWant PsiEexp ThetaEexp n m
M = psi1 - diag(Ktwo) + diag(Ra*kx.^2.*Ktwoinv.^2); % suppose sign has changed from NR, by \nabla^2 on lhs i guess
clearvars -except M
end

