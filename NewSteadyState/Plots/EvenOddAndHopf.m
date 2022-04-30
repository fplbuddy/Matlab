labelFS = 18;
numFS = 18;
G_list = [2.36 2.37 2.38 2.35 2.3 2.2 2.1 0.39 0.38 0.37 0.36 0.35 0.34 0.33 0.32 0.31 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2];
type = "N_32x32";
cross_list = zeros(length(G_list),1);
Pr = 1e-4; PrS = PrtoPrS(Pr);
remZero = 1;
SearchType = "NonLinear";
prec = 3;
rem = [];
for i=1:length(G_list)
    G = G_list(i); GS = GtoGS(G);
    %RaC = pi^4*(4+G^2)^3/(4*G^4);
    M = GetFullMZeronss(Data,GS,PrS,remZero);
     try
    [~,RaA] = GetNextRaA2(M, SearchType,prec);
    cross_list(i) = RaA;
     catch
       rem = [rem i];
     end
        
end
G_list(rem) = [];
cross_list(rem) = [];
figure('Renderer', 'painters', 'Position', [5 5 700 300])
[G_list,I] = sort(G_list);
cross_list = cross_list(I);
semilogy(G_list, cross_list, '-o'), hold on
xlabel("$\Gamma$", 'FontSize',labelFS)
ylabel("$\delta$Ra = Ra - Ra$_c$", 'FontSize',labelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
%% Now do even and odd
load('/Volumes/Samsung_T5/OldData/PrZeroData.mat')
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
Pr = 1e-4; PrS = PrtoPrSZero(Pr);
G_list = [0.2 0.3 0.36 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2];
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
semilogy(G_list,odd,'-o'), hold on
plot(G_list,even,'-o')
xlabel("$\Gamma$", 'FontSize', LabelFS)
ylabel("$\delta Ra$", 'FontSize', LabelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
lgn = legend('Hopf','Odd Instability','Even Instability');
lgn.FontSize = LabelFS;
lgn.Location = 'northwest';
PrST = convertStringsToChars(PrS);
title(['$ Pr = ' PrST(4) '\times 10^{-' PrST(end) '}$'], 'FontSize', TitleFS)
