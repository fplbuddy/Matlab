addpath('/Users/philipwinchester/Dropbox/Matlab/Periodic/Plot')
run SetUp.m
%%
nu = 3e-3; nuS = nutonuS(nu);
path = '/Volumes/Samsung_T5/Periodic_Vold/n_256/NV3';
spath = [path '/Spectra/'];
times = importdata([spath 'spec_times.txt']);
kenergy = importdata([path '/Checks/kenergy.txt']);
t = kenergy(:,1);
trans = 2;
tcrit = t(trans);
rem = times(:,2) < tcrit;
for i=1:length(rem)
   if rem(i)
       times(1,:) = []; % removing outputs which are before tcrit
   end
end
%% Calculate Energy Flux
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    flux  = importdata([spath 'vectrans_euu.' inst '.txt']); % Getting a vectrans instance
    if i == 1
        total = flux; % Initiating total
    else
       total = total + flux; % Added to total
    end
end

total = total/length(times); % Take average 

result = zeros(length(total),1);
for i=1:length(total)
   result(i) = sum(total(1:i-1)); % Calculating partial sums
end

%% Find what to normalise with 
fin = kenergy(:,4);
t = kenergy(:,1);
t = t(trans:end);
fin = fin(trans:end);
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions')
fav = MyMeanEasy(fin,t);

%% plot
figure('Renderer', 'painters', 'Position', [5 5 540 300])
%semilogx(k_list,Kresult/fav, 'b-o'), hold on
semilogx(0:length(result)-1,result, 'b-o')
%ylabel('$  \Pi_E/\overline{\langle  u\cdot f \rangle}$', 'FontSize',labelFS )
ylabel('$  \Pi_E$', 'FontSize',labelFS )
xlim([1 100])
xlabel('$k = \sqrt{k_x^2 + k_y^2}$')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
nuS = convertStringsToChars(nuS);
title('NV 3', 'FontSize',labelFS)
saveas(gcf,[figpath 'VOFlux_' nuS], 'epsc')




