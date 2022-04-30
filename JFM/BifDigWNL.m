run SetUp.m
datapath = '/Volumes/Samsung_T5/OldData/WNLData.mat';
load(datapath)
%%
figure('Renderer', 'painters', 'Position', [5 5 550 500])
subplot(3,1,1)
G  = 2;
GS = GtoGS(G);
As = WNLData.(GS).As;
Fs = WNLData.(GS).Fs;
sigmas = WNLData.(GS).sigmas;
Astar = interp1(sigmas(round(length(As)/2):end),As(round(length(As)/2):end),0);
FAstar = interp1(As,Fs,Astar);
Fdash = diff(Fs)/mean(diff(As));
FdashAstar = interp1(As(2:end),Fdash,Astar);
rend = Astar^2 + 2*Astar^2*FAstar/(FAstar-Astar*FdashAstar);

% make first bit
r = 0:0.1:Astar^2;
B = zeros(1,length(r));
A = sqrt(r);
plot(r, A,'blue-'), hold on
plot(r, B,'red-')

% make second bit
r = Astar^2:0.1:rend;
A = ones(1,length(r))*Astar;
B = sqrt((r*Astar-Astar^3)/FAstar);
plot(r, A,'blue-')
plot(r, B,'red-')

ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([0 rend])

xticks([0 5000 Astar^2 10000 rend])
yticks([0 250 500])
xticklabels(["0" "5000" "$A_*^2$" "10000" "$r_*$"])
xlabel('$r$','FontSize', LabelFS)
text(5000,150,"$A$","FontSize", LabelFS, 'Color','blue')
text(7000,200,"$B$","FontSize", LabelFS, 'Color','red')
text(7,600,"(a)","FontSize", LabelFS)

%%
subplot(3,1,2)
r = 2e4;
rS = rtorS(r);
plot(WNLData.G_2.eps_0_01.(rS).t, exp(WNLData.G_2.eps_0_01.(rS).theta), 'Color', 'Blue'), hold on
plot(WNLData.G_2.eps_0_01.(rS).t, exp(WNLData.G_2.eps_0_01.(rS).phi), 'Color', 'red')
xlim([0.09 0.1])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
text(0.0901,1200,"(b), $r =  2 \times 10^4$","FontSize", LabelFS)


%%
subplot(3,1,3)
r = 3e4;
rS = rtorS(r);
plot(WNLData.G_2.eps_0_01.(rS).t, exp(WNLData.G_2.eps_0_01.(rS).theta), 'Color', 'Blue'), hold on
plot(WNLData.G_2.eps_0_01.(rS).t, exp(WNLData.G_2.eps_0_01.(rS).phi), 'Color', 'red')
xlim([0.09 0.1])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$\tau_2$','FontSize', LabelFS)
text(0.0901,1700,"(c), $r = 3 \times 10^4$","FontSize", LabelFS)

saveas(gcf,[figpath 'BifDiagWNL.eps'], 'epsc')

