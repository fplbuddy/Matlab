run SetUp.m
load('/Volumes/Samsung_T5/OldData/masternew.mat')
figure('Renderer', 'painters', 'Position', [5 5 800 300])
Pr = 30;
type = "OneOne64";
AR = 'AR_2';
PrS = PrtoPrS(Pr);

Ra_list = ["Ra_4_77e4" "Ra_4_76e4" "Ra_4_75e4" "Ra_4_74e4" "Ra_4_73e4"];
Ra_list = OrderRaS_list(Ra_list);
set(0,'DefaultFigureColormap',feval('jet'));
num = 5;
WhichSigma = 'sigmaodd';
ms = 18;
cmap = colormap(cool(num));
sp = subplot(2,2,[1 3]);
for i=1:length(Ra_list)
    RaS = Ra_list(i);
    Ra = RaStoRa(RaS);
    sigma = Data.(AR).(type).(PrS).(RaS).(WhichSigma);
    plot(real(sigma), imag(sigma), '*', 'Color',cmap(i,:),'DisplayName', num2str(Ra),'MarkerSize',ms), hold on
end
lgnd = legend('Location', 'west', 'FontSize', numFS); title(lgnd,'Ra', 'FontSize', numFS)
xlabel('$\mathcal{R}(\sigma)$', 'FontSize', LabelFS)
ylabel('$\mathcal{I}(\sigma)$', 'FontSize', LabelFS)
xlim([-0.3 0.1])
ylim([-250 250])
plot([-0.3 0.2], [0 0], 'black--', 'HandleVisibility','off');
plot([0 0], [-400 400], 'black--', 'HandleVisibility','off');
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xticks([-0.3 -0.2 -0.1 0 0.1 0.2])
hold off
tit = title('(a)', 'FontSize', TitleFS);
text(-0.15,50,'Pr $= 30$', 'FontSize', LabelFS)
shrink = 0.05;
sp.Position(2) = sp.Position(2) + 0.086;
sp.Position(4) = sp.Position(4) - 0.11;
%
%
Ra = 4.77e4;
RaS = RatoRaS(Ra);
stretch = 0.001;
kpsmodes1 = importdata([convertStringsToChars(AllData.(AR).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
t1 = kpsmodes1(:,1);
Signal1 = kpsmodes1(:,2);
xlower = AllData.(AR).(PrS).(RaS).ICT;
% Calculating urms and kappa
kappa = AllData.(AR).(PrS).(RaS).kappa;

% non-dim stuff
Signal1 = Signal1*2/kappa;
t1 = t1/(pi^2/kappa);
sp = subplot(2,2,2);
plot(t1,Signal1,'Color',cmap(5,:))
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([41 41.3])
%xticklabels({'' '' ''});
ylab = ylabel('$\widehat \psi_{0,1}/\kappa$', 'Fontsize', LabelFS);
ylab.Position(1) = ylab.Position(1)-0.007;
xlabel('$t/((\pi d)^2/\kappa)$', 'Fontsize', LabelFS)
tit = title('Ra $=4.77 \times 10^4$, (b)', 'FontSize', TitleFS);
%
% Fourier transform
%
sp = subplot(2,2,4);
L = length(Signal1);
tdiff = diff(t1);
T = mean(tdiff);
Fs = 1/T;
Y = fft(Signal1);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
semilogy(f, P1, '-o','Color',cmap(5,:));
xlim([31.87-0.5 31.87+0.5])
%sgtitle(join(['$' AllData.(ARS).(PrS).(RaS).title '$'],""), 'FontSize', 15);
%xlabel('Frequency (Hz)', 'FontSize', 14)
xlabel('$f/(\kappa/(\pi d)^2)$', 'FontSize', LabelFS)
ylabel('FFT($\widehat \psi_{0,1}$)', 'FontSize', LabelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;