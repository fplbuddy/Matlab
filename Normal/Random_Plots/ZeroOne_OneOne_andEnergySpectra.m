clearvars -except AllData
run Params.m
run SomeInputStuff.m
run SetUp.m

%% mode plots
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
ICT = AllData.(ARS).(PrS).(RaS).ICT;
t = kpsmodes1(:,1); t = t(ICT:end);
ZeroOne = kpsmodes1(:,2)*2; ZeroOne = ZeroOne(ICT:end);
OneOne = sqrt((2*kpsmodes1(:,3)).^2+(2*kpsmodes1(:,5)).^2); OneOne = OneOne(ICT:end);

figure('Renderer', 'painters', 'Position', [5 5 600 200])
plot(t,ZeroOne,'-r','DisplayName','$\widehat \psi_{0,1}$'), hold on
plot(t,OneOne,'-b','DisplayName', '$|\widehat \psi_{1,1}|$')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
lgnd = legend('Location', 'Best', 'FontSize', numFS);
xlabel('$t$','FontSize',numFS);
title(['$ Ra = ' RatoRaT(Ra) '$, $Pr = ' RatoRaT(Pr) '$, $\Gamma = ' num2str(AR) '$'],'FontSize',labelFS)
saveas(gcf,[figpath 'Modes_' convertStringsToChars(PrS) '_' convertStringsToChars(RaS) '_G_' num2str(AR) '.eps'], 'epsc')

%% energy plot
nodes = 8;
type = 'ps';
Lx = AR/2;
Ly = 1;
Dkx = 1.0/Lx;
Dky = 1.0/Ly;
Res =  convertStringsToChars(AllData.(ARS).(PrS).(RaS).Res);
I = strfind(Res,'x');
nx = str2num(Res(1:I-1)); ny = str2num(Res(I+1:end));
y = zeros(round(sqrt(2.0d0)*max(nx,2*ny)/(3*min(Lx,Ly)))+1,1);% taken straight form fortran code, think this is an overestimate, which is fine
yodd = y;
yeven = y;
times = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/spec_times.txt']);
actualtimes = times(:,2);
inttimes = times(:,1);
tcut = t(1);
for i=1:length(inttimes)
    if not(tcut > actualtimes(i))
        tintcut = i;
        break
    end
end

nrm = length(tintcut:max(inttimes));

for l=tintcut:max(inttimes) % looping rund times
    l
    time = num2str(l);
    while length(time) < 4
        time = ['0' time];
    end
    
for i=0:nodes-1
    node = ['00' num2str(i)];
    data = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/' type '.' node '.' time '.txt']);
    if length(data) > 0
    kx = data(:,3); ky = data(:,4); R = data(:,1); I = data(:,2);
    for j=1:length(kx)
        kxinst = kx(j); kyinst = ky(j); mode = R(j) + 1i*I(j);
        kk2 = (kxinst*Dkx)^2 + (kyinst*Dky)^2;
        kmn = round(sqrt(kk2));
        if kmn == 0
            kmn = 1;
        end
        add = abs(mode)^2/(4*nrm); % 4 from parsevels theorem, nrm for time avergage
        if kxinst ~= 0
           add = add*2; 
        end
        if type == 'ps'
            add = add*kk2;
        end
        y(kmn) = y(kmn)+add; % add to total
        if rem(kxinst+kyinst,2) % odd mode
            yodd(kmn) = yodd(kmn)+add;
        else
            yeven(kmn) = yeven(kmn)+add;
        end       
        end
    end
end
end
for i=length(y):-1:1
    if y(end) == 0
      y(end) = [];
      yeven(end) = [];
      yodd(end) = [];
    else
        break
    end
end
%% make figures
% total
figure('Renderer', 'painters', 'Position', [5 5 600 200])
loglog(y+min(y))
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$K= \sqrt{(2k_x/\Gamma)^2 + k_y^2}$', 'FontSize',numFS)
ylabel('$(\nabla \widehat \psi_{kx,ky})^2/2 + \epsilon$', 'FontSize',numFS)
title({['$ Ra = ' RatoRaT(Ra) '$, $Pr = ' RatoRaT(Pr) '$, $\Gamma = ' num2str(AR) '$'] ,'Total spectrum'}, 'FontSize',labelFS)
yticks([1e-18 1e-16 1e-14 1e-12 1e-10 1e-8 1e-6 1e-4 1e-2 1 1e2 1e4])
saveas(gcf,[figpath 'TotalSpec_' convertStringsToChars(PrS) '_' convertStringsToChars(RaS) '_G_' num2str(AR) '.eps'], 'epsc')

% odd
figure('Renderer', 'painters', 'Position', [5 5 600 200])
loglog(yodd+min(y))
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$K= \sqrt{(2k_x/\Gamma)^2 + k_y^2}$', 'FontSize',numFS)
ylabel('$(\nabla \widehat \psi_{kx,ky})^2/2 + \epsilon$', 'FontSize',numFS)
title({['$ Ra = ' RatoRaT(Ra) '$, $Pr = ' RatoRaT(Pr) '$, $\Gamma = ' num2str(AR) '$'] ,'Odd spectrum'}, 'FontSize',labelFS)
yticks([1e-18 1e-16 1e-14 1e-12 1e-10 1e-8 1e-6 1e-4 1e-2 1 1e2 1e4])
saveas(gcf,[figpath 'OddSpec_' convertStringsToChars(PrS) '_' convertStringsToChars(RaS) '_G_' num2str(AR) '.eps'], 'epsc')

figure('Renderer', 'painters', 'Position', [5 5 600 200])
loglog(yeven+min(y))
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$K= \sqrt{(2k_x/\Gamma)^2 + k_y^2}$', 'FontSize',numFS)
ylabel('$(\nabla \widehat \psi_{kx,ky})^2/2 + \epsilon$', 'FontSize',numFS)
title({['$ Ra = ' RatoRaT(Ra) '$, $Pr = ' RatoRaT(Pr) '$, $\Gamma = ' num2str(AR) '$'] ,'Even spectrum'}, 'FontSize',labelFS)
yticks([1e-18 1e-16 1e-14 1e-12 1e-10 1e-8 1e-6 1e-4 1e-2 1 1e2 1e4])
saveas(gcf,[figpath 'EvenSpec_' convertStringsToChars(PrS) '_' convertStringsToChars(RaS) '_G_' num2str(AR) '.eps'], 'epsc')

