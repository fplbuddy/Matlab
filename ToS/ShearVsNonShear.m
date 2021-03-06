figure('Renderer', 'painters', 'Position', [5 5 600 400])
run SetUp.m

ymove = 0.04;
xmove = 0.06;
%% Non-shear
AR = 2;
Pr = 10;
Ra = 1e4;
run SomeInputStuff.m
path = convertStringsToChars(AllData.(ARS).(PrS).(RaS).path);
% field
num = '070';
nmpi = 8;
nx = 128;
ny = 128;
pathF = [path '/Fields/'];
files = dir([pathF,'hd2DTT','.*.',num,'.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([pathF,files(i).name],'r');
    fread(fid,1,'real*4');
    ff(:,i) = fread(fid,inf,'real*8');
    fclose(fid);
end
ff = reshape(ff,nx,ny);
plt = subplot(2,2,1);
fieldcheck = ff';
pcolor(ff');
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
shading flat
colormap('jet')
%xlabel('$x/(\pi d)$', 'FontSize', LabelFS)
ylabel('$y/(\pi d)$', 'FontSize', LabelFS)
xticks([1 nx])
%xticklabels({'$0$' '$\Gamma$'})
xticklabels({'' '' ''})
yticks([1 ny])
yticklabels({'$0$' '$1$'})
title('(a)', 'FontSize', TitleFS)
pos = get(plt, 'Position');
posnew = pos; 
posnew(2) = posnew(2) - ymove; posnew(1) = posnew(1) + xmove;
set(plt, 'Position', posnew)
text('String', 'Non-Shearing', 'Units', 'normalized','Position', [-0.4 0] , 'FontSize', TitleFS, 'Rotation',90)
% profile
kenergy = importdata([path '/Checks/kenergy.txt']);
kappa = sqrt((pi^3/(Ra*Pr)));
timescale = kappa/pi^2;
Ex = kenergy(:,6);
E = kenergy(:,2);
t = kenergy(:,1)*timescale;
Ey = kenergy(:,5);
urms = 2*Ex+2*Ey;
urms = MyMeanEasy(urms,t); urms = urms^(1/2);
pathS = [path '/Spectra/'];
zonal = importdata([pathS 'zonalmean.0' num '.txt'])/urms;
y = linspace(0 + 1/(2*ny), 1 - 1/(2*ny), ny);
plt = subplot(2,2,2);
plot(zonal,y, 'LineWidth', 2, 'Color', 'blue'), hold on
plot([0 0], [y(1) y(end)], 'black --')
plot([-2 2], [0.5 0.5], 'black --')
xlim([-2 2])
yticks([1 ny])
xticks([-2 2])
yticklabels({'' ''})
xticklabels({'' '' ''})
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = 1;
title('(b)', 'FontSize', TitleFS)
pos = get(plt, 'Position');
posnew = pos; 
posnew(2) = posnew(2) - ymove; 
set(plt, 'Position', posnew)

%% Shearing
Ra = 2e7;
run SomeInputStuff.m
path = convertStringsToChars(AllData.(ARS).(PrS).(RaS).path);
% field
num = '061';
nmpi = 8;
nx = 512;
ny = 256;
pathF = [path '/Fields/'];
files = dir([pathF,'hd2DTT','.*.',num,'.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([pathF,files(i).name],'r');
    fread(fid,1,'real*4');
    ff(:,i) = fread(fid,inf,'real*8');
    fclose(fid);
end
ff = reshape(ff,nx,ny);
plt = subplot(2,2,3);
fieldcheck = ff';
pcolor(ff');
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
shading flat
colormap('jet')
xlabel('$x/(\pi d)$', 'FontSize', LabelFS)
ylabel('$y/(\pi d)$', 'FontSize', LabelFS)
xticks([1 nx])
xticklabels({'$0$' '$\Gamma$'})
yticks([1 ny])
yticklabels({'$0$' '$1$'})
pos = get(plt, 'Position');
posnew = pos; 
posnew(2) = posnew(2) + ymove; posnew(1) = posnew(1) + xmove;
set(plt, 'Position', posnew)
text('String', 'Shearing', 'Units', 'normalized','Position', [-0.4 0.19] , 'FontSize', TitleFS, 'Rotation',90)
% profile
kenergy = importdata([path '/Checks/kenergy.txt']);
kappa = sqrt((pi^3/(Ra*Pr)));
timescale = kappa/pi^2;
Ex = kenergy(:,6);
E = kenergy(:,2);
t = kenergy(:,1)*timescale;
Ey = kenergy(:,5);
urms = 2*Ex+2*Ey;
urms = MyMeanEasy(urms,t); urms = urms^(1/2);
pathS = [path '/Spectra/'];
zonal = importdata([pathS 'zonalmean.0' num '.txt'])/urms;
y = linspace(0 + 1/(2*ny), 1 - 1/(2*ny), ny);
plt = subplot(2,2,4);
plot(zonal,y, 'LineWidth', 2, 'Color','red'), hold on
plot([0 0], [y(1) y(end)], 'black --')
plot([-2 2], [0.5 0.5], 'black --')
xlim([-2 2])
yticks([1 ny])
xlabel('$U/(u_{rms})$', 'FontSize', LabelFS)
yticklabels({'' ''})
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = 1;
pos = get(plt, 'Position');
posnew = pos; 
posnew(2) = posnew(2) + ymove; 
set(plt, 'Position', posnew)