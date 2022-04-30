run SetUp.m
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);
%%
figure('Renderer', 'painters', 'Position', [5 5 550 200])
Pr = 0.2;
PrS = PrtoPrS(Pr);
RaS_list = string(fields((Data.AR_2.OneOne152.(PrS))));
[RaS_list, ~] = OrderRaS_list(RaS_list);
Is = find(RaS_list == "Ra_3_32e5");
Ie = find(RaS_list == "Ra_3_38e5");
RaS_list = RaS_list(Is:Ie);
sig_list = [];
Ra_list = [];
for i=1:length(RaS_list)
    RaS = RaS_list(i);
    Ra = RaStoRa(RaS);
    Ra_list = [Ra_list Ra];
    sigs = Data.AR_2.OneOne152.(PrS).(RaS).sigmaodd;
    [~,I] = max(real(sigs));
    sig_list = [sig_list sigs(I)];  
end

% add anchor
loc = find(abs(imag(sig_list)) > 1e-5, 1 );
sig_list = [sig_list(1:loc-1) real(sig_list(loc)) sig_list(loc:end)];
plt = plot(real(sig_list), abs(imag(sig_list)), 'k'); hold on
sig_list2 = sig_list(loc:end);
plot(real(sig_list2), -abs(imag(sig_list2)), 'k')
% zero line
plot([0 0], [-0.4 0.4], '--k')

%arrows
arrow([0.2 0],[0.1 0], 'length', 10)
s = 7;
arrow([real(sig_list2(s)) abs(imag(sig_list2(s)))],[real(sig_list2(s+1)) abs(imag(sig_list2(s+1)))], 'length', 10)
arrow([real(sig_list2(s)) -abs(imag(sig_list2(s)))],[real(sig_list2(s+1)) -abs(imag(sig_list2(s+1)))], 'length', 10)


% starts
Ra_list = [3.32e5 3.32859e5 3.33e5 3.35e5];
names = ["$3.32 \times 10^5$" "$3.32859 \times 10^5$" "$3.33 \times 10^5$" "$3.35 \times 10^5$"];
cmap = colormap(winter(length(Ra_list)));
for i=1:length(Ra_list)
   Ra =  Ra_list(i);
   RaS = RatoRaS(Ra);
   sigs = Data.AR_2.OneOne152.(PrS).(RaS).sigmaodd;
   [~,I] = max(real(sigs));
   sigplot = sigs(I);
   if abs(imag(sigplot)) > 0.001
       sigplot = [sigplot conj(sigplot)];
   end
   h(i) = plot(real(sigplot), imag(sigplot), '*', 'Color',cmap(i,:),'DisplayName', names(i),'MarkerSize',MarkerS); hold on
end
lgnd = legend(h(1:length(Ra_list)),'Location', 'Bestoutside', 'FontSize', numFS); title(lgnd,'$Ra$', 'FontSize', numFS)

ylim([-0.4 0.4])
xlim([-0.05 0.2])
xticks([-0.05 0 0.05 0.1 0.15 0.2])
yticks([-0.4 -0.2 0 0.2 0.4])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ydel = 0.2;
xdel = 0.22;
ax.Position(2) = ax.Position(2) + ydel;
ax.Position(4) = ax.Position(4) - ydel;
ax.Position(3) = ax.Position(3) - xdel;
ylabel('$\mathcal{I}(\sigma^o)$','FontSize', LabelFS);
xlabel('$\mathcal{R}(\sigma^o)$','FontSize', LabelFS);

saveas(gcf,[figpath 'Track.eps'], 'epsc')
