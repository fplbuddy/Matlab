addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
Pr = 8;
type = "OneOne172";
AR = 'AR_2';
PrS = PrtoPrS(Pr);
Ra_list = string(fieldnames(NewData.(AR).(type).(PrS)));
Ra_list(Ra_list == 'cross') = [];
Ra_list = OrderRaS_list(Ra_list);
Ra_list([1:6]) = [];
set(0,'DefaultFigureColormap',feval('winter'));
num = 9;
WhichSigma = 'sigmaoddbranch';
ms = 20;
FS = 25;

cmap = colormap(winter(num));
for i=1:length(Ra_list)
    figure('Renderer', 'painters', 'Position', [5 5 540 200]) 
    for j=i:i+num-1
        RaS = Ra_list(j);
        Ra = RaStoRa(RaS);
        sigma = NewData.(AR).(type).(PrS).(RaS).(WhichSigma);
        plot(real(sigma), imag(sigma), '*', 'Color',cmap(j-i+1,:),'DisplayName', num2str(Ra),'MarkerSize',ms), hold on
        plot(real(sigma), -imag(sigma), '*', 'Color',cmap(j-i+1,:),'MarkerSize',ms, 'HandleVisibility','off')
        xlim([-4 5.1])
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