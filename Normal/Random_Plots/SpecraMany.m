run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Pr_list = [100 10 1 0.1];
Ra_list = [2e9 2e8 2e7 2e6];
cols = distinguishable_colors(length(Pr_list));
ARS = 'AR_2';
loc = 2;
fields = ["Ekspectrum" "Epspectrum"];
for i=1:length(Pr_list)
    Pr = Pr_list(i); Ra = Ra_list(i);
    PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
    path = convertStringsToChars(AllData.(ARS).(PrS).(RaS).path);
    xlower = AllData.(ARS).(PrS).(RaS).ICT;
    % get tcrit
    kenergy = importdata([path '/Checks/kenergy.txt']);
    t = kenergy(:,1); tcrit = t(xlower);
    % get the data
    SpecData = GetSpecGeneral(path,tcrit,fields,loc);
    Data.(PrS).(RaS).Ekspectrum = SpecData.Ekspectrum;
    Data.(PrS).(RaS).Epspectrum = SpecData.Epspectrum;
end
%% Make kenergy plot
figure()
for i=1:length(Pr_list)
    Pr = Pr_list(i); Ra = Ra_list(i);
    PrS = PrtoPrS(Pr); RaS = RatoRaS(Ra);
    Kresult = Data.(PrS).(RaS).Ekspectrum;
    col = cols(i,:);
    legent = RatoRaT(Pr);
    loglog(Kresult.*(1:length(Kresult))'.^2, '-o','DisplayName',['$' legent '$'], 'Color',col,'MarkerSize',10); hold on
end
%xlim([1 400])
ylim([1e-6 1])
xlabel('$k = \sqrt{k_x^2 + k_y^2}$', 'FontSize', labelFS)
lgnd = legend('Location', 'Bestoutside', 'FontSize', numFS);
title(lgnd,['$Pr$'], 'FontSize', labelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('(Compensated) KE Spec', 'FontSize', labelFS)
title('$\nu = \sqrt{\pi^3/(2\times10^7)}\approx 1.2 \times 10^{-3} $', 'FontSize', labelFS )
saveas(gcf,[figpath 'KESpec_FreeSlip'], 'epsc')