fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
fpath3 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/LowDim/Functions/';
addpath(fpath)
addpath(fpath2)
addpath(fpath3)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
spath = dpath;
load(dpath);
%%
Pr = 1e-3;
PrS = PrtoPrSZero(Pr);
RaA = 1e-4;
RaAS = RaAtoRaAS(RaA);
RaC = 8*pi^4;
Ra = 8*pi^4 + RaC;
psi = sqrt(RaA/RaC)*2;
theta = 4*psi*pi^3/Ra;
M = MakeMatrixLowDim(psi, theta, Ra, Pr);
det1 = det(M);
% getting factors

A =  -M(1,1)/Pr;
B = M(2,1)/psi;
C = abs(M(5,1))/theta;
D = M(1,2)/psi;
E = -M(2,2)/Pr;
F = abs(M(3,5))/(Ra*Pr);
G = abs(M(5,5));

% getting terms
term1 = -G^2*A*E^2*Pr^3;
term2 = 2*A*E*F*pi*G*Ra*Pr^3;
term3 = 2*B*D*E*(G^2)*(psi^2)*Pr;
term4 = -2*B*D*G*F*pi*Ra*Pr*psi^2;
term5 = 2*G*C*D*E*F*theta*psi*Ra*Pr^2;
term6 = -A*F^2*pi^2*Pr^3*Ra^2;
term7 = - 2*C*D*F^2*pi*Pr^2*theta*psi*Ra^2;

det2 = term1 + term2 + term3 + term4 + term5 + term6 + term7;

%% Making similar to wolfram
% one in front of G
% N = M(1:4,1:4);
% det1 = det(N);
% 
% term1 = term1/(-G);
% term2 = term2/(-2*G);
% term3 = term3/(-G);
% term4 = term4/(-2*G);
% term5 = term5/(-2*G);
% det2 = term1 + term2 + term3 + term4 + term5;
% 
% 
% 
% %% Combined
% A = A*Pr;
% B = B*psi;
% C = C*theta;
% D = D*psi;
% E = E*Pr;
% F = F*Pr*Ra;
% 
% 
% Nnew = [-A D D 0; B -E 0 1i*F; B 0 -E 0; -1i*C -1i*pi 0 -G];
% 
% term11 = A*E^2*G;
% term22 = -A*E*F*pi;
% term33 = -2*B*D*E*G;
% term44 = B*D*F*pi;
% term55 = - C*D*E*F;
% det2 = term1 + term2 + term3 + term4 + term5;
