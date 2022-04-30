addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
clearvars -except AllData Data NewData
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
Pr = 6000;
type = "OneOne172";
AR = 'AR_2';
PrS = PrtoPrS(Pr);
Ra_list = string(fieldnames(Data.(AR).(type).(PrS)));
Ra_list(Ra_list == 'cross') = [];
Ra_list = OrderRaS_list(Ra_list);
Ra_list([1:6]) = [];
set(0,'DefaultFigureColormap',feval('winter'));
num = 3;
WhichSigma = 'sigmaoddbranch';
ms = 10;
FS = 18;

cmap = colormap(winter(num));
for i=1:length(Ra_list)
    figure('Renderer', 'painters', 'Position', [5 5 540 200]) 
    for j=i:i+num-1
        RaS = Ra_list(j);
        Ra = RaStoRa(RaS);
        sigma = Data.(AR).(type).(PrS).(RaS).(WhichSigma);
        plot(real(sigma), imag(sigma), '*', 'Color',cmap(j-i+1,:),'DisplayName', num2str(Ra),'MarkerSize',ms), hold on
        plot(real(sigma), -imag(sigma), '*', 'Color',cmap(j-i+1,:),'MarkerSize',ms, 'HandleVisibility','off')
        xlim([-60 60])
        lgnd = legend('Location', 'Bestoutside', 'FontSize', FS); title(lgnd,'$Ra$', 'FontSize', FS)
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