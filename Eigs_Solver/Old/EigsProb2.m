% This is based on V13 in overleaf. Have changed some things without
% checking in detial, I THINK it should be right now though...

%% Input
N = 32;
L = 2*pi;
h = pi;
alpha = 1;
g = 1;
DT = 1;
Atwo = 4*pi^2/L^2 + pi^2/h^2;
Ra = 8e2;
Pr = 1;
B = 0; %sqrt((0.32142957270183e-1)^2 + (0.19103339225036e-2)^2); % Taken from runs
C = 0; %sqrt((0.25311952084684e-1)^2 + (0.15043507137726e-2)^2);
%% Set up
nu = sqrt(h^3*Pr/Ra);
kappa = sqrt((h^3/(Ra*Pr)));
dx = L/N;
dy = h/(N-1); 
x = linspace(0, L - dx, N);
y = linspace(dy, h-dy, N-2);
yy = repelem(y, N);
xx = repmat(x, N-2);
xx = xx(1,:);

%% Making Mxxy
stencil = diag(-2*ones(1,N)) + diag(1*ones(1,N-1),1) + diag(1*ones(1,N-1),-1);
% Add periodic BCs in x
stencil(1,N) = 1; stencil(N,1) = 1;

off = diag(1*ones(1,N-1),1) + diag(-1*ones(1,N-1),-1);
Mxxy = kron(off, stencil);

% Adding homogenous BCs in y
Mxxy(:,1:N) = []; Mxxy(:,N^2-2*N+1:N^2-N) = [];
Mxxy(1:N,:) = []; Mxxy(N^2-2*N+1:N^2-N,:) = [];

% Adding factor in front
Mxxy = Mxxy/(2*dx^2*dy);

%% Making Mxyy
diagstencil = diag(-2*ones(1,N-1),1) + diag(2*ones(1,N-1),-1);
% Add periodic BCs in x
diagstencil(1,N) = 2; diagstencil(N,1) = -2;

offdiagstencil = diag(1*ones(1,N-1),1) + diag(-1*ones(1,N-1),-1);
% Add periodic BCs in x
offdiagstencil(1,N) = -1; offdiagstencil(N,1) = 1;

Mxyy = kron(eye(N), diagstencil) + kron(diag(1*ones(1,N-1),1) + diag(1*ones(1,N-1),-1), offdiagstencil);
% Adding homogenous BCs in y
Mxyy(:,1:N) = []; Mxyy(:,N^2-2*N+1:N^2-N) = [];
Mxyy(1:N,:) = []; Mxyy(N^2-2*N+1:N^2-N,:) = [];

% Adding factor in front
Mxyy = Mxyy/(2*dx*dy^2);

%% Making other Matrecies
% My
My = diag(0.5*ones(1,N-1),1) + diag(-0.5*ones(1,N-1),-1);
My = kron(My, eye(N));
My(:,1:N) = []; My(:,N^2-2*N+1:N^2-N) = [];
My(1:N,:) = []; My(N^2-2*N+1:N^2-N,:) = [];
My = My/(dy);

% Mx
Mx = diag(0.5*ones(1,N-1),1) + diag(-0.5*ones(1,N-1),-1);
Mx(1,N) = -0.5; Mx(N,1) = 0.5; % Periodic BCs
Mx = kron(eye(N), Mx);
Mx(:,1:N) = []; Mx(:,N^2-2*N+1:N^2-N) = [];
Mx(1:N,:) = []; Mx(N^2-2*N+1:N^2-N,:) = [];
Mx = Mx/(dx);

% Myy
Myy = diag(-2*ones(1,N)) + diag(1*ones(1,N-1),1) + diag(1*ones(1,N-1),-1);
Myy = kron(Myy, eye(N));
Myy(:,1:N) = []; Myy(:,N^2-2*N+1:N^2-N) = [];
Myy(1:N,:) = []; Myy(N^2-2*N+1:N^2-N,:) = [];
Myy = Myy/(dy^2);

% Mxx
Mxx = diag(-2*ones(1,N)) + diag(1*ones(1,N-1),1) + diag(1*ones(1,N-1),-1);
Mxx(1,N) = 1; Mxx(N,1) = 1; % Periodic BCs
Mxx = kron(eye(N), Mxx);
Mxx(:,1:N) = []; Mxx(:,N^2-2*N+1:N^2-N) = [];
Mxx(1:N,:) = []; Mxx(N^2-2*N+1:N^2-N,:) = [];
Mxx = Mxx/(dx^2);

% Myyy
Myyy = diag(-1*ones(1,N-1),1) + diag(0.5*ones(1,N-2),2) + diag(1*ones(1,N-1),-1) + diag(-0.5*ones(1,N-2),-2);
Myyy = kron(Myyy, eye(N));
Myyy(:,1:N) = []; Myyy(:,N^2-2*N+1:N^2-N) = [];
Myyy(1:N,:) = []; Myyy(N^2-2*N+1:N^2-N,:) = [];
Myyy = Myyy/(dy^3);

% Mxxx
Mxxx = diag(-1*ones(1,N-1),1) + diag(0.5*ones(1,N-2),2) + diag(1*ones(1,N-1),-1) + diag(-0.5*ones(1,N-2),-2);
Mxxx(1,N) = 1; Mxxx(N,1) = -1; % Periodic BCs
Mxxx(N,2) = 0.5; Mxxx(N-1,1) = 0.5; % Periodic BCs
Mxxx(1,N-1) = -0.5; Mxxx(2,N) = -0.5; % Periodic BCs
Mxxx = kron(eye(N), Mxxx);
Mxxx(:,1:N) = []; Mxxx(:,N^2-2*N+1:N^2-N) = [];
Mxxx(1:N,:) = []; Mxxx(N^2-2*N+1:N^2-N,:) = [];
Mxxx = Mxxx/(dx^3);

% Myyyy
Myyyy = diag(6*ones(1,N),0) + diag(-4*ones(1,N-1),1) + diag(1*ones(1,N-2),2) + diag(-4*ones(1,N-1),-1) + diag(1*ones(1,N-2),-2);
Myyyy = kron(Myyyy, eye(N));
Myyyy(:,1:N) = []; Myyyy(:,N^2-2*N+1:N^2-N) = [];
Myyyy(1:N,:) = []; Myyyy(N^2-2*N+1:N^2-N,:) = [];
Myyyy = Myyyy/(dy^4);

% Mxxx
Mxxxx = diag(6*ones(1,N),0) + diag(-4*ones(1,N-1),1) + diag(1*ones(1,N-2),2) + diag(-4*ones(1,N-1),-1) + diag(1*ones(1,N-2),-2);
Mxxxx(1,N) = -4; Mxxxx(N,1) = -4; % Periodic BCs
Mxxxx(N,2) = 1; Mxxxx(N-1,1) = 1; % Periodic BCs
Mxxxx(1,N-1) = 1; Mxxxx(2,N) = 1; % Periodic BCs
Mxxxx = kron(eye(N), Mxxxx);
Mxxxx(:,1:N) = []; Mxxxx(:,N^2-2*N+1:N^2-N) = [];
Mxxxx(1:N,:) = []; Mxxxx(N^2-2*N+1:N^2-N,:) = [];
Mxxxx = Mxxxx/(dx^4);

%% Sin and Cos
sinx = diag(sin((2*pi/L)*xx));
cosx = diag(cos((2*pi/L)*xx));
siny = diag(sin((pi/h)*yy));
cosy = diag(cos((pi/h)*yy));

%%
D = (Mxx + Myy);
E = (4*B*pi/L)*(Mxxy + Myyy + Atwo*My)*cosx*siny - (2*B*pi/h)*(Mxxx + Mxyy + Atwo*Mx)*cosy*sinx + nu*(Mxxxx + Myyyy);
F = g*alpha*Mx;
%G = siny;
H = -(4*C*pi/L)*My*siny*sinx-(2*C*pi/h)*Mx*cosy*cosx + (DT/h)*Mx;
K = (4*B*pi/L)*My*siny*cosx-(2*B*pi/h)*Mx*cosy*sinx + kappa*(Mxx + Myy);

iD = inv(D);
%ciG = inv(G);

Ehat = E*iD;
Fhat = F*iD;
Hhat = H;
Khat = K;

M = [Ehat Fhat; Hhat Khat];

[V,sigma] = eig(M); % Solving the eigs problem

%% Plotting eigenfunction
Column = V(:,1);
Column = Column(1:length(Column)/2);
Column = abs(Column);
Mat = reshape(Column, [N, N-2]);
figure
pcolor(Mat');
shading flat
colormap('jet')
colorbar
