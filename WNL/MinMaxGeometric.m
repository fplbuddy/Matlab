datapath = '/Volumes/Samsung_T5/OldData/WNLData.mat';
load(datapath)
fpath = '/Users/philipwinchester/Dropbox/Matlab/WNL/Functions';
addpath(fpath)
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m

%% get data from the solver
G = 2;
GS = GtoGS(G);
Ktwo = (2*pi/G)^2 + pi^2;
a = (1/pi)*(4*G^3/(Ktwo^2*(4+G^2)^2))^(1/3);
b = a*(4+G^2)^2*pi^3/(2*G^3);
eps = 0.001; epsT = RatoRaT(eps);
r = 2e4; rT = RatoRaT(r);
rS = rtorS(r);
epsS = epstoepsS(eps);
t = WNLData.(GS).(epsS).(rS).t;
theta = WNLData.(GS).(epsS).(rS).theta;
phi1 = WNLData.(GS).(epsS).(rS).phi;
TF = islocalmin(phi1);
Is = find(TF == 1);
phimin = phi1(TF);
%
low = 1;
phimin = phimin(low:end)*eps^2; % eps is there due to diff scaling in solver
phi_list = [phimin(1)];
A_list = WNLData.(GS).As;
lambda_list = WNLData.(GS).Fs*b^2;
sigma_list = WNLData.(GS).sigmas*b;
SigDivA = @(A,r) interp1(A_list,sigma_list,A)./(A.*(r-A.^2));
SigDivlam = @(A) interp1(A_list,sigma_list,A)./interp1(A_list,lambda_list,A);
Astar = WNLData.(GS).calcs.Astar;
A0 = Astar*1.1;
Ac = Astar/10;
A0_list = [];
Ac_list = [];
for i=1:length(phimin)-1
   %[Ac,A0,phi] =  getNext(phi,A0,Ac/10,Astar,SigDivA,SigDivlam,r); keeps
   %error
   [Ac,A0,phi] =  getNext(phimin(i),A0,Ac/10,Astar,SigDivA,SigDivlam,r);
    phi_list = [phi_list phi];
    A0_list = [A0_list A0];
    Ac_list = [Ac_list Ac];
end

%% Random plot
Is = Is(low:end);
I = Is(1);
tlower = t(I);

% figure()
% semilogy(t,abs(eps^2*phi1)); hold on
% plot(t(Is),abs(phi_list),'r*','MarkerSize',10)
% %yticks([10-12 1e-10 1e-8 1e-6 1e-4 1e-2 1 1e2 1e4 1e6])
% %ylim([1e-6 5e-3])
% ylabel('$|\phi|$')
% xlabel('$t$')
% xlim([tlower max(t)])
% title(['$Pr = \epsilon =' epsT ',\,\Gamma =' num2str(G) ',\,Ra = Ra_c + r\epsilon^2,\, r = ' rT '$'])
figure()
plot(t,eps^2*phi1); hold on
plot(t(Is),phi_list,'r*','MarkerSize',10)
ylabel('$\phi$')
xlabel('$t$')
xlim([tlower max(t)])
title(['$Pr = \epsilon =' epsT ',\,\Gamma =' num2str(G) ',\,Ra = Ra_c + r\epsilon^2,\, r = ' rT '$'])
saveas(gcf,[figpath 'PrFinitePhiMin'], 'epsc')


%% function

function A0 = GetA0(Astar,A0,phi1,SigDivA,r)
    % Does one NR for A0
    A0 = min(A0-(integral(@(A) SigDivA(A,r), Astar, A0)+phi1)/SigDivA(A0,r),sqrt(r)*0.999999999);
    % min because otherise we integrate over singularity
end

function Ac = GetAc(A0,Ac,SigDivlam)
    % Does one NR for Ac
    Ac = Ac + integral(@(A) SigDivlam(A), Ac, A0)/SigDivlam(Ac);
end

function [Ac,A0,phinext] = getNext(phi,A0,Ac,Astar,SigDivA,SigDivlam,r)
% Get A0
d = 1;
while d > 1e-13
    A0old = A0;
    A0 = GetA0(Astar,A0,phi,SigDivA,r);
    d = abs(A0old-A0);
end
% Get Ac
d = 1;
while d > 1e-13
    Acold = Ac;
    Ac = GetAc(A0,Ac,SigDivlam);
    d = abs(Acold-Ac);
end
% calculate phi2
phinext = integral(@(A) SigDivA(A,r), Ac, Astar);   
end
