function Zonal = MakeZonalTT(Data, AR, type,Pr,Ra,G,N)
    PrS = PrtoPrS(Pr);
    RaS = RatoRaS(Ra);
    ThetaE = Data.(AR).(type).(PrS).(RaS).ThetaE;
    if length(ThetaE) < N^2/4 % then we have truncated in circle
        [~,~,n,m] = GetRemKeep(N,1);
    else
        n = [1:2:(N/2-1) 0:2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:);
        m = 1:N; m = repelem(m, N/4); 
    end
    ky = m*pi;
    kx = n*2*pi/G;
    x = linspace(G/(2*N*2), G-G/(2*N*2), 2*N); % Evaluate inside squares, 2N since we actually have double the grid points due to e/o decomp
    y = linspace(1/(2*N*2), 1-1/(2*N*2), 2*N);
    [xx, yy] = meshgrid(x,y);

    Eigenfuntiontheta = zeros(2*N, 2*N);
    for i=1:length(kx)
        kxp = kx(i);
        kyp = ky(i);
        amptheta = ThetaE(i);
        funcinst = sin(kyp*yy).*exp(1i*xx*kxp);
        Eigenfuntiontheta = 2*real(amptheta*funcinst) + Eigenfuntiontheta;
    end

    Zonal = mean(Eigenfuntiontheta,2);
end

