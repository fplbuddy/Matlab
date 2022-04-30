function [Eigenfuntionpsi, Eigenfuntiontheta,xderiv,yderiv] =  PlotEvenFunc(Data, AR, N,Pr,Ra,G,derivs)
res = min(350,2*N);
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE);
type = ['OneOne' num2str(N)];
PrS = PrtoPrS(Pr);
RaS = RatoRaS(Ra);
PsiE = Data.(AR).(type).(PrS).(RaS).PsiE;
ThetaE = Data.(AR).(type).(PrS).(RaS).ThetaE;
if length(PsiE) < N^2/4 % then we have truncated in circle
    [~,~,n,m] = GetRemKeep(N,1);
else
    n = [1:2:(N/2-1) 0:2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:);
    m = 1:N; m = repelem(m, N/4);
end
ky = m*pi;
kx = n*2*pi/G;
x = linspace(G/(res*2), G-G/(res*2), res); % Evaluate inside squares, 2N since we actually have double the grid points due to e/o decomp
y = linspace(1/(res*2), 1-1/(res*2), res);
[xx, yy] = meshgrid(x,y);

Eigenfuntionpsi = zeros(res, res);
Eigenfuntiontheta = zeros(res, res);
for i=1:length(kx)
    kxp = kx(i);
    kyp = ky(i);
    amppsi = PsiE(i);
    amptheta = ThetaE(i);
    if kxp ~= 0
        amppsi = 2*amppsi;
        amptheta = 2*amptheta;
    end
    funcinst = sin(kyp*yy).*exp(1i*xx*kxp);
    Eigenfuntionpsi = real(amppsi*funcinst) + Eigenfuntionpsi;
    Eigenfuntiontheta = real(amptheta*funcinst) + Eigenfuntiontheta;
end

xderiv = zeros(res, res);
yderiv = zeros(res, res);
if derivs
    PsiEx = PsiE;
    PsiEy = PsiE;
    PsiEx = PsiEx.*(1i*kx);
    PsiEy = PsiEy.*ky;
    for i=1:length(kx)
        kxp = kx(i);
        kyp = ky(i);
        
        
        ampx = PsiEx(i);
        ampy = PsiEy(i);
        if kxp ~= 0
            ampx = 2*ampx;
            ampy = 2*ampy;
        end
        funcinstx = sin(kyp*yy).*exp(1i*xx*kxp);
        funcinsty = cos(kyp*yy).*exp(1i*xx*kxp);
        xderiv = real(ampx*funcinstx) + xderiv;
        yderiv = real(ampy*funcinsty) + yderiv;
    end
    
    
    
    
    
end

end