run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Ly = 0.5; Pr = 30; Ra = 4e6;
LyS = normaltoS(Ly,'Ly'); PrS = normaltoS(Pr,'Pr'); RaS = normaltoS(Ra,'Ra');
N = 256;
nx = 256;
ny = 256;
nmpi = 8;
NS = ['N_' num2str(nx) 'x' num2str(ny)];
type = 'NonShearing';
IC = ['IC_' type(1)];
num = 2;
field = 'theta2';
path = AllData.(IC).(NS).(PrS).(RaS).(LyS).path;
pathF = [path  '/Fields/'];
Times = importdata([pathF 'field_times.txt']);
ListTimes = Times(:,2);
Time = num2str(round(ListTimes(num))); % Time of plot
num = num2str(num);
while length(num) < 4
    num = ['0' num];
end
files = dir([pathF,'hd2D',field,'.*.',num,'.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([pathF,files(i).name],'r');
    fread(fid,1,'real*4');
    ff(:,i) = fread(fid,inf,'real*8');
    fclose(fid);
end
ff = reshape(ff,nx,ny);
figure
fieldcheck = ff';
pcolor(ff');
shading flat
colormap('jet')
c = colorbar;
c.FontSize = numFS;
caxis([-max(max(abs(ff))) max(max(abs(ff)))])
xlabel('$x$', 'FontSize', labelFS)
ylabel('$y$', 'FontSize', labelFS)
xticks([1 nx])
xticklabels({'$0$' '$2\pi$'})
yticks([1 ny])
yticklabels({'$0$' '$\pi$'})
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;

LyT = RatoRaT(Ly); RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
title({['$\Gamma_y=' LyT ',\, Ra = ' RaT ',\, Pr = ' PrT '$, ' type ],['$ t=' Time '$']}, 'FontSize',labelFS)
while num(1) == '0'
    num = num(2:length(num));
end  
RaS = convertStringsToChars(RaS);
PrS = convertStringsToChars(PrS);
LyS = convertStringsToChars(LyS);
%saveas(gcf,[figpath field '_' num '_' RaS  '_' PrS '_' LyS '_' type], 'epsc')