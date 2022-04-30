datapath = '/Volumes/Samsung_T5/OldData/WNLData.mat';
load(datapath)
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
%%
figure('Renderer', 'painters', 'Position', [5 5 800 300])
G  = 2; % Presuming we will be looking at G = 2;
a = (4*G^7/((4+G^2)^4*pi^7))^(1/3);
b = a*(4+G^2)^2*pi^3/(2*G^3);
GS = GtoGS(G);
As = WNLData.(GS).As;
Fs = WNLData.(GS).Fs;
sigmas = WNLData.(GS).sigmas;
Ac = 25.5;
A0 = 139.4;
%
axes('Position', [0.05, 0.55, 0.4, 0.3]);
plot(As,sigmas*b,'b'), hold on
plot(-As,sigmas*b,'b')
ylim([-10*b 20])
xlim([-150 150])
xticks([-150 -100 -50 0 Ac 50 83.1 100 A0])
xticklabels(['' '' '' '' '' '' '' '' '' '' ])
ylabel('$\sigma$')
plot([-150 83.1], [0 0], 'k:')
plot([83.1 83.1], [-10*b 0], 'k:')
plot([A0 A0], [-10*b interp1(As,sigmas*b,A0)],'k:')
plot([Ac Ac], [-10*b interp1(As,sigmas*b,Ac)],'k:')
%
%set(subplot(2,2,2), 'Position', [0.05, 0.15, 0.4, 0.3])
axes('Position', [0.05, 0.15, 0.4, 0.3]);
plot(As,Fs*b^2./As,'b'), hold on
plot(-As,Fs*b^2./As,'b'), hold on
xlim([-150 150])
xticks([-150 -100 -50 0 Ac 50 83.1 100 A0])
xlabel('$A$')
ylab = ylabel('$X$');
%ylab.Position(1);
%ylab.Position(1) = ylab.Position(1) + 5;
plot([83.1 83.1], [-10*b^2 10*b^2], 'k:')
plot([A0 A0], [-10*b^2 10*b^2], 'k:')
plot([Ac Ac], [-10*b^2 10*b^2], 'k:')
xticklabels(["-150" "-100" "-50" "0" "$A_c$" "50" "$A_*$" "100" "$A_0$"])
ylim([0 25])
%
ext = 1e-5;
t0 = 1.4193e-3;
t1 = 1.6015e-3;
trang = [t0-ext t1+ext];
r = 2e4;
eps = 1e-3;
G = 2;
GS = GtoGS(G);
eps = 0.001; epsT = RatoRaT(eps);
r = 2e4; rT = RatoRaT(r);
rS = rtorS(r);
epsS = epstoepsS(eps);
t = WNLData.(GS).(epsS).(rS).t;
theta = WNLData.(GS).(epsS).(rS).theta;
phi = WNLData.(GS).(epsS).(rS).phi;
%set(subplot(2,2,3), 'Position', [0.52, 0.55, 0.4, 0.3])
axes('Position', [0.52, 0.55, 0.4, 0.3]);
plot(t,exp(theta),'b-'), hold on
ylabel('$A$');
xlim(trang)
plot([t0 t0], [0 Ac],'k:')
plot([t0-ext t0], [Ac Ac],'k:')
plot([t1 t1], [0 A0],'k:')
plot([t0-ext t1], [A0 A0],'k:')
xticks([t0 t1])
xticklabels(['' ''])
yticks([0 Ac 50 100 A0])
yticklabels(["0" "$A_c$" "50" "100" "$A_0$"])
% 
%set(subplot(2,2,4), 'Position', [0.52, 0.15, 0.4, 0.3])
axes('Position', [0.52, 0.15, 0.4, 0.3]);
plot(t,phi*eps^2,'b-'), hold on
ylabel('$\phi$');
xlabel('$t$')
xlim(trang)
xticks([t0 t1])
xticklabels(["0" "$T$"])
plot([t0 t0], [-7e-4 1e-4],'k:')
plot([t1 t1], [-7e-4 1e-4],'k:')

%saveas(gcf,[figpath 'siglam.eps'], 'epsc')
