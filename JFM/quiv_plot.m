%% y deriv
G = 2;
type  = "Z";
N = 152;
size = round(N/8);
Eigenfuntionyderivy = zeros(size, size);
x = linspace(G/(2*size), G-G/(2*size), size); % Evaluate inside squares, 2N since we actually have double the grid points due to e/o decomp
y = linspace(1/(2*size), 1-1/(2*size), size);
[xx, yy] = meshgrid(x,y);
Pr = 1e2; Ra = 2e5; PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
EigV = Data.AR_2.OneOne152.(PrS).(RaS).Eigv;
n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
I = find(n<0);
EigV([I I+length(n)]) = [];
% set phase to maximize zonal flow
phase = -angle(EigV(1)); % 1 is where 0,1 is
PsiV = EigV(1:length(EigV)/2);
n = [0:2:(N/2-1) 1:2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/4);
[~,~,n,m] = GetRemGeneral(n,m,N);
ky = m*pi;
kx = n*2*pi/G;
K2 = ((2*pi/G)*n').^2 + (pi*m').^2;
% when we move from exp to sin/cos, get factor of two in non-zonal modes.
% the other factor of two is adding the two eigenvector. this is kind of
% arbertary.
fact = 4*ones(length(n),1);
fact(find(n) == 0) = 2;
if type == "Z"
    vor = -(ky').*fact.*(real(PsiV*exp(1i*phase))); % - from that u = - \psi_y
else
    vor = -(ky').*fact.*imag(PsiV*exp(1i*phase));
end
mag = 1e5;
comp = max(abs(vor))/mag;
rem = find(abs(vor) < comp);
kypsi = ky;
kxpsi = kx;
vor(rem) = []; kypsi(rem) = []; kxpsi(rem) = [];
% make psi
if type == "Z"
    for i=1:length(kxpsi)
        kxp = kxpsi(i);
        kyp = kypsi(i);
        amppsi = vor(i); 
        funcinstpsi = cos(kyp*yy).*cos(xx*kxp);
        Eigenfuntionyderivy = amppsi* funcinstpsi + Eigenfuntionyderivy;
    end
else
    for i=1:length(kxpsi)
        kxp = kxpsi(i);
        kyp = kypsi(i);
        amppsi = vor(i); % 
        funcinstpsi = cos(kyp*yy).*sin(xx*kxp);
        Eigenfuntionyderivy = amppsi* funcinstpsi + Eigenfuntionyderivy;
    end
end


%% x deriv
type  = "Z";
N = 152;
size = round(N/8);
Eigenfuntionyderivx = zeros(size, size);
x = linspace(G/(2*size), G-G/(2*size), size); % Evaluate inside squares, 2N since we actually have double the grid points due to e/o decomp
y = linspace(1/(2*size), 1-1/(2*size), size);
[xx, yy] = meshgrid(x,y);
Pr = 1e2; Ra = 2e5; PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
EigV = Data.AR_2.OneOne152.(PrS).(RaS).Eigv;
n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
I = find(n<0);
EigV([I I+length(n)]) = [];
% set phase to maximize zonal flow
phase = -angle(EigV(1)); % 1 is where 0,1 is
PsiV = EigV(1:length(EigV)/2);
n = [0:2:(N/2-1) 1:2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/4);
[~,~,n,m] = GetRemGeneral(n,m,N);
ky = m*pi;
kx = n*2*pi/G;
K2 = ((2*pi/G)*n').^2 + (pi*m').^2;
% when we move from exp to sin/cos, get factor of two in non-zonal modes.
% the other factor of two is adding the two eigenvector. this is kind of
% arbertary.
fact = 4*ones(length(n),1);
fact(find(n) == 0) = 2;
if type == "Z"
    vor = (kx').*fact.*(real(PsiV*exp(1i*phase)));
else
    vor = (kx').*fact.*imag(PsiV*exp(1i*phase));
end
mag = 1e5;
comp = max(abs(vor))/mag;
rem = find(abs(vor) < comp);
kypsi = ky;
kxpsi = kx;
vor(rem) = []; kypsi(rem) = []; kxpsi(rem) = [];
% make psi
if type == "Z"
    for i=1:length(kxpsi)
        kxp = kxpsi(i);
        kyp = kypsi(i);
        amppsi = vor(i); 
        funcinstpsi = sin(kyp*yy).*(-sin(xx*kxp));
        Eigenfuntionyderivx = amppsi* funcinstpsi + Eigenfuntionyderivx;
    end
else
    for i=1:length(kxpsi)
        kxp = kxpsi(i);
        kyp = kypsi(i);
        amppsi = vor(i); % 
        funcinstpsi = sin(kyp*yy).*cos(xx*kxp);
        Eigenfuntionyderivx = amppsi* funcinstpsi + Eigenfuntionyderivx;
    end
end

%% get field
N = 152;
Pr = 1e2; Ra = 2e5; PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
EigV = Data.AR_2.OneOne152.(PrS).(RaS).Eigv;
n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
I = find(n<0);
EigV([I I+length(n)]) = [];
% set phase to maximize zonal flow
phase = -angle(EigV(1)); % 1 is where 0,1 is
[Eigenfuntionpsi1, ~,~] = GetEigVPlot(EigV,152,phase,2,"Z",0,0.5);

%% try quiver
figure('Renderer', 'painters', 'Position', [5 5 500 250])
x = 0:length(Eigenfuntionyderivx)/length(Eigenfuntionpsi1):length(Eigenfuntionyderivx); 
y = 0:length(Eigenfuntionyderivx)/length(Eigenfuntionpsi1):length(Eigenfuntionyderivx); 
x(1) = [];
y(1) = [];
[xx, yy] = meshgrid(x,y);
pcolor(xx,yy,Eigenfuntionpsi1); hold on
shading flat
colormap('jet')
caxis([-max(max(abs(Eigenfuntionpsi1))) max(max(abs(Eigenfuntionpsi1)))])
x = 1:length(Eigenfuntionyderivx); 
y = 1:length(Eigenfuntionyderivx); 
[xx, yy] = meshgrid(x,y);
quiver(xx,yy,Eigenfuntionyderivy*50,Eigenfuntionyderivx*50,'k')
xlim([0 length(Eigenfuntionyderivx)])
ylim([0 length(Eigenfuntionyderivx)])
title('$Pr = 100$, $Ra = 2 \times 10^5$, $\psi^O$, $E_z$','FontSize', LabelFS)
xticks([0 length(Eigenfuntionyderivx)])
yticks([0 length(Eigenfuntionyderivx)])
xticklabels(["0" "$\Gamma$"])
yticklabels(["0" "1"])
xlabel("$x$", 'FontSize', LabelFS)
ylabel("$y$", 'FontSize', LabelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
stip


%% y deriv
G = 2;
type  = "Z";
N = 400;
size = round(N/16);
Eigenfuntionyderivy = zeros(size, size);
x = linspace(G/(2*size), G-G/(2*size), size); % Evaluate inside squares, 2N since we actually have double the grid points due to e/o decomp
y = linspace(1/(2*size), 1-1/(2*size), size);
[xx, yy] = meshgrid(x,y);
Pr = 1e5; Ra = 1.56e7; PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
EigV = Data.AR_2.OneOne400.(PrS).(RaS).Eigv;
n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
I = find(n<0);
EigV([I I+length(n)]) = [];
% set phase to maximize zonal flow
phase = -angle(EigV(1)); % 1 is where 0,1 is
PsiV = EigV(1:length(EigV)/2);
n = [0:2:(N/2-1) 1:2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/4);
[~,~,n,m] = GetRemGeneral(n,m,N);
ky = m*pi;
kx = n*2*pi/G;
K2 = ((2*pi/G)*n').^2 + (pi*m').^2;
% when we move from exp to sin/cos, get factor of two in non-zonal modes.
% the other factor of two is adding the two eigenvector. this is kind of
% arbertary.
fact = 4*ones(length(n),1);
fact(find(n) == 0) = 2;
if type == "Z"
    vor = -(ky').*fact.*(real(PsiV*exp(1i*phase))); % - from that u = - \psi_y
else
    vor = -(ky').*fact.*imag(PsiV*exp(1i*phase));
end
mag = 1e5;
comp = max(abs(vor))/mag;
rem = find(abs(vor) < comp);
kypsi = ky;
kxpsi = kx;
vor(rem) = []; kypsi(rem) = []; kxpsi(rem) = [];
% make psi
if type == "Z"
    for i=1:length(kxpsi)
        kxp = kxpsi(i);
        kyp = kypsi(i);
        amppsi = vor(i); 
        funcinstpsi = cos(kyp*yy).*cos(xx*kxp);
        Eigenfuntionyderivy = amppsi* funcinstpsi + Eigenfuntionyderivy;
    end
else
    for i=1:length(kxpsi)
        kxp = kxpsi(i);
        kyp = kypsi(i);
        amppsi = vor(i); % 
        funcinstpsi = cos(kyp*yy).*sin(xx*kxp);
        Eigenfuntionyderivy = amppsi* funcinstpsi + Eigenfuntionyderivy;
    end
end
figure()
pcolor(Eigenfuntionyderivy);
shading flat
colormap('jet')

%% x deriv
type  = "Z";
N = 400;
size = round(N/16);
Eigenfuntionyderivx = zeros(size, size);
x = linspace(G/(2*size), G-G/(2*size), size); % Evaluate inside squares, 2N since we actually have double the grid points due to e/o decomp
y = linspace(1/(2*size), 1-1/(2*size), size);
[xx, yy] = meshgrid(x,y);
Pr = 1e5; Ra = 1.56e7; PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
EigV = Data.AR_2.OneOne400.(PrS).(RaS).Eigv;
n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
I = find(n<0);
EigV([I I+length(n)]) = [];
% set phase to maximize zonal flow
phase = -angle(EigV(1)); % 1 is where 0,1 is
PsiV = EigV(1:length(EigV)/2);
n = [0:2:(N/2-1) 1:2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/4);
[~,~,n,m] = GetRemGeneral(n,m,N);
ky = m*pi;
kx = n*2*pi/G;
K2 = ((2*pi/G)*n').^2 + (pi*m').^2;
% when we move from exp to sin/cos, get factor of two in non-zonal modes.
% the other factor of two is adding the two eigenvector. this is kind of
% arbertary.
fact = 4*ones(length(n),1);
fact(find(n) == 0) = 2;
if type == "Z"
    vor = (kx').*fact.*(real(PsiV*exp(1i*phase)));
else
    vor = (kx').*fact.*imag(PsiV*exp(1i*phase));
end
mag = 1e5;
comp = max(abs(vor))/mag;
rem = find(abs(vor) < comp);
kypsi = ky;
kxpsi = kx;
vor(rem) = []; kypsi(rem) = []; kxpsi(rem) = [];
% make psi
if type == "Z"
    for i=1:length(kxpsi)
        kxp = kxpsi(i);
        kyp = kypsi(i);
        amppsi = vor(i); 
        funcinstpsi = sin(kyp*yy).*(-sin(xx*kxp));
        Eigenfuntionyderivx = amppsi* funcinstpsi + Eigenfuntionyderivx;
    end
else
    for i=1:length(kxpsi)
        kxp = kxpsi(i);
        kyp = kypsi(i);
        amppsi = vor(i); % 
        funcinstpsi = sin(kyp*yy).*cos(xx*kxp);
        Eigenfuntionyderivx = amppsi* funcinstpsi + Eigenfuntionyderivx;
    end
end


%% get field
N = 400;
Pr = 1e5; Ra = 1.56e7; PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
EigV = Data.AR_2.OneOne400.(PrS).(RaS).Eigv;
n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
I = find(n<0);
EigV([I I+length(n)]) = [];
% set phase to maximize zonal flow
phase = -angle(EigV(1)); % 1 is where 0,1 is
[Eigenfuntionpsi1, ~,~] = GetEigVPlot(EigV,400,phase,2,"Z",0,2);

%% try quiver
figure('Renderer', 'painters', 'Position', [5 5 500 250])
x = 0:length(Eigenfuntionyderivx)/length(Eigenfuntionpsi1):length(Eigenfuntionyderivx); 
y = 0:length(Eigenfuntionyderivx)/length(Eigenfuntionpsi1):length(Eigenfuntionyderivx); 
x(1) = [];
y(1) = [];
[xx, yy] = meshgrid(x,y);
pcolor(xx,yy,Eigenfuntionpsi1); hold on
shading flat
colormap('jet')
caxis([-max(max(abs(Eigenfuntionpsi1))) max(max(abs(Eigenfuntionpsi1)))])
x = 1:length(Eigenfuntionyderivx); 
y = 1:length(Eigenfuntionyderivx); 
[xx, yy] = meshgrid(x,y);
quiver(xx,yy,Eigenfuntionyderivy*50,Eigenfuntionyderivx*50,'k')
xlim([0 length(Eigenfuntionyderivx)])
ylim([0 length(Eigenfuntionyderivx)])
title('$Pr = 10^5$, $Ra = 1.56 \times 10^7$, $\psi^O$, $E_z$','FontSize', LabelFS)
xticks([0 length(Eigenfuntionyderivx)])
yticks([0 length(Eigenfuntionyderivx)])
xticklabels(["0" "$\Gamma$"])
yticklabels(["0" "1"])
xlabel("$x$", 'FontSize', LabelFS)
ylabel("$y$", 'FontSize', LabelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;