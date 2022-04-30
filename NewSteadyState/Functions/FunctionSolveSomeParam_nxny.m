function Data = FunctionSolveSomeParam_nxny(Data,G,RaA,Pr,Nx,Ny,thresh,GetEigV,stab,lowPrScaling,varargin)
GS = GtoGS(G);
RaC = pi^4*(4+G^2)^3/(4*G^4);
Ra = RaC + RaA;
type = ['N_' num2str(Nx) 'x' num2str(Ny)];
RaAS = RaAtoRaAS(RaA); PrS = PrtoPrS(Pr);
try ngot = not(isfield(Data.(GS).(type).(PrS), RaAS)); catch, ngot = 1; end
if ngot
    if ~isempty(varargin)
        [PsiE, ThetaE] = GetICnss_nxny(RaA, Pr, Data, type,G,lowPrScaling,varargin{1});
    else
        [PsiE, ThetaE] = GetICnss_nxny(RaA, Pr, Data, type,G,lowPrScaling);
    end
    [PsiE, ThetaE, dxmin] = NR2nss_nxny(PsiE, ThetaE, Nx, Ny,G, Ra, Pr,thresh,lowPrScaling); % have not fixed Nx and Ny yet
    Data.(GS).(type).(PrS).(RaAS).PsiE = PsiE;
    Data.(GS).(type).(PrS).(RaAS).ThetaE = ThetaE;
    Data.(GS).(type).(PrS).(RaAS).dxmin = dxmin;
    Data.(GS).(type).(PrS).(RaAS).lowPrScaling = lowPrScaling;
else
    PsiE = Data.(GS).(type).(PrS).(RaAS).PsiE;
    ThetaE = Data.(GS).(type).(PrS).(RaAS).ThetaE;
    % fix scaling
    scalingcheck = Data.(GS).(type).(PrS).(RaAS).lowPrScaling;
    if not(scalingcheck == lowPrScaling)
        PsiE = PsiE*Pr^(scalingcheck-lowPrScaling);
        ThetaE = ThetaE*Pr^(scalingcheck-lowPrScaling);
        [PsiE, ThetaE, dxmin] = NR2nss_nxny(PsiE, ThetaE, Nx, Ny,G, Ra, Pr,thresh,lowPrScaling); % have not fixed Nx and Ny yet
        Data.(GS).(type).(PrS).(RaAS).PsiE = PsiE;
        Data.(GS).(type).(PrS).(RaAS).ThetaE = ThetaE;
        Data.(GS).(type).(PrS).(RaAS).dxmin = dxmin;
        Data.(GS).(type).(PrS).(RaAS).lowPrScaling = lowPrScaling;
        
    end
    
    
end
if stab
    M = MakeMatrix_nxny2(Nx,Ny,G, PsiE, ThetaE, Ra, Pr,lowPrScaling);
    if not(GetEigV)
        sigma = eig(M);
    else
        [eigv,sigma] = eig(M);
        sigma = diag(sigma);
        rsigma = real(sigma);
        [~,I] = max(rsigma);
        eigv = eigv(:,I);
        Data.(GS).(type).(PrS).(RaAS).eigv = eigv;
    end
    %sigma(real(sigma) < -10) = [];
    clear M
    Data.(GS).(type).(PrS).(RaAS).sigma = sigma;
end
end