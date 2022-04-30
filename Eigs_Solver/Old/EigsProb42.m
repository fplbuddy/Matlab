% Using the same notation as for v5
%load('/Users/philipwinchester/Documents/Data/OldData/master.mat' )
%load('/Volumes/Samsung_T5/OneDrive - Nexus365/OldData/master.mat')
%load('/Volumes/Samsung_T5/OneDrive - Nexus365/OldData/masternew.mat')
load('/Volumes/Samsung_T5/masternew.mat')


%%
%[V, sigma] = eigensolver(Data.OneOne64.Pr_6_2.Ra_7e4.PsiE, Data.OneOne64.Pr_6_2.Ra_7e4.ThetaE, 64, 2, 6.2, 7e4);
%ploteigfunction(V, 2213,1, 64, 2)
% PsiE = Data.OneOne.Pr_8.Ra_3_38e4.PsiE;
% ThetaE = Data.OneOne.Pr_8.Ra_3_38e4.ThetaE;
% %plotevenfunction(PsiE, ThetaE, 32, 2)
% 
% 
%PsiE4, ThetaE4, dxmin] = NR(PsiE, ThetaE, 32, 32, 2, 4.8e4, 30);
%[~, sigma] = eigensolver(PsiE, ThetaE, 32, 2/3, 100, 3e4);
%Data.AR_0_67.OneOne.Pr_100.Ra_3e4.PsiE = PsiE
% Data.OneOne.Pr_8.Ra_3_4e4.PsiE = PsiE;
% Data.OneOne.Pr_8.Ra_3_4e4.sigma = sigma;
%arg = 0;
%mult = exp(-1i*ninst*arg);
%mult = reshape(mult,length(mult),1);

%NL(Data.AR_2.OneOne64.Pr_30.Ra_4e4.PsiE.* mult, Data.AR_2.OneOne64.Pr_30.Ra_4e4.ThetaE.* mult, 64, 64, 3, 5, 1, 2)

hej = steadyposition(N, 16, 2);

%txtfile('PsiE', Data.OneOne60.Pr_6_2.Ra_7e4.PsiE, Data.OneOne60.Pr_6_2.Ra_7e4.kappa)
%plotevenfunction(PsiEcomp, ThetaEcomp, 32, 2)
%SecondCrossing(Data, Pr, type)
%findcrossandfreq(Data.OneOne, Pr)
%max(abs(Evaluation(PsiE, ThetaE, Nx, Ny, 2, 4.8e4, 30)))
% NL(abs(PsiE), ThetaE, Nx, Ny, 1, 1, 1, 2)
%hej = Evaluation(PsiE, ThetaE, Nx, Ny, 2, 1e4, 10);
% hej(1);
%modepairs = checkee(Nx, Ny, 1, 1);
stop
%% Getting initial conditions from data
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/Functions/');% So that we can use the functions
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

xr = floor(128/3 + 1) + 1;
yr = floor(2*128/3 + 1);
path = '/Volumes/Samsung_T5/Eigs_Prob_ICs/128x128/Pr_10/Ra_1e4/Spectra/';
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
arg = angle(PsiE(1));
mult = exp(-1i*ninst*arg);
mult = reshape(mult,length(mult),1);
PsiE = PsiE .* mult;
ThetaE = ThetaE .* mult;

stop
%% Getting data
type = 'OneOne64';
G = 2;
%AR = ['AR_' num2str(G)];
AR = 'AR_2';
N = 64;
Ny = N;
Nx = N;
Pr_list = [30];
IC = 1;
try
if IC == 1
   PrS = 'Pr_30';
   RaS = 'Ra_5e4';
   PsiE = Data.(AR).(type).(PrS).(RaS).PsiE;
   ThetaE = Data.(AR).(type).(PrS).(RaS).ThetaE; 
end 
catch
end
for j=1:length(Pr_list)
    Pr = Pr_list(j);
    RaList = [4e4 5e4];
    Ra = RaList(1);
    RaS = RatoRaS(Ra);
    kappaList = sqrt((pi^3./(RaList*Pr)));
    if IC ~= 1
        PrC = ClosestPr(Pr, string(fieldnames(Data.(AR).(type))));
        PsiE = Data.(AR).(type).(PrC).(RaS).PsiE;
        ThetaE = Data.(AR).(type).(PrC).(RaS).ThetaE;
    end
    for i = 1:length(RaList)
        i
        Ra = RaList(i);
        kappa = kappaList(i);
        RaS = RatoRaS(Ra);
        PrS = PrtoPrS(Pr);
        Data.(AR).(type).(PrS).(RaS).Ra = Ra;
        Data.(AR).(type).(PrS).(RaS).Pr = Pr;
        Data.(AR).(type).(PrS).(RaS).kappa = kappa;
        [PsiE, ThetaE, dxmin] = NR(PsiE, ThetaE, Nx, Ny, G, Ra, Pr);
        Data.(AR).(type).(PrS).(RaS).PsiE = PsiE;
        Data.(AR).(type).(PrS).(RaS).ThetaE = ThetaE;
        Data.(AR).(type).(PrS).(RaS).dxmin = dxmin;
        [~, sigma] = eigensolver(PsiE, ThetaE, N, G, Pr, Ra);
        Data.(AR).(type).(PrS).(RaS).sigma = diag(sigma);
    end
end
stop

%% Soling eigenvalue problem when we already have steady solutions
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions'); % So that we can use the functions
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
%OldData = load('/Volumes/Samsung_T5/OldData/SomePr30DataNotHalved.mat');
Pr = 30;
PrS = PrtoPrS(Pr);
RaS_list = string(fieldnames(OldData.Data));
%RaS_list = ["Ra_1e3" "Ra_1e4" "Ra_2e4" "Ra_3e4" "Ra_4e4" "Ra_5e4"];
for i=1:length(RaS_list)
    i
    RaS = convertStringsToChars(RaS_list(i));
    Ra = RaStoRa(RaS);
    NewData.(PrS).(RaS).Ra = Ra;
    NewData.(PrS).(RaS).Pr = Pr;
    PsiE = OldData.Data.(RaS).PsiE;
    ThetaE = OldData.Data.(RaS).ThetaE;
    [V, sigma] = eigensolver(PsiE, ThetaE, 32, 2, Pr, Ra);
    NewData.(PrS).(RaS).V = V;
    NewData.(PrS).(RaS).sigma = diag(sigma);
end

%% Getting closer to crossing
G = 2;
%AR = ['AR_' num2str(G)];
AR= 'AR_2';
type = 'OneOne32';
N = 32;
Ny = N;
Nx = N;
Pr_list = [30];
for i =1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    try
        [cross, diff, ~] = findcrossandfreq(Data.(AR).(type), Pr);
    catch
        cross = 0;
    end
    count = 0;
    while cross == 0
        Ra = 4e4*2^count;
        RaS = RatoRaS(Ra)
        if count == 0
            PrC = ClosestPr(Pr, string(fieldnames(Data.(AR).(type))));
            PsiE = Data.(AR).(type).(PrC).(RaS).PsiE;
            ThetaE = Data.(AR).(type).(PrC).(RaS).ThetaE;  
        end    
        [PsiE, ThetaE, dxmin] = NR(PsiE, ThetaE, Nx, Ny, G, Ra, Pr);
        Data.(AR).(type).(PrS).(RaS).PsiE = PsiE;
        Data.(AR).(type).(PrS).(RaS).ThetaE = ThetaE;
        Data.(AR).(type).(PrS).(RaS).dxmin = dxmin;
        [~, sigma] = eigensolver(PsiE, ThetaE, N, G, Pr, Ra);
        Data.(AR).(type).(PrS).(RaS).sigma = diag(sigma);
        max(real(diag(sigma)))
        try
            [cross, diff, ~] = findcrossandfreq(Data.(AR).(type), Pr);
        catch
            cross = 0;
        end 
        count = 1+count;
    end
    while diff > 10^floor(log10(cross))*0.01
        Ra = round(cross, 3, 'significant')
        try
            [PsiE, ThetaE, dxmin] = NR(PsiE, ThetaE, Nx, Ny, G, Ra, Pr);
        catch
            RaC = ClosestRa(Ra, string(fieldnames(Data.(AR).(type).(PrS))));
            PsiE = Data.(AR).(type).(PrS).(RaC).PsiE;
            ThetaE = Data.(AR).(type).(PrS).(RaC).ThetaE;
            [PsiE, ThetaE, dxmin] = NR(PsiE, ThetaE, Nx, Ny, G, Ra, Pr);
        end
        RaS = RatoRaS(Ra);
        Data.(AR).(type).(PrS).(RaS).PsiE = PsiE;
        Data.(AR).(type).(PrS).(RaS).ThetaE = ThetaE;
        Data.(AR).(type).(PrS).(RaS).dxmin = dxmin;
        [~, sigma] = eigensolver(PsiE, ThetaE, N, G, Pr, Ra);
        Data.(AR).(type).(PrS).(RaS).sigma = diag(sigma);
        [cross, diff, ~] = findcrossandfreq(Data.(AR).(type), Pr);
    end
    [cross, diff, ~] = findcrossandfreq(Data.(AR).(type), Pr);
    Data.(AR).(type).(PrS).cross = cross;
end
%% Check if cross at all


%% Find 2nd crossing
type = "OneOne";
AR = 'AR_2';
G = 2;
N = 32;
Ny = N;
Nx = N;
Pr_list = [6.17 6.18];
for i =1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    try
        [cross, diff] = SecondCrossing(Data, Pr, type);
    catch
        cross = 0;
    end
    while cross == 0
        RaSlist = string(fieldnames(Data.(AR).(type).(PrS)));
        % cleaning up
        RaSlist(RaSlist == "cross") = [];
        RaSlist(RaSlist == "secondcross") = [];
        RaSlist = OrderRaS_list(RaSlist);
        RaS = RaSlist(end);
        PsiE = Data.(AR).OneOne.(PrS).(RaS).PsiE;
        ThetaE = Data.(AR).OneOne.(PrS).(RaS).ThetaE;    
        Ra = 2*RaStoRa(RaS);
        RaS = RatoRaS(Ra); 
        [PsiE, ThetaE, dxmin] = NR(PsiE, ThetaE, Nx, Ny, G, Ra, Pr);
        Data.(AR).OneOne.(PrS).(RaS).PsiE = PsiE;
        Data.(AR).OneOne.(PrS).(RaS).ThetaE = ThetaE;
        Data.(AR).OneOne.(PrS).(RaS).dxmin = dxmin;
        [~, sigma] = eigensolver(PsiE, ThetaE, N, G, Pr, Ra);
        Data.(AR).OneOne.(PrS).(RaS).sigma = diag(sigma);
        max(real(diag(sigma)))
        try
            [cross, diff] = SecondCrossing(Data.(AR), Pr, type);
        catch
            cross = 0;
        end 
    end
    
    while diff > 10^floor(log10(cross))*0.01
        Ra = round(cross, 3, 'significant')
        try
            [PsiE, ThetaE, dxmin] = NR(PsiE, ThetaE, Nx, Ny, G, Ra, Pr);
        catch
            RaC = ClosestRa(Ra, string(fieldnames(Data.(AR).OneOne.(PrS))));
            PsiE = Data.(AR).OneOne.(PrS).(RaC).PsiE;
            ThetaE = Data.(AR).OneOne.(PrS).(RaC).ThetaE;
            [PsiE, ThetaE, dxmin] = NR(PsiE, ThetaE, Nx, Ny, G, Ra, Pr);
        end
        RaS = RatoRaS(Ra);
        Data.(AR).OneOne.(PrS).(RaS).PsiE = PsiE;
        Data.(AR).OneOne.(PrS).(RaS).ThetaE = ThetaE;
        Data.(AR).OneOne.(PrS).(RaS).dxmin = dxmin;
        [~, sigma] = eigensolver(PsiE, ThetaE, N, G, Pr, Ra);
        Data.(AR).OneOne.(PrS).(RaS).sigma = diag(sigma);
        [cross, diff] = SecondCrossing(Data.(AR), Pr, type);
    end
    [cross, diff] = SecondCrossing(Data.(AR), Pr, type);
    Data.(AR).OneOne.(PrS).secondcross = cross;       
end
%% Functions
function [cross, di] =  SecondCrossing(Data, Pr, type)
    PrS = PrtoPrS(Pr);
    RaSlist = string(fieldnames(Data.(type).(PrS)));
    % cleaning up
    RaSlist(RaSlist == "cross") = [];
    RaSlist(RaSlist == "secondcross") = [];
    RaSlist = OrderRaS_list(RaSlist);
    signs = zeros(length(RaSlist), 1);
    for i=1:length(signs)
        RaS = RaSlist(i);
        eig = max(real(Data.(type).(PrS).(RaS).sigma));
        signs(i) = sign(eig);    
    end
    change = find(diff(sign(signs)));
    try
       change = change(2);
       RaS1 = RaSlist(change); Ra1 = RaStoRa(RaS1);
       RaS2 = RaSlist(change+1); Ra2 = RaStoRa(RaS2);
       cross = (Ra1 + Ra2)/2; di = abs(Ra1 - Ra2);
    catch
         cross = 0; di = 0;       
    end        
end

function plotevenfunction(PsiE, ThetaE, N, G)
    figure('Renderer', 'painters', 'Position', [5 5 540 200])
    ninst = [1:2:(N/2-1) 0:2:(N/2-2)]; ninst = repmat(ninst, N/2); ninst = ninst(1,:); kxinst = ninst*2*pi/G;
    minst = 1:N; minst = repelem(minst, N/4); kyinst = minst*pi;

    x = linspace(G/(2*N*2), G-G/(2*N*2), 2*N); % Evaluate inside squares, 2N since we actually have double the grid points due to e/o decomp
    y = linspace(1/(2*N*2), 1-1/(2*N*2), 2*N);
    [xx, yy] = meshgrid(x,y);

    % Setting up function data matrix
    FDM = zeros(N*2,N*2, length(kxinst));
    for i=1:length(kxinst)
        kxp = kxinst(i);
        kyp = kyinst(i);
        FDM(:,:,i) = sin(kyp*yy).*exp(1i*xx*kxp);
    end

    Eigenfuntionpsi = zeros(2*N, 2*N);
    Eigenfuntiontheta = zeros(2*N, 2*N);

    % Calculating the eigenfunction
    for i=1:length(kxinst) % Looping round eigenfunctions
        amppsi = PsiE(i);
        amptheta = ThetaE(i);
        Eigenfuntionpsi = amppsi*FDM(:,:,i) + Eigenfuntionpsi;
        Eigenfuntiontheta = amptheta*FDM(:,:,i) + Eigenfuntiontheta;
    end

    subplot(1,2,1)
    pcolor(real(Eigenfuntionpsi));
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
    pcolor(real(Eigenfuntiontheta));
    shading flat
    colormap('jet')
    colorbar
    xlabel('$x$', 'FontSize', 14)
    ylabel('$y$', 'FontSize', 14)
    xticks([1 2*N])
    xticklabels({'$0$' '$\Gamma$'})
    yticks([1 2*N])
    yticklabels({'$0$' '$1$'})
    title('$Real(\theta )$', 'FontSize', 15)
end


function [cross, diff, freq] = findcrossandfreq(Data, Pr)
PrS = PrtoPrS(Pr);
RaS_list = string(fieldnames(Data.(PrS)));
RaS_list = RaS_list(RaS_list~="cross");
RaS_list = OrderRaS_list(RaS_list);
neg = 1;
i = 0;
RaNew = 0;
while neg
    i = i + 1;
    RaS = RaS_list(i);
    sigma = Data.(PrS).(RaS).sigma;
    [maxreal, I] = max(real(sigma));
    RaOld = RaNew;
    RaNew = RaStoRa(RaS);
    if maxreal > 0
        neg = 0;
        diff = abs(RaOld - RaNew);
        cross = (RaOld + RaNew)/2;
        freq = imag(sigma(I));
    end
end
if neg == 1
   cross = 0; 
end
end


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

% atempt to rectify the imaginary eigenfunction
% x = xx(1,1);
% y = yy(1,1);
% Eig = Eigenfuntion(1,1)


subplot(1,2,1)
pcolor(real(Eigenfuntion));
%pcolor(imag(Eigenfuntion));
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
%title('$Imag(\psi)$', 'FontSize', 15)

subplot(1,2,2)
y = abs(Vinst);
plot(y, '*')
xlim([0 50])
xticks([])
xlabel('$(k_x, k_y)$', 'FontSize', 14)
ylabel('$| \hat \psi |$', 'FontSize', 14)
title('$(k_x, k_y)$ Spectrum', 'FontSize', 15)
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
psi1 = zeros((N^2/2),(N^2/2)); psi2 = zeros((N^2/2),(N^2/2)); theta1 = zeros((N^2/2),(N^2/2));
for i=1:length(kx_list)
    ninst = round(kx_list(i)*G/(2*pi)); minst = round(ky_list(i)/pi);
    OnesWeWant = checkoe(ninst, minst, N);
    for j=1:length(OnesWeWant)
        modes = OnesWeWant(j,:);
        nodd = modes(1); modd = modes(2); neven = modes(3); meven = modes(4);
        columninst = columnfind(N, nodd, modd);
        % Getting factors
        if neven == -N/2; PsiFact = 0; ThetaFact = 0; else; steadypos = steadyposition(N, abs(neven), meven); PsiFact = PsiE(steadypos); ThetaFact = ThetaE(steadypos); end
        % in the above, we have the steadyposfind behind the else, since it
        % breaks for nsteady == -N/2
        if sign(neven) == -1; PsiFact = conj(PsiFact); ThetaFact = conj(ThetaFact); end % Getting conjugate if needed
        AFact = A(nodd, modd, neven, meven,G, minst);
        
        % Adding to psi1
        psi1(i,columninst) = psi1(i,columninst) + (Square(nodd,modd,G) - Square(neven,meven,G))*AFact*PsiFact;
        % Adding psi2
        psi2(i,columninst) = psi2(i,columninst) + AFact*ThetaFact;
        % Adding theta1
        theta1(i,columninst) = theta1(i,columninst) - AFact*PsiFact;
    end
end
M1 = (1i/2)*inv(Ktwo)*[psi1 zeros((N^2/2),(N^2/2)); zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2))];
M4 = (-1i/2)*[zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2)); psi2 theta1];

M = M1 + M2 + M3 + M4 + M5 + M6;

[V,sigma] = eig(M);
end

function res = checkoe(ninst, minst, N)
neven = [-(N/2-1):2:(N/2-1) -(N/2):2:(N/2-2)]; neven = repmat(neven, N/2); neven = neven(1,:); % We want the negative ones here also, they might not appear actually... they will!
meven = 1:N; meven = repelem(meven, N/2);
nodd = [-(N/2):2:(N/2-2) -(N/2-1):2:(N/2-1)]; nodd = repmat(nodd, N/2); nodd = nodd(1,:);
modd = meven;
res = [];
for i=1:length(neven)
    neveninst = neven(i); meveninst = meven(i);
    for j=1:length(nodd)
        noddinst = nodd(j); moddinst = modd(j);
        if ninst == neveninst + noddinst && (minst == meveninst + moddinst || minst == abs(meveninst - moddinst))
            s = size(res);
            res(s(1)+1, 1) = noddinst; res(s(1)+1, 2) = moddinst; res(s(1)+1, 3) = neveninst; res(s(1)+1, 4) = meveninst;
        end
    end
end
end

function pos = steadyposition(N, ninst, minst)
n = [1:2:(N/2-1) 0:2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:);
m = 1:N; m = repelem(m, N/4);
for i=1:length(n)
    ncheck = n(i); mcheck = m(i);
    if ninst == ncheck && minst == mcheck
        pos = i;
    end
end
end

function pos = columnfind(N,ninst,minst)
n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2); m = m(1,:);
for i=1:length(n)
    ncheck = n(i); mcheck = m(i);
    if ninst == ncheck && minst == mcheck
        pos = i;
    end
end
end

function A = A(nodd, modd, neven, meven,G, minst)
A = (pi^2*2/G)*(nodd*meven*f(meven, modd, minst)-modd*neven*f(modd, meven, minst));
end

function S = Square(ninst,minst,G)
S = (ninst^2)*(2*pi/G)^2 + (minst*pi)^2;
end

function f = f(a,b,c)
if a == b + c
    f = -1;
else
    f = 1;
end
end

function [PsiR, ThetaR, dxmin] = NR(PsiE, ThetaE, Nx, Ny, G, Ra, Pr)
ninst = [1:2:(Nx/2-1) 0:2:(Nx/2-2)]; ninst = repmat(ninst, Ny/2); ninst = ninst(1,:);
% Making sure inputs are in form we want it
arg = angle(PsiE(1));
mult = exp(-1i*ninst*arg);
mult = reshape(mult,length(mult),1);
PsiE = PsiE .* mult;
ThetaE = ThetaE .* mult;

ra = [1 (Nx/4+1):(Nx/2):(Nx*Ny)/4]; % Bits where we want to remvoce the compley parts
%ra = [1];
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
        
        ev = Evaluation(PsiE, ThetaE, Nx, Ny, G, Ra, Pr);
        for j=1:length(ev)
            fxn(j*2-1) = real(ev(j));
            fxn(j*2) = imag(ev(j));
        end           
        
        
        J = Jacobian(PsiE, ThetaE, Nx, Ny, Ra, Pr,G);

        % remove bits we do not want
%         xn([ra*2 ra(2:end)*2+2*length(PsiE) ra(1)*2-1+2*length(PsiE)]) = [];
%         fxn([ra*2 ra(2:end)*2+2*length(PsiE) ra(1)*2-1+2*length(PsiE)]) = [];
%         J([ra*2 ra(2:end)*2+2*length(PsiE) ra(1)*2-1+2*length(PsiE)],:) = [];
%         J(:,[ra*2 ra(2:end)*2+2*length(PsiE) ra(1)*2-1+2*length(PsiE)]) = [];
        xn([ra*2 ra(2:end)*2+2*length(PsiE)]) = [];
        fxn([ra*2 ra(2:end)*2+2*length(PsiE)]) = [];
        J([ra*2 ra(2:end)*2+2*length(PsiE)],:) = [];
        J(:,[ra*2 ra(2:end)*2+2*length(PsiE)]) = [];        


        dx = J\fxn;
        %CheckNew = sum(abs(dx));
        xn1 = xn - dx; % NR
        dxold = dxnew
        dxnew = max(abs(dx))
        
        %max(fxn)
        %semilogy(abs(dx))
        %pause
        % Adding zeros back to xn
        for i=1:length(ra)
           pos = ra(i)*2;
           xn1 = vertcat(xn1(1:pos-1), 0, xn1(pos:end)); 
        end
%         pos = 1 + 2*length(PsiE); % Making sure real part of theta_{1,1} is zero
%         xn1 = vertcat(xn1(1:pos-1), 0, xn1(pos:end));
        for i=2:length(ra)
           pos = ra(i)*2+2*length(PsiE);
           xn1 = vertcat(xn1(1:pos-1), 0, xn1(pos:end)); 
        end
        
        % Making PsiE and ThetaE again
        for j=1:length(PsiE)
            PsiE(j) = xn1(j*2-1) + 1i*xn1(j*2);
            ThetaE(j) = xn1(j*2-1+2*length(PsiE)) + 1i*xn1(j*2+2*length(PsiE));
        end
        
        if dxnew < dxmin
            dxmin = dxnew;
            PsiR = PsiE;
            ThetaR = ThetaE;
            101
        end
    end
end
%PsiR = PsiE;
%ThetaR = ThetaE;
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
        Ainst = A2(n1, m1, n2, m2, 1, G,  minst)/2;
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
        Ainst = A2(n1, m1, n2, m2, 2, G,  minst)/2;
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
        NL = NL + Factor1*Factor2*A2(n1, m1, n2, m2, type, G,  minst);
    elseif type == 2
        Factor2 = ThetaE(findposition(n2, m2, Nx)); if sign(n2) == -1; Factor2 = conj(Factor2); end
        NL = NL + Factor1*Factor2*A2(n1, m1, n2, m2, type, G,  minst);
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

function A = A2(n1, m1, n2, m2, type, G, minst)
kx1 = 2*pi*n1/G; kx2 = 2*pi*n2/G; ky1 = pi*m1; ky2 = pi*m2;
if round(m1) == round(minst + m2); ky1 = -ky1; end % Adding sign stuff, from y integral
if round(m2) == round(minst + m1); ky2 = -ky2; end
if type == 1
    A = (ky1*kx2-ky2*kx1)*(kx2^2+ky2^2);
elseif type == 2
    A = (ky2*kx1-ky1*kx2);
end
end