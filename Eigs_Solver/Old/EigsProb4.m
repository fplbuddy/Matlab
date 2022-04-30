%% Checks
% Check = Evaluation(PsiE, ThetaE, Nx, Ny, G, Ra, Pr);
%Check = checkee(Nx, Ny, 15, 1);
% [PsiE2, ThetaE2] = NR(PsiE, ThetaE, Nx, Ny, G, Ra, Pr);
% stop
% Pr = 30;
% PrS = PrtoPrS(Pr);
% RaS_list = string(fieldnames(Data));
% for i=1:length(RaS_list)
%    i
%    RaS = RaS_list(i);
%    Ra = RaStoRa(RaS);
%    Data.(PrS).(RaS).Ra = Ra;
%    Data.(PrS).(RaS).Pr = Pr;
%    PsiE = Data.(RaS).PsiE;
%    ThetaE = Data.(RaS).ThetaE;
%    [V, sigma] = eigensolver(PsiE, ThetaE, N, G, Pr, Ra);
%    Data.(PrS).(RaS).V = V; 
%    Data.(PrS).(RaS).sigma = diag(sigma);
%    stop
% end


hej2 = checkoe(2,1,32);

stop
%% Input
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions'); % So that we can use the functions
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)

Pr = 10;
Ra = 1e4;
nu = sqrt(pi^3*Pr/Ra);
kappa = sqrt((pi^3/(Ra*Pr)));
G = 2;
N = 32;
Ny = N;
Nx = N;
PsiE = zeros(Ny*Nx/4,1);
ThetaE = zeros(Ny*Nx/4,1);
ninst = [1:2:(Nx/2-1) 0:2:(Nx/2-2)]; ninst = repmat(ninst, Ny/2); ninst = ninst(1,:);
minst = 1:Ny; minst = repelem(minst, Nx/4);

%% Getting initial conditions from data
xr = floor(128/3 + 1) + 1;
yr = floor(2*128/3 + 1);
path = '/Volumes/Samsung_T5/Eigs_Prob/128x128/Pr_10/Ra_1e4/Spectra/';
times = importdata([path 'spec_times.txt']);
num = times(:,1); num = num2str(num(end));
while length(num) < 4
    num = ['0' num];
end
% Real psi
fid = fopen([path 'spectrum2D_UUreal.' num '.out'],'r'); fread(fid,1, 'real*4');
psireal = fread(fid,inf, 'real*8');
fclose(fid);
psireal = reshape(psireal,xr,yr); psireal = psireal';

% Imag psi
fid = fopen([path 'spectrum2D_UUimag.' num '.out'],'r'); fread(fid,1, 'real*4');
psiimag = fread(fid,inf, 'real*8');
fclose(fid);
psiimag = reshape(psiimag,xr,yr); psiimag = psiimag';

% Real theta
fid = fopen([path 'spectrum2D_PPreal.' num '.out'],'r'); fread(fid,1, 'real*4');
thetareal = fread(fid,inf, 'real*8');
fclose(fid);
thetareal = reshape(thetareal,xr,yr); thetareal = thetareal';

% Imag theta
fid = fopen([path 'spectrum2D_PPimag.' num '.out'],'r'); fread(fid,1, 'real*4');
thetaimag = fread(fid,inf, 'real*8');
fclose(fid);
thetaimag  = reshape(thetaimag ,xr,yr); thetaimag  = thetaimag';

% Filling the vectors
for i=1:length(PsiE)
    PsiE(i) = (2*psireal(minst(i), ninst(i) + 1) + 2*1i*psiimag(minst(i), ninst(i) + 1))/kappa;
    ThetaE(i) = 2*thetareal(minst(i), ninst(i) + 1) + 2*1i*thetaimag(minst(i), ninst(i) + 1);
end

%% Getting data
Pr = 30; % THIS WAS 0.3 before????
RaC = 8*pi^4;
RaList = RaC + [0.001 0.002 0.003 0.01 0.02 0.03 0.1 0.2 0.3 1 2 3 10 20 30 100];
kappaList = sqrt((pi^3./(RaList*Pr)));
%kappaList = reshape(kappaList, length(kappaList),1);
for i = 1:length(RaList)
    i
    Ra = RaList(i); 
    kappa = kappaList(i);
    RaS = RatoRaS(Ra);
    PrS = PrtoPrS(Pr);
    PsiE = Data.Pr_1.(RaS).PsiE;
    ThetaE = Data.Pr_1.(RaS).ThetaE;
    Data.(PrS).(RaS).Ra = Ra;
    Data.(PrS).(RaS).Pr = Pr;
    Data.(PrS).(RaS).kappa = kappa;
    [PsiE, ThetaE] = NR(PsiE, ThetaE, Nx, Ny, G, Ra, Pr);
    Data.(PrS).(RaS).PsiE = PsiE; 
    Data.(PrS).(RaS).ThetaE = ThetaE;
    [V, sigma] = eigensolver(PsiE, ThetaE, N, G, Pr, Ra);
    Data.(PrS).(RaS).V = V; 
    Data.(PrS).(RaS).sigma = diag(sigma);
end
clearvars -except AllData Data
stop

%% Plots
%% Eigenvalues
Ra = 3.8e4;
RaS = RatoRaS(Ra);
RaT = RatoRaT(Ra);
sigma = Data.(RaS).sigma;
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(real(sigma), imag(sigma), '*')
xlabel('$Real(\sigma)$', 'FontSize',14)
ylabel('$Imag(\sigma)$', 'FontSize',14)
title(['$Pr =' num2str(Pr) ', Ra = ' RaT '$'], 'FontSize',15)
xlim([-10 170])

max(real(sigma))
plot(real(sigma), '*')


%% Onset
PrS_list = string(fieldnames(Data));
RaC = 8*pi^4; RaMax = RaC +100;
figure('Renderer', 'painters', 'Position', [5 5 540 200])
PrS_list = OrderPrS_list(PrS_list);
Pr_list = []; PreFact = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i); Pr =PrStoPr(PrS);
    AmpList = []; RaList = [];
    Ra_list = string(fieldnames(Data.(PrS)));
    for i=1:length(Ra_list)
        if (Data.(PrS).(Ra_list(i)).Ra <= RaMax && Data.(PrS).(Ra_list(i)).Ra > RaC)
            RaList = [Data.(PrS).(Ra_list(i)).Ra RaList];
            PsiE = Data.(PrS).(Ra_list(i)).PsiE;
            %AmpList = [abs(PsiE(1))*Data.(PrS).(Ra_list(i)).kappa AmpList];
            AmpList = [abs(PsiE(1)) AmpList];
        end
    end
    % Finding difference
    RaList2 = RaList - RaC;
    loglog(RaList2,AmpList,'*', 'DisplayName', num2str(Pr)), hold on
    [~, Pre, ~, ~, ~] = FitsPowerLaw(RaList2,AmpList);
    PreFact = [Pre PreFact]; Pr_list = [Pr Pr_list];
end
hold off
xlabel('$Ra - 8\pi^4$', 'FontSize',14)
ylabel('$\vert \hat \psi_{1,1} \vert$', 'FontSize',14)
lgnd = legend('Location', 'Best'); title(lgnd,'$Pr$')
% Prefactor plot
figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(Pr_list, PreFact, '*'), hold on
xlabel('$Pr$', 'FontSize',14)
ylabel('Prefactor', 'FontSize',14)
[alpha, ~, xFitted, yFitted, ~] = FitsPowerLaw(Pr_list,PreFact);
plot(xFitted, yFitted, 'black--' ), hold off
gtext(['Prefactor $\propto Pr^{'  num2str(alpha,3) '}$'],'FontSize',14,'color', 'black')


%title(['$Pr =' num2str(Pr) '$, from MATLAB'], 'FontSize',15)
% Fit
% [alpha, ~, xFitted, yFitted, Rval] = FitsPowerLaw(RaList2,AmpList);
% plot(xFitted, yFitted, 'black--' )
% gtext(['$\hat \psi_{1,1} \propto (Ra - 8\pi^4)^{'  num2str(alpha,3) '}$'],'FontSize',14,'color', 'black')
%xlim([1 20])
%ylim([1e-3 1e-2])

%% Eigenfuntions
Ra = 3.8e4;
RaS = RatoRaS(Ra);
sigma = Data.(RaS).sigma;
figure
plot(real(sigma), '*')
ylim([-10 150])
% figure 
% plot(imag(sigma), '*')


num = 733;
ploteigfunction(Data.(RaS).V, num,1,32,2 )
%V = vieweigfunction(Data.(RaS).V, num);


%% Checks


%% Functions
function ploteigfunction(V, num,type, N, G)
figure('Renderer', 'painters', 'Position', [5 5 540 200])
n_list = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n_list = repmat(n_list, N/2);  kx_list = n_list(1,:)*2*pi/G; 
m_list = 1:N; m_list = repelem(m_list, N/2); ky_list = m_list(1,:)*pi;


Vinst = V(:,num); % Picking an eigenfunction
if type == 1
    Vinst = Vinst(1:length(Vinst)/2);
elseif type == 2
   Vinst = Vinst(length(Vinst)/2+1:end);     
end    
x = linspace(G/(2*N*2), G-G/(2*N*2), 2*N); % Evaluate inside squares, 2N since we actually have double the grid points due to e/o decomp
y = linspace(1/(2*N*2), 1-1/(2*N*2), 2*N);
[xx, yy] = meshgrid(x,y);

% Setting up function data matrix
FDM = zeros(N*2,N*2, length(kx_list));
for i=1:length(kx_list)
    kxp = kx_list(i);
    kyp = ky_list(i);  
    FDM(:,:,i) = sin(kyp*yy).*exp(1i*xx*kxp);
end

Eigenfuntion = zeros(2*N, 2*N);

% Calculating the eigenfunction
for i=1:length(kx_list) % Looping round eigenfunctions
    amp = Vinst(i);
    Eigenfuntion = amp*FDM(:,:,i) + Eigenfuntion;
end

subplot(1,2,1)
pcolor(imag(Eigenfuntion));
shading flat
colormap('jet')
colorbar
xlabel('$x$', 'FontSize', 14)
ylabel('$y$', 'FontSize', 14)
xticks([1 2*N])
xticklabels({'$0$' '$\Gamma$'})
yticks([1 2*N])
yticklabels({'$0$' '$1$'})
title('$Real(\psi)$', 'FontSize', 15)

subplot(1,2,2)
y = abs(Vinst);
plot(y, '*')
xlim([0 50])
xticks([])
xlabel('$(k_x, k_y)$', 'FontSize', 14)
ylabel('$| \hat \psi |$', 'FontSize', 14)
title('$(k_x, k_y)$ Spectrum', 'FontSize', 15)
end

function Vview = vieweigfunction(V, num)
    y = abs(V(:,num)); Vview = V(:,num);
    figure
    plot(y, '*')
    title(num2str(num))
end

function [V, sigma] = eigensolver(PsiE, ThetaE, N, G, Pr, Ra)

kx = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; kx = repmat(kx, N);  kx = kx(1,:)*2*pi/G; % N rather than N/2 as we want theta also
ky = 1:N; ky = repelem(ky, N/2); ky = repmat(ky, 2); ky = ky(1,:)*pi;
Ktwo = kx.^2 + ky.^2;
kx = diag(kx); ky = diag(ky); Ktwo = diag(Ktwo);

% Easy ones
M2 = -1i*Ra*Pr*inv(Ktwo)*kx*[zeros((N^2/2),(N^2/2)) eye((N^2/2)); zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2))];
M3 = -Pr*Ktwo*[eye((N^2/2)) zeros((N^2/2),(N^2/2)); zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2))];
M5 = 1i*kx*[zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2)); eye((N^2/2)) zeros((N^2/2),(N^2/2))];
M6 = -Ktwo*[zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2)); zeros((N^2/2),(N^2/2)) eye((N^2/2))];

% Hard ones
kx_list = diag(kx); ky_list = diag(ky);
kx_list = kx_list(1:(length(kx_list)/2)); ky_list = ky_list(1:(length(ky_list)/2));
psi1 = zeros((N^2/2),(N^2/2)); psi2 = zeros((N^2/2),(N^2/2)); theta1 = zeros((N^2/2),(N^2/2)); % This was inside the i loop before which i think is wrong
for i=1:length(kx_list)
    ninst = round(kx_list(i)*G/(2*pi)); minst = round(ky_list(i)/pi);
    OnesWeWant = checkoe(ninst,minst,N);
    for j=1:length(OnesWeWant)
        modes = OnesWeWant(j,:);
        kxe = modes(1); kye = modes(2); kxo = modes(3); kyo = modes(4); % O Gives position and E gives what we want from data
        % Finding position
        kxposcheck1 = (-N/2):2:(N/2-1); kxposcheck2 = (-N/2+1):2:(N/2-1); 
        kxpos = find(kxposcheck1 == kxo);
        if sum(size(kxpos)) == 1
            kxpos = find(kxposcheck2 == kxo);
        end
        pos = 1 + (N/2)*(kyo - 1) + kxpos -1;
        
        % Getting factors
        pose = findposition(kxe, kye, N);
        PsiFact = PsiE(pose); 
        ThetaFact = ThetaE(pose);
        if kxe == -N/2; PsiFact = 0; ThetaFact = 0; end % If we have the c.c. which does not have a counter part
        
        if sign(kxe) == -1; PsiFact = conj(PsiFact); ThetaFact = conj(ThetaFact); end
        if round(kye) == round(minst + kyo); kye = -kye, end % Adding sign stuff, this is like f in the latex file
        if round(kyo) == round(minst + kye); kyo = -kyo; end
        
        
        factor1 = (kxo*2*pi/G)^2 + (kyo*pi)^2 - (kxe*2*pi/G)^2 - (kye*pi)^2; % Minus sign at the end? Have changed it, think  it is right think to do
        factor2 = kxe*kyo*2*pi^2/G - kxo*kye*2*pi^2/G;
        
        % Addding to psi1
        psi1(i, pos) = psi1(i, pos) + PsiFact*factor1*factor2;
        % Adding to psi2
        psi2(i, pos) = psi2(i, pos) + ThetaFact*factor2; % Have swapped the signes here
        % Adding to theta1
        theta1(i, pos) = theta1(i, pos) - PsiFact*factor2;   
    end
end

M1 = (-1i/2)*inv(Ktwo)*[psi1 zeros((N^2/2),(N^2/2)); zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2))];
M4 = (1i/2)*[zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2)); psi2 theta1];
%spy(M1);

M = M1 + M2 + M3 + M4 + M5 + M6;

[V,sigma] = eig(M);
end

function [PsiR, ThetaR] = NR(PsiE, ThetaE, Nx, Ny, G, Ra, Pr)
    CheckOld = 1e6;
    CheckNew = 1e5;
    dx = 1;
    while max(abs(dx)) > 1e-4
       % See how (1,1) for psi evolves
       %Check = PsiE(1);
       %plot(real(Check), imag(Check), '*'), hold on
       %pause
       % See how (1,1) for thete evolves
       %Check = ThetaE(1);
       %plot(real(Check), imag(Check), '*'), hold on
       %pause
       

       CheckOld = CheckNew;
       % xn1 = xn - J-1fxn
       fxn = zeros((length(PsiE) + length(ThetaE))*2 ,1);
       xn = zeros((length(PsiE) + length(ThetaE))*2 ,1);

       for j=1:length(PsiE)
          xn(j*2-1) = real(PsiE(j));
          xn(j*2) = imag(PsiE(j));
          xn(j*2-1+2*length(PsiE)) = real(ThetaE(j));
          xn(j*2+2*length(PsiE)) = imag(ThetaE(j)); 
       end

       ev = Evaluation(PsiE, ThetaE, Nx, Ny, G, Ra, Pr);
       for j=1:length(ev)
           fxn(j*2-1) = real(ev(j));
           fxn(j*2) = imag(ev(j));
       end

       J = Jacobian(PsiE, ThetaE, Nx, Ny, Ra, Pr,G);
       %Jinv = inv(J);

       dx = J\fxn;
       CheckNew = sum(abs(dx));
       xn1 = xn - dx; % NR
       max(abs(dx))
       max(fxn)
       %semilogy(abs(dx))
       %pause
       
       % Making PsiE and ThetaE again
       for j=1:length(PsiE)
          PsiE(j) = xn1(j*2-1) + 1i*xn1(j*2);
          ThetaE(j) = xn1(j*2-1+2*length(PsiE)) + 1i*xn1(j*2+2*length(PsiE));
       end
    end
hold off
PsiR = PsiE;
ThetaR = ThetaE;
end


function J = Jacobian(PsiE, ThetaE, Nx, Ny, Ra, Pr,G)
    J = zeros((length(PsiE) + length(ThetaE))*2, (length(PsiE) + length(ThetaE))*2);
    n = [1:2:(Nx/2-1) 0:2:(Nx/2-2)]; n = repmat(n, Ny/2); n = n(1,:);
    m = 1:Ny; m = repelem(m, Nx/4);
    for i=1:2:length(n)*2 % Looping round rows, do real ones on odd rows and imagnary ones in even 
        ninst = n((i+1)/2); minst = m((i+1)/2);
        kxinst = 2*pi*ninst/G;  kyinst = pi*minst; 
        [psirealpos, psiimagpos] = positionforJ(ninst, minst, Nx, Ny, 1);
        [thetarealpos, thetaimagpos] = positionforJ(ninst, minst, Nx, Ny, 2);
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
        modepairs = checkee(Nx, Ny, ninst, minst);
        s = size(modepairs);
        for j=1:s(1) % Looping round non-linear ones
            modes = modepairs(j,:);
            n1 = modes(1); m1 = modes(2); n2 = modes(3); m2 = modes(4); 
            % Do psi bit first
            Factor1 = PsiE(findposition(n1, m1, Nx)); if sign(n1) == -1; Factor1 = conj(Factor1); end
            Factor2 = PsiE(findposition(n2, m2, Nx)); if sign(n2) == -1; Factor2 = conj(Factor2); end
            % 1
            Ainst = A(n1, m1, n2, m2, 1, G,  minst)/2;
            [psirealpos, psiimagpos] = positionforJ(n1, m1, Nx, Ny, 1);
            J(i, psirealpos) = J(i, psirealpos) - imag(Factor2)*Ainst;
            J(i, psiimagpos) = J(i, psiimagpos) - sign(n1)*real(Factor2)*Ainst; % The sign() here is from if we have the c.c.
            J(i+1, psirealpos) = J(i+1, psirealpos) + real(Factor2)*Ainst;
            J(i+1, psiimagpos) = J(i+1, psiimagpos) - sign(n1)*imag(Factor2)*Ainst;
            % 2
            [psirealpos, psiimagpos] = positionforJ(n2, m2, Nx, Ny, 1);
            J(i, psirealpos) = J(i, psirealpos) - imag(Factor1)*Ainst;
            J(i, psiimagpos) = J(i, psiimagpos) - sign(n2)*real(Factor1)*Ainst;
            J(i+1, psirealpos) = J(i+1, psirealpos) + real(Factor1)*Ainst;
            J(i+1, psiimagpos) = J(i+1, psiimagpos) - sign(n2)*imag(Factor1)*Ainst;
            % Now do theta bits
            Factor2 = ThetaE(findposition(n2, m2, Nx)); if sign(n2) == -1; Factor2 = conj(Factor2); end
            Ainst = A(n1, m1, n2, m2, 2, G,  minst)/2;
            % 1
            [psirealpos, psiimagpos] = positionforJ(n1, m1, Nx, Ny, 1);
            J(i+length(n)*2, psirealpos) = J(i+length(n)*2, psirealpos) - imag(Factor2)*Ainst;
            J(i+length(n)*2, psiimagpos) = J(i+length(n)*2, psiimagpos) - sign(n1)*real(Factor2)*Ainst;
            J(i+1+length(n)*2, psirealpos) = J(i+1+length(n)*2, psirealpos) + real(Factor2)*Ainst;
            J(i+1+length(n)*2, psiimagpos) = J(i+1+length(n)*2, psiimagpos) - sign(n1)*imag(Factor2)*Ainst;
            % 2
            [thetarealpos, thetaimagpos] = positionforJ(n2, m2, Nx, Ny, 2);
            J(i+length(n)*2, thetarealpos) = J(i+length(n)*2, thetarealpos) - imag(Factor1)*Ainst;
            J(i+length(n)*2, thetaimagpos) = J(i+length(n)*2, thetaimagpos) - sign(n2)*real(Factor1)*Ainst;
            J(i+1+length(n)*2, thetarealpos) = J(i+1+length(n)*2, thetarealpos) + real(Factor1)*Ainst;
            J(i+1+length(n)*2, thetaimagpos) = J(i+1+length(n)*2, thetaimagpos) - sign(n2)*imag(Factor1)*Ainst;            
        end    
    end
end

function res = checkee(Nx, Ny, ninst, minst)
    % Dont think the n=-Nx/2 causes a problem as it will not turn up
    % (-Nx/2)*n < 0, and we dont consider the complex conjugates
    n = [-(Nx/2-1):2:(Nx/2-1) -(Nx/2):2:(Nx/2-2)]; n = repmat(n, Ny/2); n = n(1,:); % We want the negative ones here also, they might not appear actually... they will!
    m = 1:Ny; m = repelem(m, Nx/2);
    res = [];
    for i=1:length(n)
        n1 = n(i); m1 = m(i);
        for j=1:length(n)
            n2 = n(j); m2 = m(j);
            if ninst == n2 + n1 && (minst == m1 + m2 || minst == abs(m1 - m2)) && not(n1 == n2 && m1 == m2)
                s = size(res);
                res(s(1)+1, 1) = n1; res(s(1)+1, 2) = m1; res(s(1)+1, 3) = n2; res(s(1)+1, 4) = m2;
            end
        end
    end
end

function NL = NL(PsiE, ThetaE, Nx, Ny, ninst, minst, type, G)
    NL = 0;
    modepairs = checkee(Nx, Ny, ninst, minst);
    s = size(modepairs);
    for i=1:s(1)
        n1 = modepairs(i, 1);  m1 = modepairs(i, 2);  n2 = modepairs(i, 3);  m2 = modepairs(i, 4);      
        Factor1 = PsiE(findposition(n1, m1, Nx)); if sign(n1) == -1; Factor1 = conj(Factor1); end % Taking complex conjugate if needed
        if type == 1
            Factor2 = PsiE(findposition(n2, m2, Nx)); if sign(n2) == -1; Factor2 = conj(Factor2); end
            NL = NL + Factor1*Factor2*A(n1, m1, n2, m2, type, G,  minst);  
        elseif type == 2
            Factor2 = ThetaE(findposition(n2, m2, Nx)); if sign(n2) == -1; Factor2 = conj(Factor2); end
            NL = NL + Factor1*Factor2*A(n1, m1, n2, m2, type, G,  minst);
        end
    end
    NL = NL*1i/2;
end

function Evaluation = Evaluation(PsiE, ThetaE, Nx, Ny, G, Ra, Pr)   
    n = [1:2:(Nx/2-1) 0:2:(Nx/2-2)]; n = repmat(n, Ny/2); n = n(1,:);
    m = 1:Ny; m = repelem(m, Nx/4);

    Evaluation = zeros(length(PsiE) + length(ThetaE),1);
    for i=1:length(n)
        ninst = n(i); minst = m(i);
        kxinst = 2*pi*ninst/G; kyinst = pi*minst;
        %checkee = checkee(Nx, Ny, ninst, minst);
        pos = findposition(ninst, minst, Nx);
        Evaluation(i) = NL(PsiE, ThetaE, Nx, Ny, ninst, minst, 1, G) - 1i*kxinst*Ra*Pr*ThetaE(pos) - Pr*((kxinst^2 + kyinst^2)^2)*PsiE(pos);
        Evaluation(i + length(n)) = NL(PsiE, ThetaE, Nx, Ny, ninst, minst, 2, G) - 1i*kxinst*PsiE(pos) + (kxinst^2 + kyinst^2)*ThetaE(pos);
    end
end

function pos = findposition(ninst, minst, Nx)
    ncheck1 = 1:2:(Nx/2-1); ncheck2 = 0:2:(Nx/2-2);
    if ismember(abs(ninst), ncheck1)
        npos = find(ncheck1 == abs(ninst));
    else
        npos = find(ncheck2 == abs(ninst));
    end
    pos = 1 + (Nx/4)*(minst - 1) + npos - 1;
end

function A = A(n1, m1, n2, m2, type, G, minst)
    kx1 = 2*pi*n1/G; kx2 = 2*pi*n2/G; ky1 = pi*m1; ky2 = pi*m2;
    if round(m1) == round(minst + m2); ky1 = -ky1; end % Adding sign stuff, from y integral
    if round(m2) == round(minst + m1); ky2 = -ky2; end 
    if type == 1
       A = (ky1*kx2-ky2*kx1)*(kx2^2+ky2^2);
    elseif type == 2
       A = (ky2*kx1-ky1*kx2);
    end
end


function [realpos, imagpos] = positionforJ(ninst, minst, Nx, Ny, type)
    ncheck1 = 1:2:(Nx/2-1); ncheck2 = 0:2:(Nx/2-2);
    if ismember(abs(ninst), ncheck1)
        npos = find(ncheck1 == abs(ninst));
    else
        npos = find(ncheck2 == abs(ninst));
    end
    pos = 1 + (Nx/4)*(minst - 1) + npos - 1;
      
    if type == 1
        realpos = 1 + (pos-1)*2;
    elseif type == 2 
        realpos = Nx*Ny/2 + 1 + (pos-1)*2;
    end
    imagpos = realpos + 1;
end

function checkoe = checkoe(kx,ky,n)
checkoe = [];
for kxe=-n/2:(n/2 - 1) % looping round kxe
    kxo = round(kx - kxe); % Calculating kxo
    Check = kxo > -n/2 - 1 && kxo < n/2;
    if Check % Checking if kxo is ok
        for kye = 1:n % Looping round kye
            if kye ~= ky
                kyo = round(abs(ky - kye)); % Calculating easy kyo
                % Now check if everything is ok
                CheckEven = ~mod(kxe + kye, 2); CheckOdd = mod(kxo + kyo, 2);
                if CheckEven && CheckOdd
                    s = size(checkoe);
                    checkoe(s(1)+1, 1) = kxe; checkoe(s(1)+1, 2) = kye; checkoe(s(1)+1, 3) = kxo; checkoe(s(1)+1, 4) = kyo;
                end
                
                kyo = round(ky + kye); % Calculating easy kyo
                if CheckEven && CheckOdd && kyo < n + 1
                    s = size(checkoe);
                    checkoe(s(1)+1, 1) = kxe; checkoe(s(1)+1, 2) = kye; checkoe(s(1)+1, 3) = kxo; checkoe(s(1)+1, 4) = kyo;
                end
            end
            
        end
    end
end
end