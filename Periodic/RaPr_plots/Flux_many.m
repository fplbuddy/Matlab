o1 = 8; o2 = 1;
f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
n_list = [512 512 512 512];
Pr_list = [1e-2 1e-1 1 1e1];
Ra_list = [7e91 7e91 7e91 7e91];
figure('Renderer', 'painters', 'Position', [5 5 540 300])
cols = [0 0 0;
        255 0 0;
        0 255 0;
        0 0 255;
        255 0 255]/255;


for i=1:length(Pr_list)
    Pr = Pr_list(i); Ra = Ra_list(i); n = n_list(i);
    PrS =normaltoS(Pr, 'Pr',1); RaS =normaltoS(Ra, 'Ra',1); ns = ['n_' num2str(n)];
    path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(PrS).(RaS).path;
    kenergy = importdata([path '/Checks/kenergy.txt']);
    trans = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(PrS).(RaS).trans;
    t = kenergy(:,1); tcrit = t(trans); t = t(trans:end);
    [Kresult,Presult] = GetFluxes(path,tcrit);
    fenk =  kenergy(:,4); % injection
    fav = MyMeanEasy(fenk(trans:end),t);
    Data.(PrS).Kresult = Kresult;
    Data.(PrS).Presult = Presult;
    Data.(PrS).fav = fav;
end


%% make kinetic Energy
for i=1:length(Pr_list)
    Pr = Pr_list(i);  PrS =normaltoS(Pr, 'Pr',1); PrT = RatoRaT(Pr);
    Kresult = Data.(PrS).Kresult;
    fav = Data.(PrS).fav;
    col = cols(i,:);
    semilogx(Kresult/fav, '-o','DisplayName',['$' PrT '$'], 'Color',col); hold on
end
xlim([1 200])
xlabel('$k = \sqrt{k_x^2 + k_y^2}$', 'FontSize', labelFS)
lgnd = legend('Location', 'Bestoutside', 'FontSize', numFS);
title(lgnd,'$Pr$', 'FontSize', labelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$\Pi_k/<\psi_x \theta>$', 'FontSize', labelFS)
saveas(gcf,[figpath 'KineticFlux_Many' ], 'epsc')


%% make pinetic Energy
figure('Renderer', 'painters', 'Position', [5 5 540 300])
for i=1:length(Pr_list)
    Pr = Pr_list(i);  PrS =normaltoS(Pr, 'Pr',1); PrT = RatoRaT(Pr);
    Presult = Data.(PrS).Presult;
    fav = Data.(PrS).fav;
    col = cols(i,:);
    semilogx(2*pi*Presult/fav, '-o','DisplayName',['$' PrT '$'], 'Color',col); hold on
end
xlim([1 200])
xlabel('$k = \sqrt{k_x^2 + k_y^2}$', 'FontSize', labelFS)
lgnd = legend('Location', 'Bestoutside', 'FontSize', numFS);
title(lgnd,'$Pr$', 'FontSize', labelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$2\pi\Pi_p/\Delta T<\psi_x \theta>$', 'FontSize', labelFS)
saveas(gcf,[figpath 'PotentialFlux_Many' ], 'epsc')




