%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Notes: 
% kx = 0 only gives one eigenfunction since we have repeated roots for
% sigm
% and they come one their own as equations are essentially uncoupled when
% we dont have any x dependance. 

% Questions
% What happens for kx=-2 node in Nx=Ny=4 case? There is no complex
% conjugate?
% Why does the other root decay?? It looks the same when we plot it


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
Nx = 32;
Ny = 32;
Ra = 8e2;
Pr = 1;
nu = sqrt(pi^3*Pr/Ra);
kappa = sqrt((pi^3/(Ra*Pr)));
DT = 1;
g = 1;
alpha = 1;

kx_list = zeros(Nx,1);
ky_list = zeros(Ny,1);
kx_ky_list = zeros(Ny*Nx,2);

% Making the kx_list
for i=2:2:Nx
    j = i/2;
    k = i/2 + Nx/2;
    kx_list(j) = j-1;
    kx_list(k) = -Nx/2-1 + j;    
end
%kx_list =  (1/100).*kx_list
% Making the ky_list
for i=1:Ny
    ky_list(i) = i;
end

% Making kx_ky_list
index = 0;
for i=1:Nx
    for j=1:Ny
        index = index + 1;
        kx_ky_list(index,1) = kx_list(i);
        kx_ky_list(index,2) = ky_list(j);
    end
end

% Making the four column vectors, will later multiply these by the identity
TL_col = -nu*ones(Nx*Ny,1);
TR_col = -1i*g*alpha*ones(Nx*Ny,1);
BL_col = DT*1i/pi*ones(Ny*Nx,1);
BR_col = -kappa*ones(Nx*Ny,1);

index = 0;
for i=1:Nx
    for j=1:Ny
        index = index + 1;
        TL_col(index) = TL_col(index)*Ksq(kx_list(i),ky_list(j));
        TR_col(index) = TR_col(index)*(kx_list(i)/Ksq(kx_list(i),ky_list(j)));
        BL_col(index) = kx_list(i)*BL_col(index);
        BR_col(index) = BR_col(index)*Ksq(kx_list(i),ky_list(j));
    end
end

% Making the four quadrants
I = eye(Ny*Nx);
TL = TL_col.*I;
TR = TR_col.*I;
BL = BL_col.*I;
BR = BR_col.*I;

M = [TL TR; BL BR]; % Constructing the matrix
[V,D] = eig(M); % Solving the eigs problem
Vabs = abs(V); % Takiing absolute value of eig functions
% Gets rid of small values in Vabs and V
for i=1:(Nx*2*Ny)
    for j=1:(Nx*2*Ny)
        if (Vabs(i,j) < 10^(-10)) && (Vabs(i,j) > 0)
            Vabs(i,j) = 0;
            V(i,j) = 0;
        end
    end
end
spy(Vabs);
eigs_list_real = real(diag(D));
%% Plots
plotheatmap(V(:,33),V(:,993), kx_ky_list,1)

%% Function
function ans = Ksq(kx,ky)
    ans = kx^2+ky^2;
end

function plotheatmap(V1, V2, kx_ky_list,F)
    % V1 and V2 are the two eigenfunctions with the same eigenvalue
    % F = 1 plots psi, 2 plots theta 
    i = find(V1,2);
    j = find(V2,2);
    Factor1 = V1(i(F));
    Factor2 = V2(j(F));
    
    % Finding wavenumbers
    sub=0;
    if F==2
        sub = size(kx_ky_list,1);
    end  
    
    kx1 = kx_ky_list(i(F)-sub,1); % Wavenumbers for V1
    ky1 = kx_ky_list(i(F)-sub,2);
    kx2 = kx_ky_list(j(F)-sub,1); % Wavenumbers for V2
    ky2 = kx_ky_list(j(F)-sub,2);
    
    % Setting up our Grid
    s = 100;
    x = linspace(0, 2*pi,s);
    y = flip(linspace(0, pi,s));   
    Grid = zeros(s,s);
    
    Factor2 = 0
    % Filling the Grid
    for i=1:length(x)
        for j=1:length(y)
            Grid(j,i) = real(Factor1*exp(1i*kx1*x(i))*sin(ky1*y(j))) + ...
                Factor2*exp(1i*kx2*x(i))*sin(ky2*y(j));           
        end
    end
   
    figure
    h=pcolor(Grid)
    set(h, 'EdgeColor', 'none');
end