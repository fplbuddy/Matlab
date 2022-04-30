run SetUp.m
AR = 2;
Pr = 30;
Ra = 6.4e6;
run SomeInputStuff.m

%% get non-dim
urms = AllData.(ARS).(PrS).(RaS).urms;

%% plot 1, one figure

figure('Renderer', 'painters', 'Position', [5 5 700 200])
nx = 256; ny = 256; nmpi = 16;
subplot(1,3,1)
num = '021';
pathF = convertStringsToChars([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Fields/']);
files = dir([pathF,'hd2Dww','.*.',num,'.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([pathF,files(i).name],'r');
    fread(fid,1,'real*4');
    ff(:,i) = fread(fid,inf,'real*8');
    fclose(fid);
end
ff = reshape(ff,nx,ny);
ff = ff*pi/urms;
pcolor(ff');
title('(a)','FontSize', TitleFS )
%set(get(gca,'title'),'Position', titlepos)
shading flat
colormap(bluewhitered)
colorbar()
%caxis([0 1])
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

subplot(1,3,2)
num = '033';
files = dir([pathF,'hd2Dww','.*.',num,'.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([pathF,files(i).name],'r');
    fread(fid,1,'real*4');
    ff(:,i) = fread(fid,inf,'real*8');
    fclose(fid);
end
ff = reshape(ff,nx,ny);
ff = ff*pi/urms;
pcolor(ff');
title('(b)','FontSize', TitleFS)
%set(get(gca,'title'),'Position', titlepos)
shading flat
colormap(bluewhitered)
colorbar()
%caxis([0 1])
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

subplot(1,3,3)
num = '006';
files = dir([pathF,'hd2Dww','.*.',num,'.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([pathF,files(i).name],'r');
    fread(fid,1,'real*4');
    ff(:,i) = fread(fid,inf,'real*8');
    fclose(fid);
end
ff = reshape(ff,nx,ny);
ff = ff*pi/urms;
pcolor(ff');
title('(c)','FontSize', TitleFS )
%set(get(gca,'title'),'Position', titlepos)
shading flat
colormap(bluewhitered)
colorbar()
%caxis([0 1])
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

%% plot 2, many figures
figure('Renderer', 'painters', 'Position', [5 5 350 200])
nx = 256; ny = 256; nmpi = 16;
num = '021';
pathF = convertStringsToChars([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Fields/']);
files = dir([pathF,'hd2Dww','.*.',num,'.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([pathF,files(i).name],'r');
    fread(fid,1,'real*4');
    ff(:,i) = fread(fid,inf,'real*8');
    fclose(fid);
end
ff = reshape(ff,nx,ny);
ff = ff*pi/urms;
pcolor(ff');
title('(a)','FontSize', TitleFS )
%set(get(gca,'title'),'Position', titlepos)
shading flat
colormap(bluewhitered)
colorbar('FontSize', numFS)
%caxis([0 1])
xlabel('$x/(\pi d)$', 'FontSize', LabelFS)
label_y = ylabel('$y/(\pi d)$', 'FontSize', LabelFS);
% label_y.Units = 'normalized';
% label_y.Position(1) = -0.135;
xticks([1 nx])
xticklabels({'$0$' '$\Gamma$'})
yticks([1 ny])
yticklabels({'$0$' '$1$'})
% hp4 = get(gca,'xlabel').Position;
% set(get(gca,'xlabel'),'Position', [hp4(1) hp4(2)/2 hp4(3)])
% hp4 = get(gca,'ylabel').Position;
% set(get(gca,'ylabel'),'Position', [hp4(1)*2.1 hp4(2) hp4(3)])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
saveas(gcf,'/Users/philipwinchester/Desktop/FigsForSupMat/vort1','epsc')

figure('Renderer', 'painters', 'Position', [5 5 350 200])
num = '033';
files = dir([pathF,'hd2Dww','.*.',num,'.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([pathF,files(i).name],'r');
    fread(fid,1,'real*4');
    ff(:,i) = fread(fid,inf,'real*8');
    fclose(fid);
end
ff = reshape(ff,nx,ny);
ff = ff*pi/urms;
pcolor(ff');
title('(b)','FontSize', TitleFS)
%set(get(gca,'title'),'Position', titlepos)
shading flat
colormap(bluewhitered)
colorbar('FontSize', numFS)
%caxis([0 1])
xlabel('$x/(\pi d)$', 'FontSize', LabelFS)
xticks([1 nx])
xticklabels({'$0$' '$\Gamma$'})
yticks([])
yticklabels({})
% hp4 = get(gca,'xlabel').Position;
% set(get(gca,'xlabel'),'Position', [hp4(1) hp4(2)/2 hp4(3)])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
saveas(gcf,'/Users/philipwinchester/Desktop/FigsForSupMat/vort2','epsc')

figure('Renderer', 'painters', 'Position', [5 5 350 200])
num = '006';
files = dir([pathF,'hd2Dww','.*.',num,'.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([pathF,files(i).name],'r');
    fread(fid,1,'real*4');
    ff(:,i) = fread(fid,inf,'real*8');
    fclose(fid);
end
ff = reshape(ff,nx,ny);
ff = ff*pi/urms;
pcolor(ff');
title('(c)','FontSize', TitleFS )
%set(get(gca,'title'),'Position', titlepos)
shading flat
colormap(bluewhitered)
colorbar('FontSize', numFS)
%caxis([0 1])
xlabel('$x/(\pi d)$', 'FontSize', LabelFS)
xticks([1 nx])
xticklabels({'$0$' '$\Gamma$'})
yticks([])
yticklabels({})
% hp4 = get(gca,'xlabel').Position;
% set(get(gca,'xlabel'),'Position', [hp4(1) hp4(2)/2 hp4(3)])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
saveas(gcf,'/Users/philipwinchester/Desktop/FigsForSupMat/vort3','epsc')