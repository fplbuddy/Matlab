function M = MakeMatrixForOddProblem2_zero(Nx,Ny,G, PsiE, Ra)
n = [(-Nx/2):2:(Nx/2-1) (-Nx/2+1):2:(Nx/2-1)]; n = repmat(n, Ny/2);  n = n(1,:);
m = 1:Ny; m = repelem(m, Nx/2);
[~,~,n,m] = GetRemGeneral_nxny(n,m,Nx,Ny);
nmax = max(n);
positionMatrix = MakepositionMatrixEig(n,m);
nevenlist = [-(Nx/2-1):2:(Nx/2-1) -(Nx/2):2:(Nx/2-2)]; nevenlist = repmat(nevenlist, Ny/2); nevenlist = nevenlist(1,:); % We want the negative ones here also, they might not appear actually... they will!
mevenlist = 1:Ny; mevenlist = repelem(mevenlist, Nx/2);
[~,~,nevenlist,mevenlist] = GetRemGeneral_nxny(nevenlist,mevenlist,Nx,Ny);
kx = n*2*pi/G;
ky = m*pi;
Ktwo = kx.^2 + ky.^2;
Ktwoinv = Ktwo.^-1;
clear ky
[~,~,nsteady,msteady] = GetRemKeep_nxny(Nx,Ny,1);
positionMatrixSteady = MakepositionMatrix(nsteady,msteady);
%     [Remf,~,~,~] = GetRemKeep_nxny(Nx,Ny,1);
%     [PsiE, ThetaE] = ExpandFields(Remf, PsiE, ThetaE); % adds zeros back into the stuff we have removeed.
%     [PsiEexp, ThetaEexp] = Getexp(PsiE, ThetaE, N); % This stuff can probablt be improved by using a position matrix
%     clear PsiE ThetaE
psi1 = zeros(length(n),length(n));
for i=1:length(n)
    ninst = n(i); minst = m(i);
    OnesWeWant = checkoenew2_nxny(ninst, minst, Nx,Ny,nevenlist,mevenlist);
    %iktfact = Ktwoinv(i);
    iktfact = ((ninst*2*pi/G)^2 + (minst*pi)^2)^(-1);
    for j=1:length(OnesWeWant)
        modes = OnesWeWant(j,:);
        nodd = modes(1); modd = modes(2); neven = modes(3); meven = modes(4);
        %if abs(neven) < N/2 % as we do not have this in the steady state.
        %will just add a 0 in the PsiE and ThetaE after we expand
        rowinst =  positionMatrix(minst, ninst + 1 + nmax);
        columninst = positionMatrix(modd, nodd + 1 + nmax);
        %steadypos = steadypositionnew(N, neven, meven);
        steadypos = positionMatrixSteady(meven,abs(neven)+1);
        
        %iktfact = Ktwoinv(columninst);
        AFact = A(nodd, modd, neven, meven,G, minst);
        %PsiFact = PsiEexp(steadypos); ThetaFact = ThetaEexp(steadypos);
        if sign(neven) == -1
            PsiFact = conj(PsiE(steadypos));
        else
            PsiFact = PsiE(steadypos);
        end
        
        % Adding to psi1
        psi1(rowinst,columninst) = psi1(rowinst,columninst) + (Square(nodd,modd,G) - Square(neven,meven,G))*AFact*PsiFact*iktfact*(1i/2);
    end
end
clear OnesWeWant PsiEexp ThetaEexp n m
M = psi1 - diag(Ktwo) + diag(Ra*kx.^2.*Ktwoinv.^2); % suppose sign has changed from NR, by \nabla^2 on lhs i guess
clearvars -except M
clearvars -except M
end

