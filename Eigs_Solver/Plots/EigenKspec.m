addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions') 
size = 20;
numFS = 16;
labelFS = 18;
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
% first one
G = 2;
type  = "Z";
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
    PsiV = K2.*(fact.*real(PsiV*exp(1i*phase))).^2;
else
    PsiV = K2.*(fact.*imag(PsiV*exp(1i*phase))).^2;
end
% now we make the thing we want to plot
for i=1:length(n)
    mat(n(i)+1,m(i)) = PsiV(i);
end
figure()
pcolor(mat');
%shading flat
colormap('jet')
check = mat(1:size,1:size);
check(check == 0) = [];
caxis([min(min(check)) max(max(check))])
set(gca,'ColorScale','log')
colorbar('FontSize',numFS)
xlim([1 size])
ylim([1 size])
xticks([1.5:2:19.5])
yticks([1.5:2:19.5])
xlab = ["0" "2" "4" "6" "8" "10" "12" "14" "16" "18" "20"];
ylab = ["1" "3" "5" "7" "9" "11" "13" "15" "17" "19" "21"];
xticklabels(xlab)
yticklabels(ylab)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$k_x$', 'FontSize', labelFS)
ylabel('$k_y$', 'FontSize', labelFS)
title('$K^2|\widehat \psi_{k_x,k_y}|^2$, $E_z$', 'FontSize', labelFS)
% second one
type  = "NZ";
N = 400;
Pr = 7e5; Ra = 2.54e7; PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
EigV = Data.AR_2.OneOne400.(PrS).(RaS).EigvNZ;
n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
I = find(n<0);
EigV([I I+length(n)]) = [];
% set phase to maximize zonal flow
phase = -angle(EigV(2))+pi/2; % 1 is where 0,1 is
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
    PsiV = K2.*(fact.*real(PsiV*exp(1i*phase))).^2;
else
    PsiV = K2.*(fact.*imag(PsiV*exp(1i*phase))).^2;
end
% now we make the thing we want to plot
for i=1:length(n)
    mat(n(i)+1,m(i)) = PsiV(i);
end
figure()
pcolor(mat');
%shading flat
colormap('jet')
check = mat(1:size,1:size);
check(check == 0) = [];
caxis([1e-10 max(max(check))])
set(gca,'ColorScale','log')
colorbar('FontSize',numFS)
xlim([1 size])
ylim([1 size])
xticks([1.5:2:19.5])
yticks([1.5:2:19.5])
xlab = ["0" "2" "4" "6" "8" "10" "12" "14" "16" "18" "20"];
ylab = ["1" "3" "5" "7" "9" "11" "13" "15" "17" "19" "21"];
xticklabels(xlab)
yticklabels(ylab)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$k_x$', 'FontSize', labelFS)
ylabel('$k_y$', 'FontSize', labelFS)
title('$K^2|\widehat \psi_{k_x,k_y}|^2$, $E_{nz}$', 'FontSize', labelFS)

%% vorticity
type  = "Z";
N = 400;
size = round(N/1.1);
Eigenfuntionvor = zeros(size, size);
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
    vor = (kx'.^2 + ky'.^2).*fact.*(real(PsiV*exp(1i*phase)));
else
    vor = (kx'.^2 + ky'.^2).*fact.*imag(PsiV*exp(1i*phase));
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
        funcinstpsi = sin(kyp*yy).*cos(xx*kxp);
        Eigenfuntionvor = amppsi* funcinstpsi + Eigenfuntionvor;
    end
else
    for i=1:length(kxpsi)
        kxp = kxpsi(i);
        kyp = kypsi(i);
        amppsi = vor(i); % 
        funcinstpsi = sin(kyp*yy).*sin(xx*kxp);
        Eigenfuntionvor = amppsi* funcinstpsi + Eigenfuntionvor;
    end
end
pcolor(Eigenfuntionvor);
shading flat
colormap('jet')

%%
type  = "NZ";
N = 400;
size = round(N/1.1);
Eigenfuntionvor = zeros(size, size);
x = linspace(G/(2*size), G-G/(2*size), size); % Evaluate inside squares, 2N since we actually have double the grid points due to e/o decomp
y = linspace(1/(2*size), 1-1/(2*size), size);
[xx, yy] = meshgrid(x,y);
Pr = 7e5; Ra = 2.54e7; PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
EigV = Data.AR_2.OneOne400.(PrS).(RaS).EigvNZ;
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
    vor = (kx'.^2 + ky'.^2).*fact.*(real(PsiV*exp(1i*phase)));
else
    vor = (kx'.^2 + ky'.^2).*fact.*imag(PsiV*exp(1i*phase));
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
        funcinstpsi = sin(kyp*yy).*cos(xx*kxp);
        Eigenfuntionvor = amppsi* funcinstpsi + Eigenfuntionvor;
    end
else
    for i=1:length(kxpsi)
        kxp = kxpsi(i);
        kyp = kypsi(i);
        amppsi = vor(i); % 
        funcinstpsi = sin(kyp*yy).*sin(xx*kxp);
        Eigenfuntionvor = amppsi* funcinstpsi + Eigenfuntionvor;
    end
end
pcolor(Eigenfuntionvor);
shading flat
colormap('jet')

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
figure()
pcolor(Eigenfuntionyderivy);
shading flat
colormap('jet')

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
figure()
pcolor(Eigenfuntionyderivx);
shading flat
colormap('jet')


%% try quiver
x = 1:length(Eigenfuntionyderivx); 
y = 1:length(Eigenfuntionyderivx); 
[xx, yy] = meshgrid(x,y);
figure()
quiver(xx,yy,Eigenfuntionyderivy*50,Eigenfuntionyderivx*50)
xlim([0 length(Eigenfuntionyderivx)])
ylim([0 length(Eigenfuntionyderivx)])

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
phase = -angle(EigV(1))+1; % 1 is where 0,1 is
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
size = round(N/1.1);
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
phase = -angle(EigV(1))+1; % 1 is where 0,1 is
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
figure()
pcolor(Eigenfuntionyderivx);
shading flat
colormap('jet')


%% try quiver
x = 1:length(Eigenfuntionyderivx); 
y = 1:length(Eigenfuntionyderivx); 
[xx, yy] = meshgrid(x,y);
figure()
quiver(xx,yy,Eigenfuntionyderivy*100,Eigenfuntionyderivx*100)
xlim([0 length(Eigenfuntionyderivx)])
ylim([0 length(Eigenfuntionyderivx)])