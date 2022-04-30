function WNLZero = GetCrossingZero(WNLZero,G,N,n,m,positionMatrix)
    GS = GtoGS(G);
    a = (1+G^2/4);
    if not(isfield(WNLZero,GS))
        As = [1 2];
        [Fs,sigmas,As] = GetFandSigmasZero(As,N,G,n,m,positionMatrix);
        WNLZero = AddtoDataZero(WNLZero,GS,As,Fs,sigmas);
        sigmascheck = WNLZero.(GS).sigmas; 
        cont = sign(sigmascheck(1)) == sign(sigmascheck(end));
        while cont
            Ascheck = WNLZero.(GS).As*a;
            if sign(sigmascheck(1)) > 0
                A = Ascheck(1)/10;
            else
                A = Ascheck(end)*10;
            end
            [Fs,sigmas,As] = GetFandSigmasZero(A,N,G,n,m,positionMatrix);
            WNLZero = AddtoDataZero(WNLZero,GS,As,Fs,sigmas);
            sigmascheck = WNLZero.(GS).sigmas;
            cont = sign(sigmascheck(1)) == sign(sigmascheck(end));
        end  
    end
end

