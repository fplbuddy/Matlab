run SetUp.m
datapath = '/Volumes/Samsung_T5/OldData/WNLData.mat';
load(datapath)
%%
figure('Renderer', 'painters', 'Position', [5 5 900 200])
xstart = 0.05;
width = 0.25;
height = 0.61;
dif = 0.06;
ystart = 0.25;
subplot(1,3,1)
set(subplot(1,3,1), 'Position', [xstart, ystart, width, height])
G  = 2;
GS = GtoGS(G);
Ktwo = (2*pi/G)^2 + pi^2;
a = (1/pi)*(4*G^3/(Ktwo^2*(4+G^2)^2))^(1/3);
b = a*(4+G^2)^2*pi^3/(2*G^3);
As = WNLData.(GS).As;
Fs = WNLData.(GS).Fs*b^2;
sigmas = WNLData.(GS).sigmas*b;
Astar = interp1(sigmas,As,0);
FAstar = interp1(As,Fs,Astar);
Fdash = diff(Fs)/mean(diff(As));
FdashAstar = interp1(As(2:end),Fdash,Astar);
rend = Astar^2 + 2*Astar^2*FAstar/(FAstar-Astar*FdashAstar);

% make first bit
r = 0:0.1:Astar^2;
B = zeros(1,length(r));
A = sqrt(r);
plot(r, A/83.1,'blue-'), hold on
plot(r, B/100,'red-')

% make second bit
r = Astar^2:0.1:rend;
A = ones(1,length(r))*Astar;
B = sqrt((r*Astar-Astar^3)/FAstar);
plot(r, A/83.1,'blue-')
plot(r, B/100,'red-')

ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([0 rend])

xticks([0 Astar^2 10000 rend])
%yticks([0 2.5 5])
ylim([0 1.5])
xticklabels(["0" "$A_*^2$" "10000" "$r_*$"])
xlabel('$r$','FontSize', LabelFS)
text(4000,1.2,"$A/A_*$","FontSize", LabelFS, 'Color','blue')
text(8000,0.7,"$\epsilon B$","FontSize", LabelFS, 'Color','red')
text(200,1.7,"(a)","FontSize", LabelFS)

%%
subplot(1,3,2)
set(subplot(1,3,2), 'Position', [xstart+dif+width, ystart, width, height])
r = 2e4;
rS = rtorS(r);
plot(WNLData.G_2.eps_0_01.(rS).t, exp(WNLData.G_2.eps_0_01.(rS).theta)/83.1, 'Color', 'Blue'), hold on
plot(WNLData.G_2.eps_0_01.(rS).t, exp(WNLData.G_2.eps_0_01.(rS).phi)/100, 'Color', 'red')
xlim([0.008 0.01])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
text(0.00805,4.5,"(b) $r =  2 \times 10^4$","FontSize", LabelFS)
xlabel('$\tau_E$','FontSize', LabelFS)


%%
subplot(1,3,3)
set(subplot(1,3,3), 'Position', [xstart+(dif+width)*2, ystart, width, height])
r = 3e4;
rS = rtorS(r);
plot(WNLData.G_2.eps_0_01.(rS).t, exp(WNLData.G_2.eps_0_01.(rS).theta)/83.1, 'Color', 'Blue'), hold on
plot(WNLData.G_2.eps_0_01.(rS).t, exp(WNLData.G_2.eps_0_01.(rS).phi)/100, 'Color', 'red')
xlim([0.008 0.01])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$\tau_E$','FontSize', LabelFS)
text(0.00805,6.8,"(c) $r = 3 \times 10^4$","FontSize", LabelFS)

saveas(gcf,[figpath 'BifDiagWNL.eps'], 'epsc')

