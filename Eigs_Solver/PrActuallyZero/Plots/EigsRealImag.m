TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
%clearvars -except AllData Data NewData
type = "N_32x16";
ARS = 'G_2';
RaS = "Ra_8e2";
AmpS_list = string(fieldnames(PrAZero.(type).(ARS).(RaS)));
%Ra_list(1) = [];
set(0,'DefaultFigureColormap',feval('winter'));
num = 5;
WhichSigma = 'sigma';
ms = 20;
FS = 20;

cmap = colormap(winter(num));
for i=1:length(AmpS_list)
    figure('Renderer', 'painters', 'Position', [5 5 540 200])
    %subplot(1,2,1)
    for j=i:i+num-1
        AmpS = AmpS_list(j);
        Amp = PrAZero.(type).(ARS).(RaS).(AmpS).Amp;
        sigma = PrAZero.(type).(ARS).(RaS).(AmpS).(WhichSigma);
        %plot(real(sigma), imag(sigma), '*', 'Color',cmap((length(Ra_list)-i+1),:),'DisplayName', num2str(Ra)), hold on
        plot(real(sigma), imag(sigma), '*', 'Color',cmap(j-i+1,:),'DisplayName', num2str(Amp),'MarkerSize',ms), hold on
        %x = real(sigma); y = imag(sigma); z = Ra*ones(length(sigma),1);
        %scatter(x,y,10,z, 'filled', 'DisplayName', num2str(Ra)), %hold on
        xlim([-10 100])
        ylim([-1 1])
        %colorbar()
        lgnd = legend('Location', 'Bestoutside', 'FontSize', FS); title(lgnd,'$Amp$', 'FontSize', FS)
        title(['Ra $=' num2str(Ra) '$'], 'FontSize', FS)
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