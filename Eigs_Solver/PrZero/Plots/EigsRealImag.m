fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
addpath(fpath)
addpath(fpath2)
N = 64;
res = ['N_' num2str(N)];
Pr = 2e-4;
PrS = PrtoPrSZero(Pr);
RaAS_list = string(fieldnames(PrZeroData.(res).(PrS)));
RaAS_list = OrderRaAS_list(RaAS_list);
set(0,'DefaultFigureColormap',feval('winter'));
num = 7;
WhichSigma = 'sigmaodd';
ms = 20;
FS = 20;

cmap = colormap(winter(num));
for i=1:length(RaAS_list)
    figure('Renderer', 'painters', 'Position', [5 5 540 200])
    for j=i:i+num-1
        RaAS = RaAS_list(j);
        RaA = RaAStoRaA(RaAS);
        sigma = PrZeroData.(res).(PrS).(RaAS).(WhichSigma);
        plot(real(sigma), imag(sigma), '*', 'Color',cmap(j-i+1,:),'DisplayName', num2str(RaA),'MarkerSize',ms), hold on
        xlim([-5e-5 5e-5])
        %ylim([-1000 1000])
        lgnd = legend('Location', 'Bestoutside', 'FontSize', FS); title(lgnd,'$RaA$', 'FontSize', FS)
        title(['Pr $=' num2str(Pr) '$'], 'FontSize', FS)
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

