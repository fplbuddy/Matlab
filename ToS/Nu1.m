run SetUp.m
AR = 2;
Pr = 30;
Ra = 6.4e6;
run SomeInputStuff.m

kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
xlower = AllData.(ARS).(PrS).(RaS).ICT;
kappa = AllData.(ARS).(PrS).(RaS).kappa;
tE = kenergy(:,1);
Ey = kenergy(:,5);
Ex = kenergy(:,6);
urms = 2*Ex+2*Ey;
urms = MyMeanEasy(urms,tE); urms = urms^(1/2);
h = pi;

signal = 2*kpsmodes1(:,2); signal = signal(xlower:end)/(h*urms);
t = kpsmodes1(:,1); t = t(xlower:end)/(h/urms);
Ik = kenergy(:,4);
Nut = 1 + pi*2*Ik(xlower:end)/kappa;

% Going to do it all with ext
urms = AllData.AR_2.Pr_30.Ra_6_4e6.urms; h = pi; kappa = AllData.AR_2.Pr_30.Ra_6_4e6.kappa;
kpsmodes1ext = importdata('/Users/philipwinchester/Documents/Data/Residue/Ra_6_4e6_ext/Checks/kpsmodes1.txt');
kenergy = importdata('/Users/philipwinchester/Documents/Data/Residue/Ra_6_4e6_ext/Checks/kenergy.txt');
Signalext = 2*kpsmodes1ext(:,2)/(h*urms); t = kpsmodes1ext(:,1)/(h/urms);
Ik = kenergy(:,4);
Nut = 1 + pi*2*Ik/kappa;

%% Plot
figure('Renderer', 'painters', 'Position', [5 5 600 400])
subplot(3,3,[4,5,6])
%fill([0 680 680 0],[-0.5 -0.5 0.5 0.5], [0.7 0.7 1], 'FaceAlpha', 0.15, 'EdgeAlpha', 0), hold on
%fill([680 1110 1110 680],[-0.5 -0.5 0.5 0.5], [0.35 0.5 0.35], 'FaceAlpha', 0.15, 'EdgeAlpha', 0), hold on
%fill([1110 2000 2000 1110],[-0.5 -0.5 0.5 0.5], [1 0.7 0.7], 'FaceAlpha', 0.15, 'EdgeAlpha', 0), hold on
plot(t-1.4e4, Signalext, 'Color', [0 0.5 0])
xlim([0 2000])
%ylabel({'$\hat \psi_{0,1}$','$(hu_{rms})$'}, 'Fontsize', LabelFS)
label_y = ylabel({'$\widehat \psi_{0,1}/(\pi du_{rms})$'}, 'Fontsize', LabelFS);
label_y.Position(1) = label_y.Position(1) - 50;
label_y.Units = 'normalized';
%plot([0.3e3 0.3e3], [-0.5 0.5], 'black--')
%plot([1e3 1e3], [-0.5 0.5], 'black--')
%plot([1.7e3 1.7e3], [-0.5 0.5], 'black--')
text(0.3e3-120,0.35,'(a)', 'FontSize', LabelFS)
text(1e3-120,0.35,'(b)', 'FontSize', LabelFS)
text(1.7e3-120,-0.35,'(c)', 'FontSize', LabelFS)
% double arrows
annotation('doublearrow', 'x', [0.135 0.398], 'y', [0.517 0.517])
annotation('doublearrow', 'x', [0.398 0.56], 'y', [0.517 0.517])
annotation('doublearrow', 'x', [0.56 0.9], 'y', [0.517 0.517])
% shading

hp4 = get(gca,'ylabel').Position;
set(get(gca,'ylabel'),'Position', [hp4(1)*1.01 hp4(2) hp4(3)])
ax = gca;
ax.YAxis.FontSize = numFS;
xticks([0 500 1000 1500 2000])
xticklabels({'' '' '' '' '' '' '' ''})
hold off

hej = subplot(3,3,[7,8,9])
hej.Position(2) = hej.Position(2) + 0.05;
plot(t-1.4e4, Nut(1:length(t)), 'Color', [0 0.5 0]), hold on
xlim([0 2000])
ylim([0 80])
yticks([0 35 70])
%plot([0.3e3 0.3e3], [0 70], 'black--')
%plot([1e3 1e3], [0 70], 'black--')
%plot([1.7e3 1.7e3], [0 70], 'black--')
label_y = ylabel('Nu$(t)$', 'Fontsize', LabelFS);
label_y.Units = 'normalized';
label_y.Position(1) = -0.0747;
label_x = xlabel('$t/(\pi d/u_{rms})$', 'Fontsize', LabelFS);
%label_x.Position(2) = label_x.Position(2) + 0.001;
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xticklabels({'10000' '10500' '11000' '11500' '12000'})
hold off

nx = 256; ny = 256; nmpi = 16;
titlepos = [50 250 1.00011];
subplot(3,3,1)
num = '021';
pathF = convertStringsToChars([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Fields/']);
files = dir([pathF,'hd2DTT','.*.',num,'.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([pathF,files(i).name],'r');
    fread(fid,1,'real*4');
    ff(:,i) = fread(fid,inf,'real*8');
    fclose(fid);
end
ff = reshape(ff,nx,ny);
fieldcheck = ff';
pcolor(ff');
title('(a)','FontSize', TitleFS )
%set(get(gca,'title'),'Position', titlepos)
shading flat
colormap('jet')
caxis([0 1])
xlabel('$x/(\pi d)$', 'FontSize', LabelFS)
label_y = ylabel('$y/(\pi d)$', 'FontSize', LabelFS);
label_y.Units = 'normalized';
label_y.Position(1) = -0.135;
xticks([1 nx])
xticklabels({'$0$' '$\Gamma$'})
yticks([1 ny])
yticklabels({'$0$' '$1$'})
hp4 = get(gca,'xlabel').Position;
set(get(gca,'xlabel'),'Position', [hp4(1) hp4(2)/2 hp4(3)])
hp4 = get(gca,'ylabel').Position;
set(get(gca,'ylabel'),'Position', [hp4(1)*2.1 hp4(2) hp4(3)])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;

subplot(3,3,2)
num = '033';
pathF = convertStringsToChars([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Fields/']);
files = dir([pathF,'hd2DTT','.*.',num,'.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([pathF,files(i).name],'r');
    fread(fid,1,'real*4');
    ff(:,i) = fread(fid,inf,'real*8');
    fclose(fid);
end
ff = reshape(ff,nx,ny);
fieldcheck = ff';
pcolor(ff');
title('(b)','FontSize', TitleFS)
%set(get(gca,'title'),'Position', titlepos)
shading flat
colormap('jet')
caxis([0 1])
xlabel('$x/(\pi d)$', 'FontSize', LabelFS)
xticks([1 nx])
xticklabels({'$0$' '$\Gamma$'})
yticks([])
yticklabels({})
hp4 = get(gca,'xlabel').Position;
set(get(gca,'xlabel'),'Position', [hp4(1) hp4(2)/2 hp4(3)])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;

subplot(3,3,3)
num = '006';
pathF = convertStringsToChars([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Fields/']);
files = dir([pathF,'hd2DTT','.*.',num,'.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([pathF,files(i).name],'r');
    fread(fid,1,'real*4');
    ff(:,i) = fread(fid,inf,'real*8');
    fclose(fid);
end
ff = reshape(ff,nx,ny);
fieldcheck = ff';
pcolor(ff');
title('(c)','FontSize', TitleFS )
%set(get(gca,'title'),'Position', titlepos)
shading flat
colormap('jet')
caxis([0 1])
xlabel('$x/(\pi d)$', 'FontSize', LabelFS)
xticks([1 nx])
xticklabels({'$0$' '$\Gamma$'})
yticks([])
yticklabels({})
hp4 = get(gca,'xlabel').Position;
set(get(gca,'xlabel'),'Position', [hp4(1) hp4(2)/2 hp4(3)])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;

hp4 = get(subplot(3,3,3),'Position');
c = colorbar('Position', [hp4(1)+hp4(3)+0.015  hp4(2)  0.015  hp4(4)]);
c.FontSize = numFS*0.8;

%% Calcs
Shearing = [AllData.(ARS).(PrS).(RaS).calcs.pos AllData.(ARS).(PrS).(RaS).calcs.neg];
NonShearing = AllData.(ARS).(PrS).(RaS).calcs.zero;

section = [];
for j=1:length(Shearing)
    section = [section Shearing{j}];
end
mean(Nut(section))

section = [];
for j=1:length(NonShearing)
    section = [section NonShearing{j}];
end
mean(Nut(section))




