function M = MakeMatrixEigProb(N,G, A,zero)
    % SIGN IN PAPER IS -1
    % leave Ra and Pr in for now as we want to compare with what we have
    % done before
    % actually, only need to check the non-linear bit, which is the same?
    n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); 
    m = 1:N; m = repelem(m, N/2);
    Rac = pi^4*(4+G^2)^3/(4*G^4);
    if zero
        PsiE = A;
    else
        PsiE = -A*pi*(4+G^2)/(2*G); % was (4+G^2)^2 before which i think is wrong. Should it not  be i???
    end
    [Rem,~,n,m] = GetRemGeneral(n,m,N);
    nevenlist = [-1 1]; % onle have this one mode
    mevenlist = [1 1];
    kx = n*2*pi/G;
    ky = m*pi;
    Ktwo = kx.^2 + ky.^2;
    Ktwoinv = Ktwo.^-1;
    clear ky
    psi1 = zeros((N^2/2),(N^2/2)); 
    for i=1:length(n)
        ninst = n(i); minst = m(i);
        OnesWeWant = checkoenew2(ninst, minst, N,nevenlist,mevenlist);
        iktfact = ((ninst*2*pi/G)^2 + (minst*pi)^2)^(-1);
        for j=1:height(OnesWeWant)
            modes = OnesWeWant(j,:);
            nodd = modes(1); modd = modes(2); neven = modes(3); meven = modes(4);
            %if abs(neven) < N/2 % as we do not have this in the steady state.
            %will just add a 0 in the PsiE and ThetaE after we expand
            rowinst = columnfindnew(N, ninst, minst);
            columninst = columnfindnew(N, nodd, modd);
             
            % Adding to psi1 
            psi1(rowinst,columninst) = psi1(rowinst,columninst) + iktfact*(-Square(nodd,modd,G) + Square(neven,meven,G))*PsiE*pi^2*(nodd*h(nodd,ninst,1)-modd*h(modd,minst,1))/2;
        end   
    end
    % clean the NL stuff
    psi1(Rem,:) = [];
    psi1(:,Rem) = [];
    clear OnesWeWant PsiEexp ThetaEexp n m
    
    Mlinear = (kx.^2.*(Ktwoinv.^2)*Rac-Ktwo)*G/2;
    M = psi1+ diag(Mlinear);
    %clearvars -except M
end

