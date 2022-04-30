run SetUp.m

path = '/Volumes/Samsung_T5/Video/Revs/Pr_30/Ra_9e5';
kpsmodes1 = importdata([path '/Checks/kpsmodes1.txt']);
field_times = importdata([path '/Fields/field_times.txt']);
spec_times = importdata([path '/Spectra/spec_times.txt']); % Spectimes and modes are the same, fields is - 1

nx = 128; ny = 128; nmpi = 8;
Ra = 9e5; Pr = 30;
kappa = sqrt((pi)^3/(Ra*Pr)); nu = sqrt((pi)^3*Pr/(Ra));

ZeroZero = kpsmodes1(:,2); t = kpsmodes1(:,1);

I = 5959; % Location of minumum of abs(ZeroOne)
Iu = I + 20;
Il = I - 20;
% Look at these values to start off with

ZeroZero = ZeroZero/kappa; t = t*kappa/pi^2-1;

figure('Renderer', 'painters', 'Position', [5 5 700 600])

subplot(3,3,[1 2 3])
plot(t, ZeroZero, 'b-'); hold on
xlim([t(Il - 10) t(Iu + 10)])
plot([t(Il) t(Il)], [-100 100], '--black')
plot([t(I) t(I)], [-100 100], '--black')
plot([t(Iu) t(Iu)], [-100 100], '--black'); hold off
xlabel('$t$', 'FontSize', 14)
ylabel('$\hat \psi_{0,1}$', 'FontSize', 14)
text(t(Il)-0.0003,-80,'a', 'FontSize', 15)
text(t(I)-0.0003,-80,'b', 'FontSize', 15)
text(t(Iu)-0.0003,-80,'c', 'FontSize', 15)

subplot(3,3,4)
num = num2str(Il+1);
pathF = convertStringsToChars([path '/Fields/']);
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
title('a','FontSize', 15 )
shading flat
colormap('jet')
caxis([0 1])
xlabel('$x$', 'FontSize', 14)
ylabel('$y$', 'FontSize', 14)
xticks([1 nx])
xticklabels({'$0$' '$\Gamma$'})
yticks([1 ny])
yticklabels({'$0$' '$1$'})

subplot(3,3,5)
num = num2str(I+1);
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
title('b','FontSize', 15 )
shading flat
colormap('jet')
caxis([0 1])
xlabel('$x$', 'FontSize', 14)
xticks([1 nx])
xticklabels({'$0$' '$\Gamma$'})
yticks([])
yticklabels({})

subplot(3,3,6)
num = num2str(Iu+1);
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
title('c','FontSize', 15 )
shading flat
colormap('jet')
caxis([0 1])
xlabel('$x$', 'FontSize', 14)
xticks([1 nx])
xticklabels({'$0$' '$\Gamma$'})
yticks([])
yticklabels({})

hp4 = get(subplot(3,3,6),'Position');
colorbar('Position', [hp4(1)+hp4(3)+0.01  hp4(2)  0.02  hp4(4)-0.006])

subplot(3,3,7)
ND = pi^2/kappa^2;
xr = floor(nx/3 + 1) + 1;
yr = floor(2*ny/3 + 1);
pathF = convertStringsToChars([path '/Spectra/']);
num = num2str(Il+1);
fid = fopen([pathF 'spectrum2D_UU.' num '.out'],'r');
fread(fid,1, 'real*4');
Spectra = fread(fid,inf, 'real*8');
fclose(fid);
% Reshape and plot
Spectra = ND*reshape(Spectra,xr,yr);
pcolor(Spectra');
colormap('jet')
%colorbar; 
caxis([1 1e5])
set(gca,'ColorScale','log')
xlim([1 10])
ylim([1 10])
xlabel('$k_x$', 'FontSize', 14)
ylabel('$k_y$', 'FontSize', 14)
l = 3:2:40; l = l/2;
xticks(l)
xticklabels({'$0$' '$1$' '$2$' '$3$' '$4$' '$5$' '$6$' '$7$' '$8$'})
yticks(l)
yticklabels({'$1$' '$2$' '$3$' '$4$' '$5$' '$6$' '$7$' '$8$' '$9$' '$10$' '$11$' '$12$' '$13$' '$14$' '$15$' '$16$' '$17$' '$18$' '$19$'})

subplot(3,3,8)
num = num2str(I+1);
fid = fopen([pathF 'spectrum2D_UU.' num '.out'],'r');
fread(fid,1, 'real*4');
Spectra = fread(fid,inf, 'real*8');
fclose(fid);
% Reshape and plot
Spectra = ND*reshape(Spectra,xr,yr);
pcolor(Spectra');
colormap('jet')
caxis([1 1e5])
set(gca,'ColorScale','log')
xlim([1 10])
ylim([1 10])
xlabel('$k_x$', 'FontSize', 14)
l = 3:2:40; l = l/2;
xticks(l)
xticklabels({'$0$' '$1$' '$2$' '$3$' '$4$' '$5$' '$6$' '$7$' '$8$'})
yticks([])
yticklabels({})

subplot(3,3,9)
num = num2str(Iu+1);
fid = fopen([pathF 'spectrum2D_UU.' num '.out'],'r');
fread(fid,1, 'real*4');
Spectra = fread(fid,inf, 'real*8');
fclose(fid);
% Reshape and plot
Spectra = ND*reshape(Spectra,xr,yr);
pcolor(Spectra');
colormap('jet')
caxis([1 1e5])
set(gca,'ColorScale','log')
xlim([1 10])
ylim([1 10])
xlabel('$k_x$', 'FontSize', 14)
l = 3:2:40; l = l/2;
xticks(l)
xticklabels({'$0$' '$1$' '$2$' '$3$' '$4$' '$5$' '$6$' '$7$' '$8$'})
yticks([])
yticklabels({})

hp4 = get(subplot(3,3,9),'Position');
colorbar('Position', [hp4(1)+hp4(3)+0.01  hp4(2)  0.02  hp4(4)-0.007])
