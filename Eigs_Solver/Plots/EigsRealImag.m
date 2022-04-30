addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
%clearvars -except AllData Data NewData
Pr = 8.58;
type = "OneOne256";
AR = 'AR_2';
PrS = PrtoPrS(Pr);
Ra_list = string(fieldnames(Data.(AR).(type).(PrS)));
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
        sigma = Data.(AR).(type).(PrS).(RaS).(WhichSigma);
        %plot(real(sigma), imag(sigma), '*', 'Color',cmap((length(Ra_list)-i+1),:),'DisplayName', num2str(Ra)), hold on
        plot(real(sigma), imag(sigma), '*', 'Color',cmap(j-i+1,:),'DisplayName', num2str(Ra),'MarkerSize',ms), hold on
        %x = real(sigma); y = imag(sigma); z = Ra*ones(length(sigma),1);
        %scatter(x,y,10,z, 'filled', 'DisplayName', num2str(Ra)), %hold on
        xlim([-10 10])
        %ylim([-1 1])
        %colorbar()
        lgnd = legend('Location', 'Bestoutside', 'FontSize', FS); title(lgnd,'$Ra$', 'FontSize', FS)
        title(['Pr $=' num2str(Pr) '$'], 'FontSize', FS)
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