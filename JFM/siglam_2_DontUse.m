run SetUp.m
datapath = '/Volumes/Samsung_T5/OldData/WNLData.mat';
load(datapath)
%%

shift = 0.05;
shift2 = 0;
figure('Renderer', 'painters', 'Position', [5 5 500 250])
G  = 2;
GS = GtoGS(G);
Ktwo = (2*pi/G)^2 + pi^2;
a = (1/pi)*(4*G^3/(Ktwo^2*(4+G^2)^2))^(1/3);
b = a*(4+G^2)^2*pi^3/(2*G^3);
As = WNLData.(GS).As;
Fs = WNLData.(GS).Fs*b^2;
GS = GtoGS(G);
As = WNLData.(GS).As;
Fs = WNLData.(GS).Fs;
sigmas = WNLData.(GS).sigmas*b;
%
plt = subplot(2,1,1);
plot(As,sigmas), hold on
plt.Position(3) = plt.Position(3) + shift;
plt.Position(2) = plt.Position(2) - shift2;
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylim([-10 5])
xlim([-100 100])
xticks([-100 -50 0 50 83.1 100])
xticklabels(['' '' '' '' '' '' '' ''])
ylabel('$\sigma$','FontSize', LabelFS)
plot([-100 83.1], [0 0], 'k--')
plot([83.1 83.1], [0 -10], 'k--')
text(35,-5, '$A_* = 83.1$','FontSize',LabelFS)
%
plt = subplot(2,1,2);
plot(As,Fs), hold on
plt.Position(3) = plt.Position(3) + shift;
plt.Position(2) = plt.Position(2) - shift2+0.05;
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([-100 100])
xticks([-100 -50 0 50 83.1 100])
xlabel('$A$','FontSize', LabelFS)
ylabel('$\lambda$','FontSize', LabelFS)
plot([83.1 83.1], [-10 10], 'k--')
xticklabels(["-100" "-50" "0" "50" "$A_*$" "100" ])

saveas(gcf,[figpath 'siglam.eps'], 'epsc')
