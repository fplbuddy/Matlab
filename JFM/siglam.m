run SetUp.m
datapath = '/Volumes/Samsung_T5/OldData/WNLData.mat';
load(datapath)
%%

shift = 0.05;
shift2 = -0.04;
figure('Renderer', 'painters', 'Position', [5 5 500 250])
G  = 2;
Ktwo = (2*pi/G)^2 + pi^2;
a = (1/pi)*(4*G^3/(Ktwo^2*(4+G^2)^2))^(1/3);
b = a*(4+G^2)^2*pi^3/(2*G^3);
As = WNLData.(GS).As;
GS = GtoGS(G);
As = WNLData.(GS).As;
Fs = WNLData.(GS).Fs;
sigmas = WNLData.(GS).sigmas;
%
plt = subplot(2,1,1);
plot(As,sigmas*b,'b'), hold on
plot(-As,sigmas*b,'b')
plt.Position(3) = plt.Position(3) + shift;
plt.Position(2) = plt.Position(2) - shift2;
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylim([-10*b 5*b])
xlim([-100 100])
xticks([-100 -50 0 50 83.1 100])
xticklabels(['' '' '' '' '' '' '' ''])
ylabel('$\sigma$','FontSize', LabelFS)
plot([-100 83.1], [0 0], 'k--')
plot([83.1 83.1], [0 -10*b], 'k--')
text(35,-5*b, '$A_* = 83.1$','FontSize',LabelFS)
%
plt = subplot(2,1,2);
plot(As,Fs*b^2,'b'), hold on
plot(-As,-Fs*b^2,'b'), hold on
plt.Position(3) = plt.Position(3) + shift;
plt.Position(2) = plt.Position(2) - shift2+0.05;
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([-100 100])
xticks([-100 -50 0 50 83.1 100])
xlabel('$A$','FontSize', LabelFS)
ylab = ylabel('$\lambda$','FontSize', LabelFS);
ylab.Position(1);
ylab.Position(1) = ylab.Position(1) + 5;
plot([83.1 83.1], [-10*b^2 10*b^2], 'k--')
xticklabels(["-100" "-50" "0" "50" "$A_*$" "100" ])

saveas(gcf,[figpath 'siglam.eps'], 'epsc')
