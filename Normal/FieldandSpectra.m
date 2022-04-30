run Params.m
run SomeInputStuff.m
path = [convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Fields/'];

field = 'ps';
nmpi = 8;
num = 101;
numthree = num2str(num);
while length(numthree) < 3
    numthree = ['0' numthree];
end
numfour = ['0' numthree]

% Get times
field_times = join([path "field_times.txt"],"");
Times = importdata(field_times);
ListTimes = Times(:,2);
MyTime = num2str(round(ListTimes(num)));

figure('Renderer', 'painters', 'Position', [5 5 540 200])
% Making field plot
Res = convertStringsToChars(AllData.(ARS).(PrS).(RaS).Res);
[nx, ny] = nxny(Res);
files = dir([path 'hd2D' field '.*.' numfour '.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([path,files(i).name],'r');
    fread(fid,1,'real*4');
    ff(:,i) = fread(fid,inf,'real*8');
    fclose(fid);
end
ff = reshape(ff,nx,ny);
subplot(1,2,1)
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
title('$\psi$', 'FontSize', 15)
sgtitle(['$' convertStringsToChars(AllData.(ARS).(PrS).(RaS).title) '$' ' at time $= ' MyTime '$'], 'FontSize',15)

% Making Spectra plot
path = [convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/'];
xr = floor(nx/3 + 1) + 1;
yr = floor(2*ny/3 + 1);
fid = fopen([path 'spectrum2D_UU.' numfour '.out'],'r');
fread(fid,1, 'real*4');
Spectra = fread(fid,inf, 'real*8');
fclose(fid);
Spectra = reshape(Spectra,xr,yr);
Spectra = Spectra';
subplot(1,2,2)
pcolor(Spectra);
colormap('jet')
colorbar
set(gca,'ColorScale','log')
title('$\hat \psi_{k_x, k_y}$', 'FontSize', 15)
xlim([1 9])
ylim([1 7])
xlabel('$k_x$', 'FontSize', 14)
ylabel('$k_y$', 'FontSize', 14)
xticks([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5])
xticklabels({'0' '1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14'})
yticks([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5 14.5])
yticklabels({'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14'})





