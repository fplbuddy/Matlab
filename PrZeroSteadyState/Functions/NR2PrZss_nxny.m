function [PsiR, dxmin] = NR2PrZss_nxny(PsiE, Nx, Ny,G, Ra,thres)
% Probabl going to need some stuff from nss for this to work
[Rem,~,n,m,signvector] = GetRemKeepnss_nxny(Nx,Ny); % this is the only thing I have changed when moving to nxny. is that correct? will test i guess
dxnew = 1e10;
dxold = 2e10;
dxmin = 1e10;
Cont = 1;
while dxnew > thres
    if dxnew >= dxold % increse prudance if we are going the wrong way or not moving;
        thres = thres*4;
        if thres > dxmin
            Cont = 0;
        end
    end
    if Cont
        [J,fxn] = EvaluationAndJacPrZss(PsiE, Ra,G,Rem,n,m, signvector);
        dx = J\fxn;
        PsiE = PsiE - dx; % NR
        dxold = dxnew;
        dxnew = max(abs(dx))    
        % Making PsiE and ThetaE again
        
        if dxnew < dxmin
            dxmin = dxnew;
            PsiR = PsiE;
        end
    end
end
end