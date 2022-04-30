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
figure()
[G_list,I] = sort(G_list);
cross_list = cross_list(I);
semilogy(G_list, cross_list, '-o')
xlabel("$\Gamma$", 'FontSize',labelFS)
ylabel("$\delta$Ra = Ra - Ra$_c$", 'FontSize',labelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
title('Hopf, $Pr = 10^{-4}$','FontSize',labelFS)