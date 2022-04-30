%% Getting functions
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrInf/Functions/';
addpath(fpath);
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrInf/Old/Functions/';
addpath(fpath);


dpath = '/Volumes/Samsung_T5/OldData/PrInfData.mat';
load(dpath);



%% checking non-linear term
got = 0;
N = 64;
[~,~,n,m] = GetRemKeep(N,1);
old = OWWee(6,4, n,m,N);
new = OWWinfsteady(6,4, n,m,N);
for i=1:length(old)
   n1old = old(i,1); m1old = old(i,2);  n2old = old(i,3);  m2old = old(i,4);
   for j=1:length(new)
       n1new = abs(new(j,1)); m1new = new(j,2);  n2new = abs(new(j,3));  m2new = new(j,4);
       if n1old == n1new && m1old == m1new && n2old == n2new && m2old == m2new
           got = 1;
           break
       end      
   end
   if not(got)
       [n1old m1old n2old m2old]
   end
   got = 0;
end
    
%%
dpath = '/Volumes/Samsung_T5/OldData/BackUp/PrInfDataOld.mat';
load(dpath);
  




%%
Ra = 1e4;
N = 128;
G = 2;
thres = 1e-14;
%Pr = 1e5;
[~,~,n,m] = GetRemKeep(N,1);
ThetaE = zeros(length(n), 1);
% ThetaE(1) = -abs(-0.39607177942793e-2 + 1i*0.27918570032279e-2)*2;
% ThetaE(22) = -0.15975963663895*2;
% ThetaE(23) = abs(-0.45167139623640e-4 + 1i*0.12655737533296e-3)*2;
% ThetaE(44) =  -abs(-0.28442566340884e-2 + 1i*0.20048784627716e-2)*2;
%ThetaEold = PrInfData.AR_2.N_64.Ra_1e4.ThetaE;
nold = [1:2:(64/2-1) 0:2:(64/2-2)]; nold = repmat(nold, 64/2); nold = nold(1,:);
mold = 1:64; mold = repelem(mold, 64/4);


for i=1:length(nold)
    ncheck = nold(i); mcheck = mold(i);
    for j=1:length(n)
        nn = n(j); mm = m(j);
        if nn == ncheck && mm == mcheck
            ThetaE(j) = ThetaEold(i);
            break       
        end
        
    end

end

K2 = ((2*pi/G)*n').^2 + (pi*m').^2;
K4 = K2.^2;
kx = (2*pi/G)*n';
PsiE = -1i*Ra*ThetaE.*kx./K4;  
positionMatrix = MakepositionMatrix(n,m);

%[PsiR, ThetaR, ~] = NR2inf(PsiE,ThetaE, N, G, Ra,thres);
[ThetaR, ~] = NR3(ThetaE, N, G, Ra,thres);
%[J,Eval] = EvaluationAndJac2inf(PsiE, ThetaE, Ra,G,n,m,N,positionMatrix);







%%

clean = 1;
DNS = 0;
G = 2;
N = 64;
Ra = 800;
RaC = 8*pi^4;
RaA = Ra - RaC;
theta1 = (- pi^3*4/Ra)*2*sqrt(RaA/RaC);
theta2 = 2*sqrt(RaA/RaC)*theta1/2;
AR = ['AR_' num2str(G)];
type = ['N_' num2str(N)];
RaS = RatoRaS(Ra);

ThetaE = zeros(N^2/4,1);
ThetaE(1) = theta1;
ThetaE(N/4+1) = theta2;
%ThetaE = ones(N^2/4,1);

[ThetaE, dxmin] = NRinf(ThetaE, N, G, Ra);
PrInfData.(AR).(type).(RaS).Ra = Ra;
PrInfData.(AR).(type).(RaS).dxmin = dxmin;
PrInfData.(AR).(type).(RaS).ThetaE = ThetaE;
%% odd
M = MakeMatrixForOddProbleminf(N,G, ThetaE, Ra);
M = CleanEigenMatrixinf(M, N,"odd",DNS);
PrInfData.(AR).(type).(RaS).clean = clean;
sigmaodd = eig(M);
clear M
PrInfData.(AR).(type).(RaS).sigmaodd = sigmaodd;
% even
M = MakeMatrixForEvenProbleminf(N,G, ThetaE, Ra);
M = CleanEigenMatrixinf(M, N,"even",DNS);
PrInfData.(AR).(type).(RaS).clean = clean;
sigmaeven = eig(M);
clear M
PrInfData.(AR).(type).(RaS).sigmaeven = sigmaeven;
