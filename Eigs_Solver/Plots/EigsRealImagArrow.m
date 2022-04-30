clearvars -except AllData Data NewData
Pr = 100;
type = "ThreeOne";
PrS = PrtoPrS(Pr);
Ra_list = string(fieldnames(Data.(type).(PrS)));
Ra_list(Ra_list == 'cross') = [];
Ra_list = OrderRaS_list(Ra_list);
set(0,'DefaultFigureColormap',feval('winter'));
num = 2;

cmap = colormap(winter(num));
for i=2:length(Ra_list) % Note that thre is 2 here
    if i+num-1 <= length(Ra_list)
    figure('Renderer', 'painters', 'Position', [5 5 540 200])
    xlim([-10 30])
    ylim([-200 200])
    lgnd = legend('Location', 'Bestoutside'); title(lgnd,'$Ra$')
    xlabel('$Real(\sigma)$', 'FontSize', 14)
    ylabel('$Imag(\sigma)$', 'FontSize', 14)
    title(['$Pr = ' num2str(Pr) '$, $\hat \psi_{3,1}$ dominated even steady state'], 'FontSize', 15)
    hold on
    count = 1;
    for j=i:i+num-1
        RaS = Ra_list(j);
        Ra = RaStoRa(RaS);
        sigma = Data.(type).(PrS).(RaS).sigma;
        %plot(real(sigma), imag(sigma), '*', 'Color',cmap((length(Ra_list)-i+1),:),'DisplayName', num2str(Ra)), hold on
        [~, I] = max(real(sigma)); % Onlt looking at the maximum one
        sigma = sigma(I);
        if imag(sigma) < 0; sigma = conj(sigma); end
        plot(real(sigma), imag(sigma), '*', 'Color',cmap(j-i+1,:),'DisplayName', num2str(Ra)), hold on
        h1 = plot(real(sigma), -imag(sigma), '*', 'Color',cmap(j-i+1,:),'DisplayName', num2str(Ra)) % Conj
        set(get(get(h1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        %x = real(sigma); y = imag(sigma); z = Ra*ones(length(sigma),1);
        %scatter(x,y,10,z, 'filled', 'DisplayName', num2str(Ra)), %hold on
        if count ~= 1
            p21 = [real(sigma) imag(sigma)];
            [p21(1) p21(2)] = normalize_coordinate(p21(1), p21(2), get(gca, 'Position'), get(gca, 'xlim'), get(gca, 'ylim'), 0, 0);
            x = [p11(1) p21(1)];
            y = [p11(2) p21(2)];
            %quiver(p1(1),p1(2),dp(1),dp(2),'Color', 'b', 'MaxHeadSize', 1)
            annotation('arrow',x,y)
            p22 = [real(sigma) -imag(sigma)];
            [p22(1) p22(2)] = normalize_coordinate(p22(1), p22(2), get(gca, 'Position'), get(gca, 'xlim'), get(gca, 'ylim'), 0, 0);
            x = [p12(1) p22(1)];
            y = [p12(2) p22(2)];        
            annotation('arrow',x,y) % conj
        end
        p11 = [real(sigma) imag(sigma)];
        [p11(1) p11(2)] = normalize_coordinate(p11(1), p11(2), get(gca, 'Position'), get(gca, 'xlim'), get(gca, 'ylim'), 0, 0);
        p12 = [real(sigma) -imag(sigma)];
        [p12(1) p12(2)] = normalize_coordinate(p12(1), p12(2), get(gca, 'Position'), get(gca, 'xlim'), get(gca, 'ylim'), 0, 0);
        count = 1+count;
        %colorbar()
        lgnd = legend('Location', 'Bestoutside'); title(lgnd,'$Ra$')
    end
    pause
    %p = plot([0 0], [-400 400], 'black--' );
    %set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    
    hold off
    end
end

hold off

%% Function
% x_point = x value that you want to be normalized
% y_point = y value that corresponds to the x_point
% axes = axes of the current plot, usually found using get(gca, 'Position')
% xlims_ = x limits of the current plot, usually found using get(gca, 'xlim')
% ylims_ = y limits of the current plot, usually found using get(gca, 'ylim')
% xlog_bool = 1 (any nonzero, really) if the plot is semilogx or loglog, zero otherwise
% ylog_bool = 1 (any nonzero, really) if the plot is semilogy or loglog, zero otherwise
function [nx, ny] = normalize_coordinate(x_point_, y_point_, axes, xlims_, ylims_, xlog_bool, ylog_bool)
    if xlog_bool && ylog_bool, % loglog plots
        x_point = log(x_point_);
        y_point = log(y_point_);
        xlims = log(xlims_);
        ylims = log(ylims_);
    elseif xlog_bool, % semilogx plots
        x_point = log(x_point_);
        y_point = y_point_;
        xlims = log(xlims_);
        ylims = ylims_;    
    elseif ylog_bool, % semilogy plots
        x_point = x_point_;
        y_point = log(y_point_);
        xlims = xlims_;
        ylims = log(ylims_);
    else % plot plots
        x_point = x_point_;
        y_point = y_point_;
        xlims = xlims_;
        ylims = ylims_;
    end
    
    nx = ((x_point-xlims(1))/(xlims(2) - xlims(1)))*axes(3);
    ny = ((y_point-ylims(1))/(ylims(2) - ylims(1)))*axes(4);
    nx = axes(1) + nx;
    ny = axes(2) + ny;
end