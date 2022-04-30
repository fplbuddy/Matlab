clearvars -except AllData
run SetUp.m

Ra = 1e8; RaS = RatoRaS(Ra); RaT = RatoRaT(Ra);
Pr_list = [1e-1 3e-2 1e-2 1e-3];
%Pr_list = [1e-3];
G = 1; ARS = ['AR_' num2str(G)];
for i=1:length(Pr_list)
    %% find which one has the smallest time
    tmin = 1e15;
    Pr = Pr_list(i);
    PrS = PrtoPrS(Pr);
    PrT = RatoRaT(Pr);
    kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
    ICT = AllData.(ARS).(PrS).(RaS).ICT;
    t = kenergy(:,1);
    t = t(ICT:end);
    tmin = min([tmin t(end)-t(1)]);
    %% Make even kinetic energy plot
    figure('Renderer', 'painters', 'Position', [5 5 600 200])
    kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
    ICT = AllData.(ARS).(PrS).(RaS).ICT;
    t = kenergy(:,1); Energy = kenergy(:,5);
    % find which position we wanna go from
    tcheck = abs(t - t(end) + tmin); [~,ICT] = min(tcheck);
    t = t(ICT:end); t = t - t(1);
    Energy = Energy(ICT:end);
    plot(t,Energy,'DisplayName',['$' PrT '$']), hold on
    xlim([0 tmin])
    ax = gca;
    ax.XAxis.FontSize = numFS;
    ax.YAxis.FontSize = numFS;
    xlabel('$t$ $(s)$','FontSize',numFS);
    ylabel('Even Kinetic Energy','FontSize',numFS);
    title(['$ Ra = ' RatoRaT(Ra) '$, $Pr = ' PrT '$, $\Gamma = ' num2str(G) '$'],'FontSize',labelFS)
    saveas(gcf,[figpath 'EvenKineticE_' convertStringsToChars(RaS) '_' PrS '_G_' num2str(G) '.eps'], 'epsc')
    
    %% Make odd kinetic energy plot
    figure('Renderer', 'painters', 'Position', [5 5 600 200])
    
    kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
    ICT = AllData.(ARS).(PrS).(RaS).ICT;
    t = kenergy(:,1); Energy = kenergy(:,6);
    % find which position we wanna go from
    tcheck = abs(t - t(end) + tmin); [~,ICT] = min(tcheck);
    t = t(ICT:end); t = t - t(1);
    Energy = Energy(ICT:end);
    plot(t,Energy,'DisplayName',['$' PrT '$']), hold on
    xlim([0 tmin])
    ax = gca;
    ax.XAxis.FontSize = numFS;
    ax.YAxis.FontSize = numFS;
    xlabel('$t$ $(s)$','FontSize',numFS);
    ylabel('Odd Kinetic Energy','FontSize',numFS);
    title(['$ Ra = ' RatoRaT(Ra) '$, $Pr =' PrT '$, $\Gamma = ' num2str(G) '$'],'FontSize',labelFS)
    saveas(gcf,[figpath 'OddKineticE_' convertStringsToChars(RaS) '_' PrS '_G_' num2str(G) '.eps'], 'epsc')
    
    %% Make even potential energy plot
    figure('Renderer', 'painters', 'Position', [5 5 600 200])
    
    penergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/penergy.txt']);
    ICT = AllData.(ARS).(PrS).(RaS).ICT;
    t = penergy(:,1); Energy = penergy(:,4);
    % find which position we wanna go from
    tcheck = abs(t - t(end) + tmin); [~,ICT] = min(tcheck);
    t = t(ICT:end); t = t - t(1);
    Energy = Energy(ICT:end);
    plot(t,Energy,'DisplayName',['$' PrT '$']), hold on
    xlim([0 tmin])
    ax = gca;
    ax.XAxis.FontSize = numFS;
    ax.YAxis.FontSize = numFS;
    xlabel('$t$ $(s)$','FontSize',numFS);
    ylabel('Even Potential Energy','FontSize',numFS);
    title(['$ Ra = ' RatoRaT(Ra) '$, $Pr =' PrT '$, $\Gamma = ' num2str(G) '$'],'FontSize',labelFS)
    saveas(gcf,[figpath 'EvenPotentialE_' convertStringsToChars(RaS) '_' PrS '_G_' num2str(G) '.eps'], 'epsc')
    
    %% Make odd potential energy plot
    figure('Renderer', 'painters', 'Position', [5 5 600 200])
    penergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/penergy.txt']);
    ICT = AllData.(ARS).(PrS).(RaS).ICT;
    t = penergy(:,1); Energy = penergy(:,5);
    % find which position we wanna go from
    tcheck = abs(t - t(end) + tmin); [~,ICT] = min(tcheck);
    t = t(ICT:end); t = t - t(1);
    Energy = Energy(ICT:end);
    plot(t,Energy,'DisplayName',['$' PrT '$']), hold on
    xlim([0 tmin])
    ax = gca;
    ax.XAxis.FontSize = numFS;
    ax.YAxis.FontSize = numFS;
    xlabel('$t$ $(s)$','FontSize',numFS);
    ylabel('Odd Potental Energy','FontSize',numFS);
    title(['$ Ra = ' RatoRaT(Ra) '$, $Pr =' PrT '$, $\Gamma = ' num2str(G) '$'],'FontSize',labelFS)
    saveas(gcf,[figpath 'OddPotentialE_' convertStringsToChars(RaS) '_' PrS '_G_' num2str(G) '.eps'], 'epsc')
end

