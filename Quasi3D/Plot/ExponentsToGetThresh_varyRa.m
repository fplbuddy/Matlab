run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Ly = 0.25; Pr = 30; type = 'Shearing';
LyS = normaltoS(Ly,'Ly',1); PrS = normaltoS(Pr,'Pr',1); IC = ['IC_' type(1)];
Nx = 1024; Ny = 512
NS = ['N_' num2str(256) 'x' num2str(256)];
Ra_list = [1e7 1.1e7 1.2e7 1.3e7 1.6e7 2e7];
exponent = zeros(length(Ra_list),1);
for i=1:length(Ra_list)
    Ra = Ra_list(i);
    RaS = normaltoS(Ra,'Ra',1);
    path = AllData.(IC).(NS).(PrS).(RaS).(LyS).path;
    kenergy2 = importdata([path '/Checks/kenergy2.txt']);
    t = kenergy2(:,1); s = kenergy2(:,2);
    if isfield(AllData.(IC).(NS).(PrS).(RaS).(LyS),'trans')
        trans = AllData.(IC).(NS).(PrS).(RaS).(LyS).trans;
    else
        trans = 1;
    end
    if isfield(AllData.(IC).(NS).(PrS).(RaS).(LyS),'top')
        top = AllData.(IC).(NS).(PrS).(RaS).(LyS).top;
        t = t(trans:top); s = s(trans:top);
    else
        t = t(trans:end); s = s(trans:end);
    end
    [alpha, ~, xFitted, yFitted, ~] = Fitslogy(t,s);
    exponent(i) = alpha;
end
mdl = fitlm(Ra_list, exponent);
A = mdl.Coefficients.Estimate(1);
alpha = mdl.Coefficients.Estimate(2);

figure()
semilogx(Ra_list,exponent,'.','MarkerSize',MS*3)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('Exponent','FontSize',labelFS)
xlabel('$Ra$','FontSize',labelFS)
LyT = RatoRaT(Ly); PrT = RatoRaT(Pr);
title(['$\Gamma_y=' LyT ',\, Pr = ' PrT '$, ' type], 'FontSize',labelFS)
LyS = convertStringsToChars(LyS); PrS = convertStringsToChars(PrS);  RaS = convertStringsToChars(RaS);
%saveas(gcf,[figpath 'exponent_' LyS  '_' PrS '_' type], 'epsc')