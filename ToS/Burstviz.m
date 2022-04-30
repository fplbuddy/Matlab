run SetUp.m
run Params.m
run SomeInputStuff.m
figure('Renderer', 'painters', 'Position', [5 5 600 400])

path = convertStringsToChars(AllData.(ARS).(PrS).(RaS).path);
kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);

up = 0.05;

%%
figure('Renderer', 'painters', 'Position', [5 5 600 400])
num = '70';
nmpi = 8;
nx = 512;
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
plt = subplot(2,2,4);
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
title('At time (b)', 'FontSize', TitleFS)
pos = get(plt, 'Position');
posnew = pos; 
posnew(2) = posnew(2) + up; 
set(plt, 'Position', posnew)

num = '69';
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
plt = subplot(2,2,2);
fieldcheck = ff';
pcolor(ff');
shading flat
colormap('jet')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
%xlabel('$x/(\pi d)$', 'FontSize', LabelFS)
ylabel('$y/(\pi d)$', 'FontSize', LabelFS)
xticks([1 nx])
xticklabels({'' ''})
yticks([1 ny])
yticklabels({'$0$' '$1$'})
title('At time (a)', 'FontSize', TitleFS)

range = [2.21 2.51]; 

% Ex
Ra = 2e7;
Pr = 1;
kappa = sqrt((pi^3/(Ra*Pr)));
timescale = kappa/pi^2;
Ex = kenergy(:,6);
E = kenergy(:,2);
t = kenergy(:,1)*timescale;
plt = subplot(2,2,1);
Ex = Ex*pi^2/kappa^2;
semilogy(t, Ex), hold on
plot(t(160000), Ex(160000), 'r.', 'MarkerSize', 20)
plot(t(164000), Ex(164000), '.', 'MarkerSize', 20, 'Color', [0 0.5 0])
%plot([2.4 2.4], [1e6 5e6], 'black--')
hold off
annotation('arrow',[0.3 0.303],[0.7 0.79])%,'String','(a)', 'FontSize', numFS)
annotation('arrow',[0.42 0.395],[0.7 0.78])%,'String','(b)', 'FontSize', numFS)
text('String', '(a)', 'Units', 'normalized','Position', [0.45 0.28] , 'FontSize', numFS)
text('String', '(b)', 'Units', 'normalized','Position', [0.8 0.28] , 'FontSize', numFS)
xlim(range)
%ylim([0 0.6*pi^2/kappa^2])
ax = gca;
ax.YAxis.FontSize = numFS;
xticks([2.21 2.36 2.51])
xticklabels({'' '' '' '' ''})
set(gca, 'YScale', 'log')
label_y = ylabel('$E_x/(\kappa/(\pi d))^2$', 'FontSize', LabelFS);
label_y.Position(1) = label_y.Position(1) - 0.025; 

% Nu
Ik = kenergy(:,4);
Nu = 1 + pi*2*Ik/kappa; 
plt = subplot(2,2,3);
semilogy(t, Nu), hold on
plot(t(160000), Nu(160000), 'r.', 'MarkerSize', 20)
plot(t(164000), Nu(164000), '.', 'MarkerSize', 20, 'Color', [0 0.5 0])
hold off
ylim([1 90])
xlim(range)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xticks([2.21 2.36 2.51])
xticklabels({'1' '1.15' '1.30'})
grid on
xlabel('$t/((\pi d)^2/\kappa)$', 'FontSize', LabelFS)
ylabel('Nu', 'FontSize', LabelFS)
pos = get(plt, 'Position');
posnew = pos; 
posnew(2) = posnew(2) + up; 
set(plt, 'Position', posnew)
