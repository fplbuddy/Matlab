run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Ly = 0.25; Pr = 10; Ra = 9e6;
type = 'Shearing';
LyS = normaltoS(Ly,'Ly'); PrS = normaltoS(Pr,'Pr'); RaS = normaltoS(Ra,'Ra');
N = 256;
NS = ['N_' num2str(256) 'x' num2str(256)];
IC = ['IC_' type(1)];
path = AllData.(IC).(NS).(PrS).(RaS).(LyS).path;
spec1 = importdata([path '/Spectra/Epspec3d.0002.txt']);
spec2 = importdata([path '/Spectra/Epspec3d.0003.txt']);
%%
figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(spec1(:,1),spec1(:,2)), hold on
loglog(spec2(:,1),spec2(:,2))
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(spec1(:,2)./spec2(:,2)) % check if there is change between the two