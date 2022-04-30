function [PsiR, dxmin] = NR_zero(PsiE, N, G, Ra)%, NLstenc)
PsiE = FormatFields_zero(PsiE, N);
ra = (N/4+1):(N/2):(N^2)/4; % used to remove \psi_{0,k_y}
PsiE(ra) = 0;

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
        xn = PsiE;

        
        %fxn = Evaluationnew(1i*PsiE, ThetaE, N, G, Ra, Pr, NLstenc);
        fxn = Evaluation_zero(1i*PsiE, N, G, Ra);
        % do transformation on fn
        fxn(1:length(PsiE)) = imag(fxn(1:length(PsiE)));
        fxn = real(fxn); % Not sure if i need this step?
        
        
        J = Jacobian_zero(PsiE, N, Ra,G);
        
        
        
        xn(ra) = [];
        fxn(ra) = [];
        J(ra,:) = [];
        J(:,ra) = [];
%         Cont = 0;
%         dxnew = thres/2


        dx = J\fxn;
        xn1 = xn - dx; % NR
        dxold = dxnew
        dxnew = max(abs(dx))
        
        for i=1:length(ra) % Adding back in 
           pos = ra(i);
           xn1 = vertcat(xn1(1:pos-1), 0, xn1(pos:end)); 
        end
        
        
        % Making PsiE and ThetaE again
        PsiE = xn1(1:length(PsiE));
        
        if dxnew < dxmin
            dxmin = dxnew;
            PsiR = PsiE;
            101
        end
    end
end
PsiR = 1i*PsiR; % Transforming back
end
