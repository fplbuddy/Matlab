run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
path = '/Volumes/Samsung_T5/AR_2/256x256/Pr_30/Ra_4_5e6';
%% check time series
kpsmodes1 = importdata([path '/Checks/kpsmodes1.txt']);
plot(kpsmodes1(:,1),kpsmodes1(:,2), '-'), hold on
%% getting where we have shearing and non-shearing
NData = [2:371 1339:9999];
SData = [372:1338];

%% Take average in Sshearing
fields = ["TT"];
nx = 256;
ny = 256;
nmpi = 8;
pathF = [path  '/Fields/'];
ps = zeros(256,256);
theta = zeros(256,256);


for num=SData
    num = num2str(num)
    while length(num) < 4
        num = ['0' num];
    end
    for i=1:length(fields)
        field = convertStringsToChars(fields(i));
        files = dir([pathF,'hd2D',field,'.*.',num,'.dat']);
        ff = zeros(nx*ny/nmpi,nmpi);
        for j=1:nmpi % Looping round mpi
            fid = fopen([pathF,files(j).name],'r');
            fread(fid,1,'real*4');
            ff(:,j) = fread(fid,inf,'real*8');
            fclose(fid);
        end
        ff = reshape(ff,nx,ny);
        if i == 1
            ps = ps + ff';
        else
            theta = theta + ff';
        end
        
    end
end

%% now do NS
fields = ["TT"];
nx = 256;
ny = 256;
nmpi = 8;
pathF = [path  '/Fields/'];
ps = zeros(256,256);
theta = zeros(256,256);


for num=[1991:9999]
    num = num2str(num)
    while length(num) < 4
        num = ['0' num];
    end
    for i=1:length(fields)
        field = convertStringsToChars(fields(i));
        files = dir([pathF,'hd2D',field,'.*.',num,'.dat']);
        ff = zeros(nx*ny/nmpi,nmpi);
        for j=1:nmpi % Looping round mpi
            fid = fopen([pathF,files(j).name],'r');
            fread(fid,1,'real*4');
            ff(:,j) = fread(fid,inf,'real*8');
            fclose(fid);
        end
        ff = reshape(ff,nx,ny);
        if i == 1
            ps = ps + ff';
        else
            theta = theta + ff';
        end
        
    end
end
%%
% figure()
% pcolor(TTNonShearing/max(max(TTNonShearing)));
% shading flat
% colormap('jet')
% title(['$\overline{T}$, NonShearing'],'FontSize',18)
% xlabel('$x$', 'FontSize', labelFS)
% ylabel('$y$', 'FontSize', labelFS)
% xticks([1 nx])
% xticklabels({'$0$' '$2\pi$'})
% yticks([1 ny])
% yticklabels({'$0$' '$\pi$'})
% ax = gca;
% ax.XAxis.FontSize = numFS;
% ax.YAxis.FontSize = numFS;
% c = colorbar;
% c.FontSize = numFS;
% 
% figure()
% pcolor(TTShearing/max(max(TTShearing)));
% shading flat
% colormap('jet')
% title(['$\overline{T}$, Shearing'],'FontSize',18)
% xlabel('$x$', 'FontSize', labelFS)
% ylabel('$y$', 'FontSize', labelFS)
% xticks([1 nx])
% xticklabels({'$0$' '$2\pi$'})
% yticks([1 ny])
% yticklabels({'$0$' '$\pi$'})
% ax = gca;
% ax.XAxis.FontSize = numFS;
% ax.YAxis.FontSize = numFS;
% c = colorbar;
% c.FontSize = numFS;
% 
% 
% for i=1:256
%     check(i) = 1 - (i-0.5)/256;
% end
% check = check';
% for i=1:256
%     hej(:,i) = check;
% end
% 
% 
% figure()
% pcolor(TTShearing/max(max(TTShearing))-hej);
% shading flat
% colormap('jet')
% title(['$\overline{\theta}$, Shearing'],'FontSize',18)
% xlabel('$x$', 'FontSize', labelFS)
% ylabel('$y$', 'FontSize', labelFS)
% xticks([1 nx])
% xticklabels({'$0$' '$2\pi$'})
% yticks([1 ny])
% yticklabels({'$0$' '$\pi$'})
% ax = gca;
% ax.XAxis.FontSize = numFS;
% ax.YAxis.FontSize = numFS;
% c = colorbar;
% c.FontSize = numFS;


