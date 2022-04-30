%% Loading data
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
dt = 5e-3; dtS = normaltoS(dt,'dt',1);
Gy = 0.25; GyS = normaltoS(Gy,'Ly',1);
Ly = pi*Gy;
Ra = 8e6; RaS = normaltoS(Ra,'Ra',1);
Pr = 10; PrS = normaltoS(Pr,'Pr',1);
nu = sqrt(pi^3*Pr/Ra);
path = ['/Volumes/Samsung_T5/ForDist/IC_S/N_256x256/' PrS '/' RaS '/'  GyS '/' dtS];
kenergy2 = importdata([path '/Checks/kenergy2.txt']);
penergy2 = importdata([path '/Checks/penergy2.txt']);
t = kenergy2(:,1);
kenergy2 = kenergy2(:,2);
penergy2 = penergy2(:,2);
spath = [path '/Spectra/'];
spec_times = importdata([spath 'spec_times.txt']);
nums = spec_times(:,1);
times = spec_times(:,2);
nx = 256; ny = 256;
xr = floor(nx*sqrt(1/9-1/(4*ny)^2)) + 1; % kxmax +1 in cdoe
yr = floor(2*ny/3); % kymax in code. Does not have the +1 here which it does in some other versions of the cde



%% get data
for i=1:length(nums)
    i
    num = num2str(nums(i));
    while length(num) < 4
        num = ['0' num];
    end
    % get data
    fid = fopen([spath '2Dspectrum3Dfield_KE.' num '.out'],'r'); fread(fid,1, 'real*4');
    psiperp = fread(fid,inf, 'real*8');
    fclose(fid);
    fid = fopen([spath '2Dspectrum3Dfield_PE.' num '.out'],'r'); fread(fid,1, 'real*4');
    thetav = fread(fid,inf, 'real*8');
    fclose(fid);
    % get what we normalise with 
    time = times(i);
    [~,I] = min(abs(t-time));
    kenN = kenergy2(I);
    penN = penergy2(I);
    if i == 1
        psiperp_total = psiperp/kenN;
        thetav_total = thetav/penN;
    else
        psiperp_total = psiperp_total + psiperp/kenN;
        thetav_total = thetav_total + thetav/penN;   
    end
end
psiperp_total = psiperp_total/length(nums);
thetav_total = thetav_total/length(nums);

%% Enegy prop that we have
% sorting according to max energy in thetav
[thetav_total_sort,I] = sort(thetav_total,'descend');
psiperp_total_sort = psiperp_total(I);
modesmax = 100;
KE_prop = zeros(modesmax,1);
PE_prop = zeros(modesmax,1);
for i=1:modesmax
    KE_prop(i) = sum(psiperp_total_sort(1:i));
    PE_prop(i) = sum(thetav_total_sort(1:i));
end
figure()
plot(KE_prop,'-o','MarkerSize',10,'DisplayName', 'Kinetic Energy'), hold on
plot(PE_prop,'-o','MarkerSize',10,'DisplayName', 'Potential Energy');
legend()
xlim([1 modesmax])
xlabel('Number of modes')
ylabel('Energy Fraction')

saveas(gcf,[figpath 'EnergyFraction'], 'epsc')

%% pcolour figures 
figure()
psiperp_total = reshape(psiperp_total,xr,yr); psiperp_total = psiperp_total';
pcolor(psiperp_total)
colorbar()
caxis([1e-4 1])
set(gca,'ColorScale','log')
colormap('jet')
xlim([1 11])
ylim([1 11])
xlabel('$k_x$')
ylabel('$k_y$')
l = 3:2:40; l = l/2;
xticks(l)
xticklabels({'$0$' '$1$' '$2$' '$3$' '$4$' '$5$' '$6$' '$7$' '$8$' '$9$'})
yticks(l)
yticklabels({'$1$' '$2$' '$3$' '$4$' '$5$' '$6$' '$7$' '$8$' '$9$' '$10$' '$11$' '$12$' '$13$' '$14$' '$15$' '$16$' '$17$' '$18$' '$19$'})
title('$|K_{k_x,k_y} \widehat \psi^{\perp}_{k_x,k_y}|^2/\sum|K_{k_x,k_y} \widehat \psi^{\perp}_{k_x,k_y}|^2 $')
saveas(gcf,[figpath 'ModesKE'], 'epsc')
%
figure()
thetav_total = reshape(thetav_total,xr,yr); thetav_total = thetav_total';
pcolor(thetav_total)
colorbar()
caxis([1e-4 1])
set(gca,'ColorScale','log')
colormap('jet')
xlim([1 11])
ylim([1 11])
xlabel('$k_x$')
ylabel('$k_y$')
l = 3:2:40; l = l/2;
xticks(l)
xticklabels({'$0$' '$1$' '$2$' '$3$' '$4$' '$5$' '$6$' '$7$' '$8$' '$9$'})
yticks(l)
yticklabels({'$1$' '$2$' '$3$' '$4$' '$5$' '$6$' '$7$' '$8$' '$9$' '$10$' '$11$' '$12$' '$13$' '$14$' '$15$' '$16$' '$17$' '$18$' '$19$'})
title('$|\widehat \theta^{\perp}_{k_x,k_y}|^2/\sum|\widehat \theta^{\perp}_{k_x,k_y}|^2 $')
saveas(gcf,[figpath 'ModesPE'], 'epsc')