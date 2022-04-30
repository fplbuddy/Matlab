run SetUp.m
Nx = 32;
Ny = 32;
type  = ['N_' num2str(Nx) 'x' num2str(Ny)];
Pr = 1e-4;
G = 2;
GS = GtoGS(G);
if Pr < 1e-4
PrS = PrtoPrSZero(Pr);
else
    PrS = PrtoPrS(Pr);
end
RaAS_list = string(fieldnames(Data.(GS).(type).(PrS)));
RaAS_list = OrderRaAS_list(RaAS_list);
RaA_list = zeros(length(RaAS_list),1);
sigma_list = zeros(length(RaAS_list),1);
for i=1:length(RaA_list)
    RaAS = RaAS_list(i);
    RaA_list(i) = RaAStoRaA(RaAS);
    sigma = Data.(GS).(type).(PrS).(RaAS).sigma;
    sigma(imag(sigma)<1e-8) = [];
    sigma_list(i) = max(real(sigma));
end
figure('Renderer', 'painters', 'Position', [5 5 500 250])
plot(RaA_list,abs(sigma_list),'-o')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$\delta Ra$', 'FontSize', labelFS)
ylabel('$|\mathcal{R}(\sigma)|$', 'FontSize', labelFS)
PrT = RatoRaT(Pr);
title({'Stability of steady state with odd and even modes',['$\Gamma = ' num2str(G) '$, $Pr = ' PrT '$']}, 'FontSize', labelFS)