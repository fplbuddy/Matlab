function [Eigenfuntionpsi, Eigenfuntiontheta,ZeroOneFrac] = GetEigVPlot(EigV,N,phase,G,type,both,div)
size = round(N/div);
x = linspace(G/(2*size), G-G/(2*size), size); % Evaluate inside squares, 2N since we actually have double the grid points due to e/o decomp
y = linspace(1/(2*size), 1-1/(2*size), size);
[xx, yy] = meshgrid(x,y);
% Now plot eigenvectors
PsiV = EigV(1:length(EigV)/2);
ThetaV = EigV(length(EigV)/2+1:end);
n = [0:2:(N/2-1) 1:2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/4);
[~,~,n,m] = GetRemGeneral(n,m,N);
ky = m*pi;
kx = n*2*pi/G;
K2 = ((2*pi/G)*n').^2 + (pi*m').^2;
Eigenfuntionpsi = zeros(size, size);
Eigenfuntiontheta = zeros(size, size);
% when we move from exp to sin/cos, get factor of two in non-zonal modes.
% the other factor of two is adding the two eigenvector. this is kind of
% arbertary.
fact = 4*ones(length(n),1);
fact(find(n) == 0) = 2;
if type == "Z"
    PsiV = fact.*real(PsiV*exp(1i*phase));
    ThetaV = fact.*imag(ThetaV*exp(1i*phase));
else
    PsiV = fact.*imag(PsiV*exp(1i*phase));
    ThetaV = fact.*real(ThetaV*exp(1i*phase));
end
% get zeroonefrac
Ex = sum((kx'.^2).*PsiV.^2);
Ey = sum((ky'.^2).*PsiV.^2);
ZeroOneFrac = Ey/(Ey+Ex);
% trim psi
mag = 1e5;
comp = max(abs(PsiV))/mag;
rem = find(abs(PsiV) < comp);
kypsi = ky;
kxpsi = kx;
PsiV(rem) = []; kypsi(rem) = []; kxpsi(rem) = [];
% make psi
if type == "Z"
    for i=1:length(kxpsi)
        kxp = kxpsi(i);
        kyp = kypsi(i);
        amppsi = PsiV(i); % 2*real because we add the two eigenvectors
        funcinstpsi = sin(kyp*yy).*cos(xx*kxp);
        Eigenfuntionpsi = amppsi* funcinstpsi + Eigenfuntionpsi;
    end
else
    for i=1:length(kxpsi)
        kxp = kxpsi(i);
        kyp = kypsi(i);
        amppsi = PsiV(i); % 2*real because we add the two eigenvectors
        funcinstpsi = sin(kyp*yy).*sin(xx*kxp);
        Eigenfuntionpsi = amppsi* funcinstpsi + Eigenfuntionpsi;
    end
end
if both
    % trim theta
    comp = max(abs(ThetaV))/mag;
    rem = find(abs(ThetaV) < comp);
    kytheta = ky;
    kxtheta = kx;
    ThetaV(rem) = []; kytheta(rem) = []; kxtheta(rem) = [];
    % make theta
    if type == "Z"
        for i=1:length(kxtheta)
            kxp = kxtheta(i);
            kyp = kytheta(i);
            amptheta = ThetaV(i);
            funcinsttheta = sin(kyp*yy).*sin(xx*kxp);
            Eigenfuntiontheta = amptheta*funcinsttheta + Eigenfuntiontheta;
        end
    else
        for i=1:length(kxtheta)
            kxp = kxtheta(i);
            kyp = kytheta(i);
            amptheta = ThetaV(i);
            funcinsttheta = sin(kyp*yy).*cos(xx*kxp);
            Eigenfuntiontheta = amptheta*funcinsttheta + Eigenfuntiontheta;
        end
    end
end
end


