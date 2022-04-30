function [PsiR, ThetaR, dxmin] = NR(PsiE, ThetaE, N, G, Ra, Pr, DNS)%, NLstenc)
[PsiE,ThetaE] = FormatFields(PsiE,ThetaE, N);
if not(DNS)
    Rem = (N/4+1):(N/2):(N^2)/4; % used to remove \psi_{}
    PsiE(Rem) = 0;
    Remboth = Rem;
else
    [Rem,~,~,~] = GetRemKeep(N,DNS);
    PsiE([Rem (N/4+1):(N/2):(N^2)/4]) = 0;
    ThetaE(Rem) = 0;
    Remboth = sort([Rem (N/4+1):(N/2):(N^2)/4 Rem+length(PsiE)]); % kx = 0 modes only removed from psi. 
    Remboth = unique(Remboth);
end

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
        xn = [PsiE; ThetaE];

        
        %fxn = Evaluationnew(1i*PsiE, ThetaE, N, G, Ra, Pr, NLstenc);
        fxn = Evaluation(1i*PsiE, ThetaE, N, G, Ra, Pr);
        % do transformation on fn
        fxn(1:length(PsiE)) = imag(fxn(1:length(PsiE)));
        fxn = real(fxn);
        
        
        J = Jacobian(PsiE, ThetaE, N, Ra, Pr,G);
        
        
        xn(Remboth) = [];
        fxn(Remboth) = [];
        J(Remboth,:) = [];
        J(:,Remboth) = [];
%         Cont = 0;
%         dxnew = thres/2


        dx = J\fxn;
        xn1 = xn - dx; % NR
        dxold = dxnew;
        dxnew = max(abs(dx))
        
        for i=1:length(Remboth) % Adding back in 
           pos = Remboth(i);
           xn1 = vertcat(xn1(1:pos-1), 0, xn1(pos:end)); 
        end
        
        
        % Making PsiE and ThetaE again
        PsiE = xn1(1:length(PsiE));
        ThetaE = xn1(length(PsiE)+1:end);
        
        if dxnew < dxmin
            dxmin = dxnew;
            PsiR = PsiE;
            ThetaR = ThetaE;
        end
    end
end
PsiR = 1i*PsiR; % Transforming back
end
