%% Making some constant matrecies
two = 2*eye(2*N^2);

%% Making Kx, Ky and K2
kx = -N/2:(N/2-1); kx = repmat(kx, 2*N); kx = kx(1,:);
ky = 1:N; ky = repelem(ky, N); ky = repmat(ky, 2); ky = ky(1,:);
Ktwo = kx.^2 + ky.^2;
% Making into matrix
kx = diag(kx); ky = diag(ky); Ktwo = diag(Ktwo);

%% Making matrecies
StencilUpper = diag(1*ones(1,N-1),1) + diag(1*ones(1,N-1),-1); StencilLower = diag(-1*ones(1,N-1),1) + diag(-1*ones(1,N-1),-1);
M1 = kron(diag(1*ones(1,N-1),1), StencilUpper) + kron(diag(1*ones(1,N-1),-1), StencilLower);
M1 = [M1 zeros(N^2,N^2); zeros(N^2,N^2) zeros(N^2,N^2)]; % Make right size
M1 = M1*ky*B*(-Ktwo + two)*inv(Ktwo)/2; % Adding prefactor NEEDS TO BE IN THIS ORDER

StencilUpper = diag(1*ones(1,N-1),1) + diag(-1*ones(1,N-1),-1); StencilLower  = diag(1*ones(1,N-1),1) + diag(-1*ones(1,N-1),-1);
M2 = kron(diag(1*ones(1,N-1),1), StencilUpper) + kron(diag(1*ones(1,N-1),-1), StencilLower);
M2 = [M2 zeros(N^2,N^2); zeros(N^2,N^2) zeros(N^2,N^2)]; % Make right size
M2 = M2*(1i)^2*kx*B*(-Ktwo + two)*inv(Ktwo)/2; % Adding prefactor NEEDS TO BE IN THIS ORDER

M3 = [zeros(N^2,N^2) eye(N^2); zeros(N^2,N^2) zeros(N^2,N^2)]; % Make right size
M3 = M3*(1i)*kx*g*a*inv(Ktwo); % Adding prefactor

M4 = [eye(N^2) zeros(N^2,N^2); zeros(N^2,N^2) zeros(N^2,N^2)];
M4 = M4*Ktwo*nu;
%%%
StencilUpper = diag(1*ones(1,N-1),1) + diag(1*ones(1,N-1),-1); StencilLower = diag(-1*ones(1,N-1),1) + diag(-1*ones(1,N-1),-1);
M5 = kron(diag(1*ones(1,N-1),1), StencilUpper) + kron(diag(1*ones(1,N-1),-1), StencilLower);
M5 = [zeros(N^2,N^2) zeros(N^2,N^2); zeros(N^2,N^2) M5]; % Make right size
M5 = M5*ky*B/2; % Adding prefactor NEEDS TO BE IN THIS ORDER

StencilUpper = diag(1*ones(1,N-1),1) + diag(-1*ones(1,N-1),-1); StencilLower  = diag(1*ones(1,N-1),1) + diag(-1*ones(1,N-1),-1);
M6 = kron(diag(1*ones(1,N-1),1), StencilUpper) + kron(diag(1*ones(1,N-1),-1), StencilLower);
M6 = [zeros(N^2,N^2) zeros(N^2,N^2); zeros(N^2,N^2) M6]; % Make right size
M6 = M6*(1i)^2*kx*B/2; % Adding prefactor NEEDS TO BE IN THIS ORDER

StencilUpper = diag(1*ones(1,N-1),1) + diag(-1*ones(1,N-1),-1); StencilLower  = diag(-1*ones(1,N-1),1) + diag(1*ones(1,N-1),-1);
M7 = kron(diag(1*ones(1,N-1),1), StencilUpper) + kron(diag(1*ones(1,N-1),-1), StencilLower);
M7 = [zeros(N^2,N^2) zeros(N^2,N^2); M7 zeros(N^2,N^2)]; % Make right size
M7 = M7*1i*ky*C/2; % Adding prefactor NEEDS TO BE IN THIS ORDER

StencilUpper = diag(1*ones(1,N-1),1) + diag(1*ones(1,N-1),-1); StencilLower  = diag(1*ones(1,N-1),1) + diag(1*ones(1,N-1),-1);
M8 = kron(diag(1*ones(1,N-1),1), StencilUpper) + kron(diag(1*ones(1,N-1),-1), StencilLower);
M8 = [zeros(N^2,N^2) zeros(N^2,N^2); M8 zeros(N^2,N^2)]; % Make right size
M8 = M8*1i*kx*C/2; % Adding prefactor NEEDS TO BE IN THIS ORDER

M9 = [zeros(N^2,N^2) zeros(N^2,N^2); eye(N^2) zeros(N^2,N^2)]; % Make right size
M9 = M9*1i*kx*DT/pi; % Adding prefactor

M10 = [zeros(N^2,N^2) zeros(N^2,N^2); zeros(N^2,N^2) eye(N^2)]; % Make right size
M10 = M10*kappa*Ktwo; % Adding prefactor

%% Adding matrecies and solving eigs problem
M = -M1 + M2 - M3 - M4 + M5 - M6 - M7 - M8 + M9 - M10;

[V,sigma] = eig(M);

% Normalising eigenvectors
W = zeros(2*N^2,2*N^2);
for i=1:2*N^2
   Vector = V(:,i);
   Norm = sqrt(sum(Vector.*conj(Vector)));
   Vector = abs(Vector/Norm);
   for j=1:length(Vector)
      if Vector(j) < 1/(2*N^2); Vector(j) = 0; end 
   end
   W(:,i) = Vector;
end