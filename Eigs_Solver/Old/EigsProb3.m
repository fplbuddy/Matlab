% kpsmodes1 = importdata('/Volumes/Samsung_T5/Eigs_Prob/128x128/Pr_10/Ra_1e4/Checks/kpsmodes1.txt');
% kpsmodes2 = importdata('/Volumes/Samsung_T5/Eigs_Prob/128x128/Pr_10/Ra_1e4/Checks/kpsmodes2.txt');
% kpsmodes3 = importdata('/Volumes/Samsung_T5/Eigs_Prob/128x128/Pr_10/Ra_1e4/Checks/kpsmodes3.txt');
% 
% 
% semilogy(kpsmodes1(:,1), abs(kpsmodes1(:,4))), hold on
% plot(kpsmodes1(:,1), abs(kpsmodes1(:,6))), hold off

%%
N = 32;
Ra = 1e4;
Pr = 10;
nu = sqrt(pi^3*Pr/Ra);
kappa = sqrt((pi^3/(Ra*Pr)));
G = 2;
nx = 128;
ny = 128;
xr = floor(nx/3 + 1) + 1;
yr = floor(2*ny/3 + 1);

%% Making simple matrecies
kx = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; kx = repmat(kx, N);  kx = kx(1,:)*2*pi/G; % N rather than N/2 as we want theta also
ky = 1:N; ky = repelem(ky, N/2); ky = repmat(ky, 2); ky = ky(1,:)*pi;
Ktwo = kx.^2 + ky.^2;
kx = diag(kx); ky = diag(ky); Ktwo = diag(Ktwo);

M2 = -1i*Ra*Pr*inv(Ktwo)*kx*[zeros((N^2/2),(N^2/2)) eye((N^2/2)); zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2))];
M3 = -Pr*Ktwo*[eye((N^2/2)) zeros((N^2/2),(N^2/2)); zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2))];
M5 = 1i*kx*[zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2)); eye((N^2/2)) zeros((N^2/2),(N^2/2))];
M6 = -Ktwo*[zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2)); zeros((N^2/2),(N^2/2)) eye((N^2/2))];

%% Getting data 
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
psireal = reshape(psireal,xr,yr); psireal = psireal'/kappa; % Non-dim

% Imag psi
fid = fopen([path 'spectrum2D_UUimag.' num '.out'],'r'); fread(fid,1, 'real*4');
psiimag = fread(fid,inf, 'real*8');
fclose(fid);
psiimag = reshape(psiimag,xr,yr); psiimag = psiimag'/kappa; % Non-dim

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

%% Making hard ones
kx_list = diag(kx); ky_list = diag(ky);
kx_list = kx_list(1:(length(kx_list)/2)); ky_list = ky_list(1:(length(ky_list)/2)); 
for i=1:length(kx_list)
    kxint = round(kx_list(i)*G/(2*pi)); kyint = round(ky_list(i)/pi);
    psi1 = zeros((N^2/2),(N^2/2)); psi2 = zeros((N^2/2),(N^2/2)); theta1 = zeros((N^2/2),(N^2/2));
    OnesWeWant = checkoe(kxint,kyint,N);
    
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
        A = psireal(kye, abs(kxe)+1) + sign(kxe)*psiimag(kye, abs(kxe)+1);
        B = thetareal(kye, abs(kxe)+1) + sign(kxe)*thetaimag(kye, abs(kxe)+1);
        if round(kye) == round(kyint + kyo); kye = -kye; end % Adding sign stuff
        if round(kyo) == round(kyint + kye); kyo = -kyo; end
        
        
        factor1 = (kxo*2*pi/G)^2 + (kyo*pi)^2 - (kxe*2*pi/G)^2 + (kye*pi)^2;
        factor2 = kxe*kyo*2*pi^2/G - kxo*kye*2*pi^2/G;
        
        % Addding to psi1
        psi1(i, pos) = A*factor1*factor2;
        % Adding to psi2
        psi2(i, pos) = B*factor2;
        % Adding to theta1
        theta1(i, pos) = -A*factor2;   
    end
end

M1 = (-1i/2)*inv(Ktwo)*[psi1 zeros((N^2/2),(N^2/2)); zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2))];
M4 = (1i/2)*[zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2)); psi2 theta1];
%% Solving eigs problem
M = M1 + M2 + M3 + M4 + M5 + M6;

[V,sigma] = eig(M);
%% Plotting

% Eigenvalues
sigma = diag(sigma);
figure
plot(real(sigma), imag(sigma), '*')
xlabel('$Real(\sigma)$')
ylabel('$Imag(\sigma)$')

figure
plot(real(sigma), '*')

% Eigenfunction
Vinst = V(:,547); % Picking an eigenfunction
%Vinst = Vinst(1:length(Vinst)/2); % Only taking psi part
Vinst = Vinst(length(Vinst)/2+1:end); % theta part
x = linspace(G/(2*N), G-G/(2*N), N); % Evaluate inside squares
y = linspace(1/(2*N), 1-1/(2*N), N);
[xx, yy] = meshgrid(x,y);

% Setting up function data matrix
FDM = zeros(N,N, length(kx_list));
for i=1:length(kx_list)
    kxp = kx_list(i);
    kyp = ky_list(i);
    FDM(:,:,i) = sin(kyp*yy)*exp(1i*xx*kxp);
end

Eigenfuntion = zeros(N, N);

% Calculating the eigenfunction
for i=1:length(kx_list) % Looping round eigenfunctions
    amp = Vinst(i);
    Eigenfuntion = amp*FDM(:,:,i) + Eigenfuntion;
end

figure
pcolor(real(Eigenfuntion));
shading flat
colormap('jet')
colorbar



%% Functions

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
