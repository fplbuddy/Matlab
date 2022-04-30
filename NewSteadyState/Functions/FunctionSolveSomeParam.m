function Data = FunctionSolveSomeParam(Data,G,RaA,Pr,Nx,Ny,thresh,GetEigV,stab,varargin)
GS = GtoGS(G);
RaC = pi^4*(4+G^2)^3/(4*G^4);
Ra = RaC + RaA;
type = ['N_' num2str(Nx) 'x' num2str(Ny)];
RaAS = RaAtoRaAS(RaA); PrS = PrtoPrS(Pr);
try ngot = not(isfield(Data.(GS).(type).(PrS), RaAS)); catch, ngot = 1; end
if ngot
    if length(varargin) > 0
        [PsiE, ThetaE] = GetICnss(RaA, Pr, Data, type,G,varargin{1});
    else
        [PsiE, ThetaE] = GetICnss(RaA, Pr, Data, type,G);
    end
    [PsiE, ThetaE, dxmin] = NR2nss(PsiE, ThetaE, Nx, G, Ra, Pr,thresh); % have not fixed Nx and Ny yet
    Data.(GS).(type).(PrS).(RaAS).PsiE = PsiE;
    Data.(GS).(type).(PrS).(RaAS).ThetaE = ThetaE;
    Data.(GS).(type).(PrS).(RaAS).dxmin = dxmin;
else
    PsiE = Data.(GS).(type).(PrS).(RaAS).PsiE;
    ThetaE = Data.(GS).(type).(PrS).(RaAS).ThetaE;
end
if stab
M = MakeMatrix_nxny2(Nx,Ny,G, PsiE, ThetaE, Ra, Pr);
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
sigma(real(sigma) < -10) = [];
clear M
Data.(GS).(type).(PrS).(RaAS).sigma = sigma;
end
end