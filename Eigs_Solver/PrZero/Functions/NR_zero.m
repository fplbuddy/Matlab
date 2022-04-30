function [PsiR, dxmin] = NR_zero(PsiE, Nx, Ny,G, Ra,thres)
[~,~,n,m] = GetRemKeep_nxny(Nx,Ny,1);
positionMatrix = MakepositionMatrix(n,m);
PsiE = imag(PsiE);
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
        xn = PsiE;
        [J,fxn] = EvaluationAndJac2_zero(PsiE, Ra,G,n,m,Nx,Ny,positionMatrix); 
        dx = J\fxn;
        xn1 = xn - dx; % NR
        dxold = dxnew;
        dxnew = max(abs(dx))    
        % Making PsiE and ThetaE again
        PsiE = xn1;
        if dxnew < dxmin
            dxmin = dxnew;
            PsiR = PsiE;
        end
    end
end
PsiR = 1i*PsiR;
end