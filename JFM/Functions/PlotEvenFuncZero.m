function [Eigenfuntionpsi, Eigenfuntiontheta] =  PlotEvenFuncZero(Data, N,PrS,RaA,G)
    type = ['N_' num2str(N)];
    RaAS = RaAtoRaAS(RaA);
    PsiE = Data.(type).(PrS).(RaAS).PsiE;
    ThetaE = Data.(type).(PrS).(RaAS).ThetaE;
    if length(PsiE) < N^2/4 % then we have truncated in circle
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

    Eigenfuntionpsi = zeros(2*N, 2*N);
    Eigenfuntiontheta = zeros(2*N, 2*N);
    for i=1:length(kx)
        kxp = kx(i);
        kyp = ky(i);
        amppsi = PsiE(i);
        amptheta = ThetaE(i);
        funcinst = sin(kyp*yy).*exp(1i*xx*kxp);
        Eigenfuntionpsi = 2*real(amppsi*funcinst) + Eigenfuntionpsi; % 2 real is there so we get complex conj as well
        Eigenfuntiontheta = 2*real(amptheta*funcinst) + Eigenfuntiontheta;
    end
end