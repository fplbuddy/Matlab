run SetUp.m
G = 1;
ARS = ['AR_' num2str(G)];
%% Pr constant
Pr = 1e2; 
Ra_list = [2e8 3e9];
Spectrum_list = ["Ekspectrum" "Epspectrum"];
power_list = [-5/3,-7/3,-11/3];

for i=1:length(Spectrum_list)
    Spectrum = convertStringsToChars(Spectrum_list(i));
    figure('Renderer', 'painters', 'Position', [5 5 600 300])
    RaT_list = [];
    for j=1:length(Ra_list)
        Ra = Ra_list(j);
        RaT = convertCharsToStrings(['$' RatoRaT(Ra) '$']);
        RaT_list = [RaT_list RaT];
        [shearing,~,~,~] = GetDataForSpectra(AllData,Pr,Ra, G,Spectrum);
        loglog(1:length(shearing),shearing); hold on
    end
    lgnd = legend(RaT_list,'Location', 'Best', 'FontSize', labelFS); title(lgnd,'$Ra$', 'FontSize', numFS)

    
    ax = gca;
    ax.XAxis.FontSize = numFS;
    ax.YAxis.FontSize = numFS;
    title(['$Pr = ' num2str(Pr) ',\, \Gamma = ' num2str(G) '$'],'FontSize', labelFS)
    if Spectrum(2) == 'p'
        ylabel('$|\widehat \theta_{k_x,k_y}|^2$','FontSize', labelFS)
    else
        ylabel('$|\nabla^2 \widehat \psi_{k_x,k_y}|^2$','FontSize', labelFS)
    end
    xlabel('$K = \sqrt{(k_x/L_x)^2+(k_y/L_y)^2}$','FontSize', labelFS)
    % plot power
    x1 = 10; y1 = max(shearing); x2 = 1e2;
    if Spectrum(2) == 'k'
        y1 = y1/100;
    end
    for j=1:length(power_list)
        power = power_list(j);
        A = y1*x1^(-power);
        y2 = A*x2^(power);
        plot([x1 x2],[y1 y2], 'k--','HandleVisibility','off')
    end
    
    saveas(gcf,[figpath Spectrum '_PrConst.eps'], 'epsc')
    
    
end

%% Ra constant
Ra = 1e7; RaT = RatoRaT(Ra); RaS = convertStringsToChars(RatoRaS(Ra));
Pr_list = [0.1 0.001];

for i=1:length(Spectrum_list)
    Spectrum = convertStringsToChars(Spectrum_list(i));
    figure('Renderer', 'painters', 'Position', [5 5 600 300])
    PrT_list = [];
    for j=1:length(Pr_list)
        Pr = Pr_list(j);
        PrT = convertCharsToStrings(['$' num2str(Pr) '$']);
        PrT_list = [PrT_list PrT];
        [shearing,~,~,~] = GetDataForSpectra(AllData,Pr,Ra, G,Spectrum);
        loglog(1:length(shearing),shearing); hold on
    end
    lgnd = legend(PrT_list,'Location', 'Best', 'FontSize', labelFS); title(lgnd,'$Pr$', 'FontSize', numFS)

    
    ax = gca;
    ax.XAxis.FontSize = numFS;
    ax.YAxis.FontSize = numFS;
    title(['$Ra = ' RaT ',\, \Gamma = ' num2str(G) '$'],'FontSize', labelFS)
    if Spectrum(2) == 'p'
        ylabel('$|\widehat \theta_{k_x,k_y}|^2$','FontSize', labelFS)
    else
        ylabel('$|\nabla^2 \widehat \psi_{k_x,k_y}|^2$','FontSize', labelFS)
    end
    xlabel('$K = \sqrt{(k_x/L_x)^2+(k_y/L_y)^2}$','FontSize', labelFS)
    % plot power
    x1 = 10; y1 = max(shearing); x2 = 1e2;
    if Spectrum(2) == 'k'
        y1 = y1/100;
    end
    for j=1:length(power_list)
        power = power_list(j);
        A = y1*x1^(-power);
        y2 = A*x2^(power);
        plot([x1 x2],[y1 y2], 'k--','HandleVisibility','off')
    end
    
    saveas(gcf,[figpath Spectrum '_' RaS '_Gamma_' num2str(G) '.eps'], 'epsc')
    
    
end
