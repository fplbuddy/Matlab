clearvars -except AllData
run SetUp.m

Ra = 1e7; RaS = RatoRaS(Ra); RaT = RatoRaT(Ra);
Pr_list = [1e-1 3e-2 1e-2 3e-3 1e-3];
G = 1; ARS = ['AR_' num2str(G)];
%% kinetic energy plot
for i=1:length(Pr_list)
    Pr = Pr_list(i); PrS = PrtoPrS(Pr);
    kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
    ICT = AllData.(ARS).(PrS).(RaS).ICT;
    t =  kenergy(:,1); energy = kenergy(:,2);
    t = t(ICT:end); energy = energy(ICT:end);
    energy_list(i) = MyMeanEasy(energy,t);
end
figure('Renderer', 'painters', 'Position', [5 5 600 200])
loglog(Pr_list,energy_list,'*', 'MarkerSize', 15)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$Pr$','FontSize',numFS);
ylabel('Average Kinetic Energy','FontSize',numFS);
title(['$ Ra = ' RatoRaT(Ra) '$, $\Gamma = ' num2str(G) '$'],'FontSize',labelFS)
saveas(gcf,[figpath 'KineticE_' convertStringsToChars(RaS) '_G_' num2str(G) '.eps'], 'epsc')


%% potential energy plot
for i=1:length(Pr_list)
    Pr = Pr_list(i); PrS = PrtoPrS(Pr);
    penergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/penergy.txt']);
    ICT = AllData.(ARS).(PrS).(RaS).ICT;
    t =  penergy(:,1); energy = penergy(:,2);
    t = t(ICT:end); energy = energy(ICT:end);
    energy_list(i) = MyMeanEasy(energy,t);
end
figure('Renderer', 'painters', 'Position', [5 5 600 200])
loglog(Pr_list,energy_list,'*', 'MarkerSize', 15)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$Pr$','FontSize',numFS);
ylabel('Average Potential Energy','FontSize',numFS);
title(['$ Ra = ' RatoRaT(Ra) '$, $\Gamma = ' num2str(G) '$'],'FontSize',labelFS)
saveas(gcf,[figpath 'PotentialE_' convertStringsToChars(RaS) '_G_' num2str(G) '.eps'], 'epsc')

