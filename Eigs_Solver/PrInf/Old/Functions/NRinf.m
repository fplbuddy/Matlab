function [ThetaR, dxmin] = NRinf(ThetaE, N, G, Ra)%, NLstenc)
dxnew = 1e10;
dxold = 2e10;
thres = 1e-15;
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
        % See how (1,1) for psi evolves
        %Check = PsiE(1);
        %plot(real(Check), imag(Check), '*'), hold on
        %pause
        % See how (1,1) for thete evolves
        %Check = ThetaE(1);
        %plot(real(Check), imag(Check), '*'), hold on
        %pause
        
        
        %CheckOld = CheckNew;
        % xn1 = xn - J-1fxn
        xn = ThetaE;

        
        %fxn = Evaluationnew(1i*PsiE, ThetaE, N, G, Ra, Pr, NLstenc);
        fxn = Evaluationinf(ThetaE, N, G, Ra);
        fxn = real(fxn);
        
        J = Jacobianinf(ThetaE, N, Ra,G);
        
     


        dx = J\fxn;
        xn1 = xn - dx; % NR
        dxold = dxnew;
        dxnew = max(abs(dx))
        
        
        % Making P ThetaE again
        ThetaE = xn1;
        
        if dxnew < dxmin
            dxmin = dxnew;
            ThetaR = ThetaE;
        end
    end
end
end


