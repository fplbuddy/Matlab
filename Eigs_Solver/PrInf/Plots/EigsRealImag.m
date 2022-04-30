addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
%clearvars -except AllData Data NewData
type = "N_624x208";
AR = 'AR_3';
Ra_list = string(fieldnames(PrInfData.(AR).(type)));
Ra_list(Ra_list == 'cross') = [];
Ra_list = OrderRaS_list(Ra_list);
%Ra_list(1) = [];
set(0,'DefaultFigureColormap',feval('winter'));
num = 5;
WhichSigma = 'sigmaodd';
ms = 20;
FS = 20;

cmap = colormap(winter(num));
for i=1:length(Ra_list)
    figure('Renderer', 'painters', 'Position', [5 5 540 200])
    %subplot(1,2,1)
    for j=i:i+num-1
        RaS = Ra_list(j);
        Ra = RaStoRa(RaS);
        try
        sigma = PrInfData.(AR).(type).(RaS).(WhichSigma);
        %plot(real(sigma), imag(sigma), '*', 'Color',cmap((length(Ra_list)-i+1),:),'DisplayName', num2str(Ra)), hold on
        plot(real(sigma), imag(sigma), '*', 'Color',cmap(j-i+1,:),'DisplayName', num2str(Ra),'MarkerSize',ms), hold on
        %x = real(sigma); y = imag(sigma); z = Ra*ones(length(sigma),1);
        %scatter(x,y,10,z, 'filled', 'DisplayName', num2str(Ra)), %hold on
        xlim([-50 1])
        %ylim([-200 200])
        %colorbar()
        catch
        end
        lgnd = legend('Location', 'Bestoutside', 'FontSize', FS); title(lgnd,'$Ra$', 'FontSize', FS)
    end
    %p = plot([0 0], [-], 'black--' );
    %set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    ax = gca;
    ax.XAxis.FontSize = FS;
    ax.YAxis.FontSize = FS;
    xlabel('$Real(\sigma)$', 'FontSize', FS)
    ylabel('$Imag(\sigma)$', 'FontSize', FS)
    pause
    
    hold off
end

hold off

%%
for i=1:length(Ra_list)
    RaS = Ra_list(i);
    sigma = Data.Pr_30.(RaS).sigma;
    hej(i) = max(real(sigma));
end