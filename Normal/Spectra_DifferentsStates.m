run ./Random_Plots/SetUp.m
Pr = 30; PrS = PrtoPrS(Pr);
Ra = 1e9; RaS = RatoRaS(Ra); RaT = RatoRaT(Ra);
G = 2;
thresh = 0.95;
ARS = ['AR_' num2str(G)];
Spectrum = 'Ekspectrum';

[shearing,nonshearing,numshearing,numnonshearing] = GetDataForSpectra(AllData,Pr,Ra, G,Spectrum);
%% Get powerlaw
Res = AllData.(ARS).(PrS).(RaS).Res;
[Nx,~] = nxny(Res);
if numnonshearing > 0
    [powernonshearing,~] = GetPLFromSpectra(nonshearing,Spectrum,Nx,thresh);
end
if numshearing > 0
    [powershearing,Rval] = GetPLFromSpectra(shearing,Spectrum,Nx,thresh);
end



%% make plots
figure('Renderer', 'painters', 'Position', [5 5 600 300])
loglog(1:length(shearing),shearing,'r-'); hold on
loglog(1:length(shearing),nonshearing,'b-')
if numnonshearing > 0
    x1 = Nx/16; y1 = nonshearing(x1); A = y1*x1^(-powernonshearing);
    x2 = Nx/4; y2 = A*x2^(powernonshearing);
    plot([x1 x2],[y1 y2], 'k--')
end
if numshearing > 0
     x1 = Nx/16; y1 = shearing(x1); A = y1*x1^(-powershearing);
    x2 = Nx/4; y2 = A*x2^(powershearing);
    plot([x1 x2],[y1 y2], 'k--')
end

ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;

lgnd = legend({'Shearing', 'Non-Shearing'},'Location', 'Best', 'FontSize', labelFS);
title(['$Ra =' RaT ',\, Pr = ' num2str(Pr) ',\, \Gamma = ' num2str(G) '$'],'FontSize', labelFS)
xlabel('$K = \sqrt{(k_x/L_x)^2+(k_y/L_y)^2}$','FontSize', labelFS)
if Spectrum(2) == 'p'
    ylabel('$|\widehat \theta_{k_x,k_y}|^2$','FontSize', labelFS)
else
    ylabel('$|\nabla^2 \widehat \psi_{k_x,k_y}|^2$','FontSize', labelFS)
end

saveas(gcf,[figpath Spectrum '_' convertStringsToChars(RaS) '_' PrS '.eps'], 'epsc')


