clearvars -except AllData Data NewData
Ra = 4e4;
RaS = RatoRaS(Ra);
Pr_list = 1:10;
set(0,'DefaultFigureColormap',feval('winter'));
num = 10;
hold on
figure('Renderer', 'painters', 'Position', [5 5 540 200])
cmap = colormap(winter(num));
for i=1:length(Pr_list)
    Pr = Pr_list(i);
    PrS = PrtoPrS(Pr);
    sigma = Data.(PrS).(RaS).sigma;
    %plot(real(sigma), imag(sigma), '*', 'Color',cmap((length(Ra_list)-i+1),:),'DisplayName', num2str(Ra)), hold on
    plot(real(sigma), imag(sigma), '*', 'Color',cmap(i,:),'DisplayName', num2str(Pr)), hold on
    x = real(sigma); y = imag(sigma); z = Ra*ones(length(sigma),1);
    %scatter(x,y,10,z, 'filled', 'DisplayName', num2str(Ra)), %hold on
    xlim([-50 20])
    %ylim([-1 1])
    %colorbar()
    lgnd = legend('Location', 'Bestoutside'); title(lgnd,'$Pr$')
    %p = plot([0 0], [-400 400], 'black--' );
    %set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    xlabel('$Real(\sigma)$', 'FontSize', 14)
    ylabel('$Imag(\sigma)$', 'FontSize', 14)
    
end

hold off

%%