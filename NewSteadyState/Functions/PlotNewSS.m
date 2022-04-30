function [Eigenfuntionpsi, Eigenfuntiontheta] =  PlotNewSS(Data, N,PrS,Ra,G)
    % looks like we have devided the solutin by two??
    type = ['N_' num2str(N)];
    RaS = RatoRaS(Ra);
    PsiE = Data.(type).(PrS).(RaS).PsiE;
    ThetaE = Data.(type).(PrS).(RaS).ThetaE;
    [~,~,n,m,~] = GetRemKeep(N);
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
        amppsi = 2*PsiE(i); % think we are off by a factor of 2 for some reason...
        amptheta = 2*ThetaE(i);
        par = n(i) + m(i); % to check if we are odd or even
        if rem(par,2) == 0 % even
           amppsi = 1i*amppsi;
        else
           amptheta = 1i*amptheta;
        end
        funcinst = sin(kyp*yy).*exp(1i*xx*kxp);
        Eigenfuntionpsi = amppsi*funcinst + Eigenfuntionpsi; 
        Eigenfuntiontheta = amptheta*funcinst + Eigenfuntiontheta;
        if kxp ~= 0 % add c.c. as well
            funcinst = sin(kyp*yy).*exp(-1i*xx*kxp); 
            amppsi = conj(amppsi);
            amptheta = conj(amptheta);
            Eigenfuntionpsi = amppsi*funcinst + Eigenfuntionpsi; 
            Eigenfuntiontheta = amptheta*funcinst + Eigenfuntiontheta;       
        end
    end
end

