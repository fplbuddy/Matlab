function J = JacobianOld(PsiE, ThetaE, Nx, Ny, Ra, Pr,G)
J = zeros((length(PsiE) + length(ThetaE))*2, (length(PsiE) + length(ThetaE))*2);
n = [1:2:(Nx/2-1) 0:2:(Nx/2-2)]; n = repmat(n, Ny/2); n = n(1,:);
m = 1:Ny; m = repelem(m, Nx/4);
for i=1:2:length(n)*2 % Looping round rows, do real ones on odd rows and imagnary ones in even
    ninst = n((i+1)/2); minst = m((i+1)/2);
    kxinst = 2*pi*ninst/G;  kyinst = pi*minst;
    [psirealpos, psiimagpos] = positionforJOld(ninst, minst, Nx, Ny, 1);
    [thetarealpos, thetaimagpos] = positionforJOld(ninst, minst, Nx, Ny, 2);
    % adding the easy ones
    J(i, thetaimagpos) = Ra*Pr*kxinst;
    J(i,psirealpos) = - Pr*(kxinst^2 + kyinst^2)^2;
    J(i+1, thetarealpos) = - Ra*Pr*kxinst;
    J(i+1, psiimagpos) = -Pr*(kxinst^2 + kyinst^2)^2;
    J(i + length(n)*2, psiimagpos) = kxinst;
    J(i + length(n)*2, thetarealpos) = (kxinst^2 + kyinst^2);
    J(i+1 + length(n)*2, psirealpos) = - kxinst;
    J(i+1 + length(n)*2, thetaimagpos) = (kxinst^2 + kyinst^2);
    
    %non linear ones
    modepairs = checkeeOld(Nx, Ny, ninst, minst);
    s = size(modepairs);
    for j=1:s(1) % Looping round non-linear ones
        modes = modepairs(j,:);
        n1 = modes(1); m1 = modes(2); n2 = modes(3); m2 = modes(4);
        % Do psi bit first
        Factor1 = PsiE(findpositionOld(n1, m1, Nx)); if sign(n1) == -1; Factor1 = conj(Factor1); end
        Factor2 = PsiE(findpositionOld(n2, m2, Nx)); if sign(n2) == -1; Factor2 = conj(Factor2); end
        % 1
        Ainst = A2(n1, m1, n2, m2, 1, G,  minst)/2;
        [psirealpos, psiimagpos] = positionforJOld(n1, m1, Nx, Ny, 1);
        J(i, psirealpos) = J(i, psirealpos) - imag(Factor2)*Ainst;
        J(i, psiimagpos) = J(i, psiimagpos) - sign(n1)*real(Factor2)*Ainst; % The sign() here is from if we have the c.c.
        J(i+1, psirealpos) = J(i+1, psirealpos) + real(Factor2)*Ainst;
        J(i+1, psiimagpos) = J(i+1, psiimagpos) - sign(n1)*imag(Factor2)*Ainst;
        % 2
        [psirealpos, psiimagpos] = positionforJOld(n2, m2, Nx, Ny, 1);
        J(i, psirealpos) = J(i, psirealpos) - imag(Factor1)*Ainst;
        J(i, psiimagpos) = J(i, psiimagpos) - sign(n2)*real(Factor1)*Ainst;
        J(i+1, psirealpos) = J(i+1, psirealpos) + real(Factor1)*Ainst;
        J(i+1, psiimagpos) = J(i+1, psiimagpos) - sign(n2)*imag(Factor1)*Ainst;
        % Now do theta bits
        Factor2 = ThetaE(findpositionOld(n2, m2, Nx)); if sign(n2) == -1; Factor2 = conj(Factor2); end
        Ainst = A2(n1, m1, n2, m2, 2, G,  minst)/2;
        % 1
        [psirealpos, psiimagpos] = positionforJOld(n1, m1, Nx, Ny, 1);
        J(i+length(n)*2, psirealpos) = J(i+length(n)*2, psirealpos) - imag(Factor2)*Ainst;
        J(i+length(n)*2, psiimagpos) = J(i+length(n)*2, psiimagpos) - sign(n1)*real(Factor2)*Ainst;
        J(i+1+length(n)*2, psirealpos) = J(i+1+length(n)*2, psirealpos) + real(Factor2)*Ainst;
        J(i+1+length(n)*2, psiimagpos) = J(i+1+length(n)*2, psiimagpos) - sign(n1)*imag(Factor2)*Ainst;
        % 2
        [thetarealpos, thetaimagpos] = positionforJOld(n2, m2, Nx, Ny, 2);
        J(i+length(n)*2, thetarealpos) = J(i+length(n)*2, thetarealpos) - imag(Factor1)*Ainst;
        J(i+length(n)*2, thetaimagpos) = J(i+length(n)*2, thetaimagpos) - sign(n2)*real(Factor1)*Ainst;
        J(i+1+length(n)*2, thetarealpos) = J(i+1+length(n)*2, thetarealpos) + real(Factor1)*Ainst;
        J(i+1+length(n)*2, thetaimagpos) = J(i+1+length(n)*2, thetaimagpos) - sign(n2)*imag(Factor1)*Ainst;
    end
end
end

