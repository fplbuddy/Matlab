function Evaluation = Evaluationnew(PsiE, ThetaE, N, G,Ra, Pr, NLstencil)
    % This uses stencil. Seems like it is slightly faster, but fastnes
    % decays with N and uses more memory
    n = [1:2:(N/2-1) 0:2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:);
    m = 1:N; m = repelem(m, N/4);
    kx = 2*pi*n/G; ky = pi*m;
    squared = kx.^2 + ky.^2;
    [PsiEexp, ThetaEexp] = Getexp(PsiE, ThetaE, N);
    kx = reshape(kx, length(kx),1); squared = reshape(squared, length(squared),1);    
    Ev1 = sum(NLstencil.Afact1.*PsiEexp(NLstencil.Fact1).*PsiEexp(NLstencil.Fact2),2)*1i/2-1i*Ra*Pr*kx.*ThetaE -Pr*(squared.^2).*PsiE;
    Ev2 = sum(NLstencil.Afact2.*PsiEexp(NLstencil.Fact1).*ThetaEexp(NLstencil.Fact2),2)*1i/2-1i*kx.*PsiE +squared.*ThetaE;
    Evaluation = [Ev1; Ev2];
    clearvars -except Evaluation
end

