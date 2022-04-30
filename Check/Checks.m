%% Set up
clear
path = '/Volumes/Samsung_T5/EigComp/Pr_6_2/Ra_7e4/';
nx = 128;
ny = 128;

%% TimeSer
figure('Renderer', 'painters', 'Position', [5 5 540 200])
Table = importdata([path 'Checks/kpsmodes1.txt']);
plot(Table(:,1), Table(:,2))
xlabel('$t$ (s)', 'FontSize', 14)
ylabel('$\hat \psi_{0,1}$', 'FontSize', 14)


%% 2d Spectra
figure
num = '0001';
xr = floor(nx/3 + 1) + 1;
yr = floor(2*ny/3 + 1);
Upath = [path 'Spectra/'];
fid = fopen([Upath 'spectrum2D_PP.' num '.out'],'r');
fread(fid,1, 'real*4');
Spectra = fread(fid,inf, 'real*8');
fclose(fid);
% Reshape and plot
Spectra = reshape(Spectra,xr,yr);
pcolor(Spectra');
colormap('jet')
colorbar
xticks([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5])
xticklabels({'0' '1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14'})
yticks([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5 14.5])
yticklabels({'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14'})
set(gca,'ColorScale','log')
%% Fields
nmpi = 4;
field = 'ps';
numnum = 1;
num = num2str(numnum);
while length(num) < 4
    num = ['0' num];
end
Upath = [path 'Fields/'];
field_times = join([Upath "field_times.txt"],"");
Times = importdata(field_times);
ListTimes = Times(:,2);
files = dir([Upath,'hd2D',field,'.*.',num,'.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([Upath,files(i).name],'r');
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
colorbar
xlabel('$x$', 'FontSize', 18)
ylabel('$y$', 'FontSize', 18)
xticks([1 nx])
xticklabels({'$0$' '$2\pi$'})
yticks([1 ny])
yticklabels({'$0$' '$\pi$'})
Time = ListTimes(numnum); Time = round(Time); Time = num2str(Time);
title(['$\psi$ at $t = ' Time  '$'], 'FontSize', 20)

%% Both in one
figure('Renderer', 'painters', 'Position', [5 5 540 200])
subplot(1,2,1)
nmpi = 2;
field = 'ps';
numnum = 2;
num = num2str(numnum);
while length(num) < 4
    num = ['0' num];
end
Upath = [path 'Fields/'];
field_times = join([Upath "field_times.txt"],"");
Times = importdata(field_times);
ListTimes = Times(:,2);
files = dir([Upath,'hd2D',field,'.*.',num,'.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([Upath,files(i).name],'r');
    fread(fid,1,'real*4');
    ff(:,i) = fread(fid,inf,'real*8');
    fclose(fid);
end
ff = reshape(ff,nx,ny);
fieldcheck = ff';
pcolor(ff');
shading flat
colormap('jet')
colorbar
xlabel('$x$', 'FontSize', 14)
ylabel('$y$', 'FontSize', 14)
xticks([1 nx])
xticklabels({'$0$' '$2\pi$'})
yticks([1 ny])
yticklabels({'$0$' '$\pi$'})
Time = ListTimes(numnum); Time = round(Time); Time = num2str(Time);
title(['$\psi$ at $t = ' Time  '$'], 'FontSize', 15)

subplot(1,2,2)
xr = floor(nx/3 + 1) + 1;
yr = floor(2*ny/3 + 1);
Upath = [path 'Spectra/'];
fid = fopen([Upath 'spectrum2D_PP.' num '.out'],'r');
fread(fid,1, 'real*4');
Spectra = fread(fid,inf, 'real*8');
fclose(fid);
% Reshape and plot
Spectra = reshape(Spectra,xr,yr);
pcolor(Spectra');
colormap('jet')
colorbar
caxis([1e-100 1])
xticks([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5])
xticklabels({'0' '1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14'})
yticks([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5 14.5])
yticklabels({'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14'})
%xlim([1 7])
%ylim([1 11])
xlabel('$k_x$', 'FontSize', 14)
ylabel('$k_y$', 'FontSize', 14)
title(['$\widehat \psi_{k_x,k_y}$ at $t = ' Time  '$'], 'FontSize', 15)
set(gca,'ColorScale','log')