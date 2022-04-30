function M = MakeMatrix_paz_v1(Amp,Ra,G,Nx,Ny)
n = [(-Nx/2):(Nx/2-1)]; n = repmat(n, Ny);  n = n(1,:);
m = 1:Ny; m = repelem(m, Nx);
[~,~,n,m] = GetRemGeneral_nxny(n,m,Nx,Ny);
nmax = max(n);
positionMatrix = MakepositionMatrixEig(n,m);
nevenlist = [-1 1]; % onle have this one mode
mevenlist = [1 1];
kx = n*2*pi/G;
ky = m*pi;
Ktwo = kx.^2 + ky.^2;
Ktwoinv = Ktwo.^-1;
clear ky
psi1 = zeros(length(n),length(n));
for i=1:length(n)
    ninst = n(i); minst = m(i);
    OnesWeWant = checkoenew2_nxny(ninst, minst, Nx,Ny,nevenlist,mevenlist);
    iktfact = ((ninst*2*pi/G)^2 + (minst*pi)^2)^(-1);
    for j=1:height(OnesWeWant)
        modes = OnesWeWant(j,:);
        nodd = modes(1); modd = modes(2); neven = modes(3); meven = modes(4);
        %if abs(neven) < N/2 % as we do not have this in the steady state.
        %will just add a 0 in the PsiE and ThetaE after we expand
        rowinst =  positionMatrix(minst, ninst + 1 + nmax);
        columninst = positionMatrix(modd, nodd + 1 + nmax);
        %iktfact = Ktwoinv(columninst);
        AFact = A(nodd, modd, neven, meven,G, minst);
        %PsiFact = PsiEexp(steadypos); ThetaFact = ThetaEexp(steadypos);
        if sign(neven) == -1
            PsiFact = conj(Amp);
        else
            PsiFact = Amp;
        end
        
        % Adding to psi1
        psi1(rowinst,columninst) = psi1(rowinst,columninst) + (Square(nodd,modd,G) - Square(neven,meven,G))*AFact*PsiFact*iktfact*(1i/2);
    end
end
Mlinear = (kx.^2.*(Ktwoinv.^2)*Ra-Ktwo);
M = psi1+ diag(Mlinear);

end