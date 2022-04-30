function [J, fxn, xn] = NROld(PsiE, ThetaE, Nx, Ny, G, Ra, Pr)%[PsiR, ThetaR, dxmin] = NROld(PsiE, ThetaE, Nx, Ny, G, Ra, Pr)
ninst = [1:2:(Nx/2-1) 0:2:(Nx/2-2)]; ninst = repmat(ninst, Ny/2); ninst = ninst(1,:);
% Making sure inputs are in form we want it
arg = angle(PsiE(1))+pi/2;
mult = exp(-1i*ninst*arg);
mult = reshape(mult,length(mult),1);
PsiE = PsiE .* mult;
ThetaE = ThetaE .* mult;

%ra = [1/2 (Nx/4+1):(Nx/2):(Nx*Ny)/4]; % Bits where we want to remvoce the compley parts, actually it is real part of psi_1,1 now
%ra = [1];
ra = [1:2:length(PsiE)*2 length(PsiE)*2+2:2:length(PsiE)*4 ((Nx/4+1):(Nx/2):(Nx*Ny)/4)*2]; % real from psi, imag from thete, and then imag from psi_0,ky
ra = sort(ra);
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
        fxn = zeros((length(PsiE) + length(ThetaE))*2 ,1);
        xn = zeros((length(PsiE) + length(ThetaE))*2 ,1);
        
        for j=1:length(PsiE)
            xn(j*2-1) = real(PsiE(j));
            xn(j*2) = imag(PsiE(j));
            xn(j*2-1+2*length(PsiE)) = real(ThetaE(j));
            xn(j*2+2*length(PsiE)) = imag(ThetaE(j));
        end
        
        ev = EvaluationOld(PsiE, ThetaE, Nx, Ny, G, Ra, Pr);
        for j=1:length(ev)
            fxn(j*2-1) = real(ev(j));
            fxn(j*2) = imag(ev(j));
        end           
        
        
        J = JacobianOld(PsiE, ThetaE, Nx, Ny, Ra, Pr,G);

        % remove bits we do not want
%         xn([ra*2 ra(2:end)*2+2*length(PsiE) ra(1)*2-1+2*length(PsiE)]) = [];
%         fxn([ra*2 ra(2:end)*2+2*length(PsiE) ra(1)*2-1+2*length(PsiE)]) = [];
%         J([ra*2 ra(2:end)*2+2*length(PsiE) ra(1)*2-1+2*length(PsiE)],:) = [];
%         J(:,[ra*2 ra(2:end)*2+2*length(PsiE) ra(1)*2-1+2*length(PsiE)]) = [];
%         xn([ra*2 ra(2:end)*2+2*length(PsiE)]) = [];
%         fxn([ra*2 ra(2:end)*2+2*length(PsiE)]) = [];
%         J([ra*2 ra(2:end)*2+2*length(PsiE)],:) = [];
%         J(:,[ra*2 ra(2:end)*2+2*length(PsiE)]) = [];
        xn(ra) = [];
        fxn(ra) = [];
        J(ra,:) = [];
        J(:,ra) = [];
        Cont = 0;
        dxnew = thres/2


%         dx = J\fxn;
%         xn1 = xn - dx; % NR
%         dxold = dxnew
%         dxnew = max(abs(dx))
%         
% 
%         for i=1:length(ra) % Adding back in 
%            pos = ra(i);
%            xn1 = vertcat(xn1(1:pos-1), 0, xn1(pos:end)); 
%         end
%         
%         % Making PsiE and ThetaE again
%         for j=1:length(PsiE)
%             PsiE(j) = xn1(j*2-1) + 1i*xn1(j*2);
%             ThetaE(j) = xn1(j*2-1+2*length(PsiE)) + 1i*xn1(j*2+2*length(PsiE));
%         end
%         
%         if dxnew < dxmin
%             dxmin = dxnew;
%             PsiR = PsiE;
%             ThetaR = ThetaE;
%             101
%         end
    end
end
end

