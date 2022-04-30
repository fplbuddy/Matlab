o1 = 8; o2 = 1;
f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
n_list = [512 512 512 512];
Pr_list = [1e-2 1e-1 1 1e1];
Ra_list = [7e91 7e91 7e91 7e91];
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
    [Kresult,Presult] = GetSpec(path,tcrit);
    Data.(PrS).Kresult = Kresult;
    Data.(PrS).Presult = Presult;
end

%% make kinetic Energy
for i=1:length(Pr_list)
    Pr = Pr_list(i);  PrS =normaltoS(Pr, 'Pr',1); PrT = RatoRaT(Pr);
    Kresult = Data.(PrS).Kresult;
    col = cols(i,:);
    loglog(Kresult, '-o','DisplayName',['$' PrT '$'], 'Color',col); hold on
end
xlim([1 200])
xlabel('$k = \sqrt{k_x^2 + k_y^2}$', 'FontSize', labelFS)
lgnd = legend('Location', 'Bestoutside', 'FontSize', numFS);
title(lgnd,'$Pr$', 'FontSize', labelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('Kinetic Energy Spectrum', 'FontSize', labelFS)
saveas(gcf,[figpath 'KineticSpec_Many_Pr' ], 'epsc')
close all

%% make potential Energy
for i=1:length(Pr_list)
    Pr = Pr_list(i);  PrS =normaltoS(Pr, 'Pr',1); PrT = RatoRaT(Pr);
    Presult = Data.(PrS).Presult;
    col = cols(i,:);
    loglog(Presult, '-o','DisplayName',['$' PrT '$'], 'Color',col); hold on
end
xlim([1 200])
xlabel('$k = \sqrt{k_x^2 + k_y^2}$', 'FontSize', labelFS)
lgnd = legend('Location', 'Bestoutside', 'FontSize', numFS);
title(lgnd,'$Pr$', 'FontSize', labelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('Potential Energy Spectrum', 'FontSize', labelFS)
saveas(gcf,[figpath 'PotentialSpec_Many_Pr' ], 'epsc')








