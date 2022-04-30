function [ThetaR, dxmin] = NR2infslim(ThetaE, N, G, Ra,thres)
[~,~,n,m] = GetRemKeep(N,1);
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
        [J,fxn] = EvaluationAndJac2infslim(ThetaE, Ra,G,n,m,N,positionMatrix); 
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


