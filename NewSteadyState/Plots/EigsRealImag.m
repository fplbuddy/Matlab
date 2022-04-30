TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/NewSteadyState/Functions/';
addpath(fpath)
addpath(fpath2)
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions')
Nx = 32;
Ny = 32;
type  = ['N_' num2str(Nx) 'x' num2str(Ny)];
Pr = 1e-5; PrT = RatoRaT(Pr);
G = 2;
GS = GtoGS(G);
PrS = PrtoPrS(Pr);
RaAS_list = string(fieldnames(Data.(GS).(type).(PrS)));
RaAS_list = OrderRaAS_list(RaAS_list);
set(0,'DefaultFigureColormap',feval('winter'));
num = 2;
WhichSigma = 'sigma';
ms = 20;
FS = 20;

cmap = colormap(winter(num));
for i=1:length(RaAS_list)
    figure('Renderer', 'painters', 'Position', [5 5 540 200])
    for j=i:i+num-1
        RaAS = RaAS_list(j);
        RaA = RaAStoRaA(RaAS);
        sigma = Data.(GS).(type).(PrS).(RaAS).(WhichSigma);
        plot(real(sigma), imag(sigma), '*', 'Color',cmap(j-i+1,:),'DisplayName', num2str(RaA),'MarkerSize',ms), hold on
        xlim([-1e-12 1e-12])
        %ylim([-1000 1000])
        lgnd = legend('Location', 'Bestoutside', 'FontSize', FS); title(lgnd,'$\delta$Ra', 'FontSize', FS)
        title(['Pr $=' PrT ', \Gamma =' num2str(G) '$'], 'FontSize', FS)
    end
    ax = gca;
    ax.XAxis.FontSize = FS;
    ax.YAxis.FontSize = FS;
    xlabel('$Real(\sigma)$', 'FontSize', FS)
    ylabel('$Imag(\sigma)$', 'FontSize', FS)
    pause
    
    hold off
end

hold off

