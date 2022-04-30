TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
%set(0,'defaultaxesfontsize',19,'defaultaxeslinewidth',.7, 'defaultlinelinewidth',.8,'defaultpatchlinewidth',.7, 'defaultlegendfontsize', 16)
TitleFS = 22;
LabelFS = 21;
lgndFS = 16;
numFS = 17;
MarkerS = 15;
%
Pr = 1e-3; PrS = PrtoPrSZero(Pr);
G_list = [0.2 0.3 0.36 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.21 2.22 2.23 2.24 2.25 2.26 2.27 2.28 2.29 2.3];
res = "N_64";
for i=1:length(G_list)
   G =  G_list(i); GS = GtoGS(G);
   % do odd first
   D = GetFullMZero(PrZeroData, GS,PrS, "Odd");
   [~,RaA] = GetNextRaA2(D,"Simple",3);
   odd(i) = RaA;
   % now do even
   D = GetFullMZero(PrZeroData, GS,PrS, "Even");
   [~,RaA] = GetNextRaA2(D,"Simple",3);
   even(i) = RaA;
end
figure('Renderer', 'painters', 'Position', [5 5 700 300])
semilogy(G_list,odd), hold on
plot(G_list,even)
xlabel("$\Gamma$", 'FontSize', LabelFS)
ylabel("$\delta Ra$", 'FontSize', LabelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
lgn = legend('Odd Instability','Even Instability)');
lgn.FontSize = LabelFS;
lgn.Location = 'northwest';
PrST = convertStringsToChars(PrS);
title(['$ Pr = ' PrST(4) '\times 10^{-' PrST(end) '}$'], 'FontSize', TitleFS)
