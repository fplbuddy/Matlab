function M = MakeMatrix_nxny2_nodiag(Nx,Ny,G, PsiE, ThetaE)
% Dont need nevenlist, as the two lists we work with are the same in
% the even problem
n = [(-Nx/2):(Nx/2-1)]; n = repmat(n, Ny);  n = n(1,:);
m = 1:Ny; m = repelem(m, Nx);
[~,~,n,m] = GetRemGeneral_nxny(n,m,Nx,Ny);
nmax = max(n);
positionMatrix = MakepositionMatrixEig(n,m);
kx = n*2*pi/G;
ky = m*pi;
Ktwo = kx.^2 + ky.^2;
Ktwoinv = Ktwo.^-1;
clear ky
nsteady = [0:(Nx/2-1)]; nsteady = repmat(nsteady, Ny);  nsteady = nsteady(1,:);
msteady = 1:Ny; msteady = repelem(msteady, Nx/2);
[~,~,nsteady,msteady] = GetRemGeneral_nxny(nsteady,msteady,Nx,Ny);
positionMatrixSteady = MakepositionMatrix(nsteady,msteady);
%     [Remf,~,~,~] = GetRemKeep(N,1);
%     [PsiE, ThetaE] = ExpandFields(Remf, PsiE, ThetaE);
%     [PsiEexp, ThetaEexp] = Getexp(PsiE, ThetaE, N);
psi1 = zeros(length(n),length(n)); psi2 = zeros(length(n),length(n)); theta1 = zeros(length(n),length(n)); % Make big now, will reduce later
% add complex bits to theta and psi
for i=1:length(nsteady)
    ninst = nsteady(i);
    minst = msteady(i);
    if rem(ninst+minst,2) == 0 % even modes
        PsiE(i) = 1i*PsiE(i);
    else
        ThetaE(i) = 1i*ThetaE(i);
    end
end
for i=1:length(n)
    ninst = n(i); minst = m(i);
    OnesWeWant = MakeOnesWeWant(ninst, minst, Nx,Ny,n,m);
    
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
            PsiFact = conj(PsiE(steadypos)); % this wont work, as the structure is such that PsiE and TheteE have real entries, need to odd complex stuff at the start perhaps
            ThetaFact = conj(ThetaE(steadypos));
        else
            PsiFact = PsiE(steadypos);
            ThetaFact = ThetaE(steadypos);
        end
        
        % Adding to psi1
        psi1(rowinst,columninst) = psi1(rowinst,columninst) + (Square(npert,mpert,G) - Square(neven,meven,G))*AFact*PsiFact*iktfact*(1i/2);
        % Adding psi2
        psi2(rowinst,columninst) = psi2(rowinst,columninst) + AFact*ThetaFact*(-1i/2);
        % Adding theta1
        theta1(rowinst,columninst) = theta1(rowinst,columninst) - AFact*PsiFact*(-1i/2);
    end
end
clear OnesWeWant PsiEexp ThetaEexp m
clear Ktwo
clear kx Ktwoinv
M = [psi1 zeros(length(n),length(n)); psi2 theta1];
clearvars -except M
end

