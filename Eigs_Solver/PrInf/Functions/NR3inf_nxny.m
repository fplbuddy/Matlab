function [ThetaR, dxmin] = NR3inf_nxny(ThetaE, Nx,Ny, G, Ra,thres)
[~,~,n,m] = GetRemKeep_nxny(Nx,Ny,1);
positionMatrix = MakepositionMatrix(n,m);
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
        xn = ThetaE;
        [J,fxn] = EvalandJacinf_nxny(ThetaE, Ra,G,n,m,Nx,Ny,positionMatrix); 
        dx = J\fxn;
        xn1 = xn - dx; % NR
        dxold = dxnew;
        dxnew = max(abs(dx))    
        % Making PsiE and ThetaE again
        ThetaE = xn1;
        
        if dxnew < dxmin
            dxmin = dxnew;
            ThetaR = ThetaE;
        end
    end
end
end


