run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m

Pr = 30; Ra = 4.5e6; ARS = 'AR_2';
PrS = PrtoPrS(Pr); RaS =  convertStringsToChars(RatoRaS(Ra));
path = convertStringsToChars(AllData.(ARS).(PrS).(RaS).path);
t = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
xlower = AllData.(ARS).(PrS).(RaS).ICT;
t = t(:,1);
t = t(xlower:end);
t = reshape(t, 1, length(t));
tmin = min(t);
%% Getting times
post = [1e8];
negt = [1e8];
zerot = [1e8];
for i=1:length(AllData.(ARS).(PrS).(RaS).calcs.pos)
    section = AllData.(ARS).(PrS).(RaS).calcs.pos{i};
    post = [post t(AllData.(ARS).(PrS).(RaS).calcs.pos{i})];
end
% Finding neg shearing times
for i=1:length(AllData.(ARS).(PrS).(RaS).calcs.neg)
    section = AllData.(ARS).(PrS).(RaS).calcs.neg{i};
    negt = [negt t(AllData.(ARS).(PrS).(RaS).calcs.neg{i})];
end
% Finding zero times
for i=1:length(AllData.(ARS).(PrS).(RaS).calcs.zero)
    section = AllData.(ARS).(PrS).(RaS).calcs.zero{i};
    zerot = [zerot t(AllData.(ARS).(PrS).(RaS).calcs.zero{i})];
end

%% Take average in Sshearing
field = 'ps';
nx = 256;
ny = 256;
nmpi = 16;
pathF = [path  '/Fields/'];
Times = importdata([pathF 'field_times.txt']);

ListTimes = Times(:,2);
nums = Times(:,1);
psn = zeros(256,256);
psp = zeros(256,256);
psz = zeros(256,256);
pn = 0;
nn = 0;
zn = 0;

for i=1:length(nums)
    num = nums(i)
    time = ListTimes(i);
    num = num2str(num);
    if time > tmin
        while length(num) < 4
            num = ['0' num];
        end
        files = dir([pathF,'hd2D',field,'.*.',num,'.dat']);
        ff = zeros(nx*ny/nmpi,nmpi);
        for j=1:nmpi % Looping round mpi
            fid = fopen([pathF,files(j).name],'r');
            fread(fid,1,'real*4');
            ff(:,j) = fread(fid,inf,'real*8');
            fclose(fid);
        end
        ff = reshape(ff,nx,ny);
        if ismembertol(time, post,1e-9) % Ie we are positive shearing
            psp = psp + ff';
            pn = pn+1;
        elseif ismembertol(time, negt,1e-9) % Ie we are negative shearing
            psn = psn + ff';
            nn = nn+1;
        elseif ismembertol(time, zerot,1e-9) % Ie we are zero
            psz = psz + ff';
            zn =zn+1;
        end
    end
end
%%
figure()
pcolor(psz/zn);
shading flat
colormap('jet')
title(['$\overline{\psi}$, NonShearing'],'FontSize',18)
xlabel('$x$', 'FontSize', labelFS)
ylabel('$y$', 'FontSize', labelFS)
xticks([1 nx])
xticklabels({'$0$' '$2\pi$'})
yticks([1 ny])
yticklabels({'$0$' '$\pi$'})
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
c = colorbar;
c.FontSize = numFS;


figure()
pcolor(ff');
shading flat
colormap('jet')
title(['$\psi$, NonShearing'],'FontSize',18)
xlabel('$x$', 'FontSize', labelFS)
ylabel('$y$', 'FontSize', labelFS)
xticks([1 nx])
xticklabels({'$0$' '$2\pi$'})
yticks([1 ny])
yticklabels({'$0$' '$\pi$'})
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
c = colorbar;
c.FontSize = numFS;
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


