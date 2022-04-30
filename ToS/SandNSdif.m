run SetUp.m
figure('Renderer', 'painters', 'Position', [5 5 1000 400])
Ra = 1e7;
RaS = RatoRaS(Ra);
Pr = 10;
PrS = PrtoPrS(Pr);
kappa = sqrt((pi^3/(Ra*Pr)));
timescale = kappa/pi^2;

up = 0.03;
xmove1 = 0.03;
xmove2 = 0.04;
xmove3 = 0.049;
xmove4 = 0.02;


%% Do the shearing case first
path = '/Volumes/Samsung_T5/Residue/256x256/Pr_10/Ra_1e7';
% Energy
kenergy = importdata([path '/Checks/kenergy.txt']);
Ex = kenergy(:,6);
E = kenergy(:,2);
t = kenergy(:,1)*timescale;
plt = subplot(2,4,1);
plot(t, Ex./E, 'Color', 'red')
xlim([1 1.1])
ax = gca;
ax.YAxis.FontSize = numFS;
xticklabels({'' '' ''})
%xlabel('$t/((\pi d)^2/\kappa)$', 'FontSize', LabelFS)
ylabel('$E_x/E$', 'FontSize', LabelFS)
pos = get(plt, 'Position');
posnew = pos; 
posnew(2) = posnew(2) - up; posnew(1) = posnew(1) + xmove1;
set(plt, 'Position', posnew)
text('String', 'Shearing', 'Units', 'normalized','Position', [-0.6 0.2] , 'FontSize', TitleFS, 'Rotation',90)
text('String', '(a)', 'Units', 'normalized','Position', [0.425 1.1] , 'FontSize', numFS)

% Nusselt
Ik = kenergy(:,4);
Nut = 1 + pi*2*Ik/kappa;
plt = subplot(2,4,2);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
plot(t, Nut, 'Color', 'red')
xlim([1 1.1])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xticklabels({'' '' ''})
ylabel('Nu', 'FontSize', LabelFS)
pos = get(plt, 'Position');
posnew = pos; 
posnew(2) = posnew(2) - up; posnew(1) = posnew(1) + xmove2;
set(plt, 'Position', posnew)
text('String', '(b)', 'Units', 'normalized','Position', [0.425 1.1] , 'FontSize', numFS)

% Field
num = '12';
nmpi = 16;
nx = 256;
ny = 256;
while length(num) < 3
    num = ['0' num];
end
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
plt = subplot(2,4,3);
fieldcheck = ff';
pcolor(ff');
shading flat
colormap('jet')
%xlabel('$x/(\pi d)$', 'FontSize', LabelFS)
ylabel('$y/(\pi d)$', 'FontSize', LabelFS)
xticks([1 nx])
%xticklabels({'$0$' '$\Gamma$'})
xticklabels({'' '' ''})
yticks([1 ny])
yticklabels({'$0$' '$1$'})
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
pos = get(plt, 'Position');
posnew = pos; 
posnew(2) = posnew(2) - up; posnew(1) = posnew(1) + xmove3;
set(plt, 'Position', posnew)
text('String', '(c)', 'Units', 'normalized','Position', [0.425 1.1] , 'FontSize', numFS)

% Zonal
Ey = kenergy(:,5);
urms = 2*Ex+2*Ey;
urms = MyMeanEasy(urms,t); urms = urms^(1/2);
pathS = [path '/Spectra/'];
zonal = importdata([pathS 'zonalmean.0' num '.txt'])/urms;
y = linspace(0 + 1/(2*ny), 1 - 1/(2*ny), ny);
plt = subplot(2,4,4);
plot(zonal,y, 'LineWidth', 2, 'Color', 'red'), hold on
plot([0 0], [y(1) y(end)], 'black --')
plot([-2 2], [0.5 0.5], 'black --')
xlim([-2 2])
yticks([1 ny])
yticklabels({'' ''})
xticklabels({'' '' ''})
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = 1;
pos = get(plt, 'Position');
posnew = pos; 
posnew(2) = posnew(2) - up; posnew(1) = posnew(1) + xmove4;
set(plt, 'Position', posnew)
text('String', '(d)', 'Units', 'normalized','Position', [0.425 1.1] , 'FontSize', numFS)

%% Non-shearing
path = convertStringsToChars(AllData.AR_2.(PrS).(RaS).path);
% Energy
kenergy = importdata([path '/Checks/kenergy.txt']);
Ex = kenergy(:,6);
E = kenergy(:,2);
t = kenergy(:,1)*timescale;
plt = subplot(2,4,5);
plot(t, Ex./E, 'Color', 'blue')
xlim([1 1.1])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t/((\pi d)^2/\kappa)$', 'FontSize', LabelFS)
label_y = ylabel('$E_x/E$', 'FontSize', LabelFS);
label_y.Position(1) = label_y.Position(1) + 0.007; 
pos = get(plt, 'Position');
posnew = pos; 
posnew(2) = posnew(2) + up; posnew(1) = posnew(1) + xmove1;
set(plt, 'Position', posnew)
text('String', 'Non-shearing', 'Units', 'normalized','Position', [-0.6 0.1] , 'FontSize', TitleFS, 'Rotation',90)

% Nusselt
Ik = kenergy(:,4);
Nut = 1 + pi*2*Ik/kappa;
plt = subplot(2,4,6);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
plot(t, Nut, 'Color', 'blue')
xlim([1 1.1])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('Nu', 'FontSize', LabelFS)
xlabel('$t/((\pi d)^2/\kappa)$', 'FontSize', LabelFS)
pos = get(plt, 'Position');
posnew = pos; 
posnew(2) = posnew(2) + up; posnew(1) = posnew(1) + xmove2;
set(plt, 'Position', posnew)

% Field
num = '12';
nmpi = 8;
while length(num) < 3
    num = ['0' num];
end
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
plt = subplot(2,4,7);
fieldcheck = ff';
pcolor(ff');
shading flat
colormap('jet')
xlabel('$x/(\pi d)$', 'FontSize', LabelFS)
ylabel('$y/(\pi d)$', 'FontSize', LabelFS)
xticks([1 nx])
xticklabels({'$0$' '$\Gamma$'})
yticks([1 ny])
yticklabels({'$0$' '$1$'})
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
pos = get(plt, 'Position');
posnew = pos; 
posnew(2) = posnew(2) + up; posnew(1) = posnew(1) + xmove3;
set(plt, 'Position', posnew)

% Zonal
Ey = kenergy(:,5);
urms = 2*Ex+2*Ey;
urms = MyMeanEasy(urms,t); urms = urms^(1/2);
pathS = [path '/Spectra/'];
zonal = importdata([pathS 'zonalmean.0' num '.txt'])/urms;
y = linspace(0 + 1/(2*ny), 1 - 1/(2*ny), ny);
plt = subplot(2,4,8);
plot(zonal,y, 'LineWidth', 2, 'Color', 'blue'), hold on
plot([0 0], [y(1) y(end)], 'black --')
plot([-2 2], [0.5 0.5], 'black --')
xlim([-2 2])
yticks([1 ny])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = 1;
yticklabels({'' ''})
xlabel('$U/(u_{rms})$', 'FontSize', LabelFS)
pos = get(plt, 'Position');
posnew = pos; 
posnew(2) = posnew(2) + up; posnew(1) = posnew(1) + xmove4;
set(plt, 'Position', posnew)

