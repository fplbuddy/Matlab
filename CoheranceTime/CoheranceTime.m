run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
spath = '/Volumes/Samsung_T5/CoheranceTime/IC_S/N_256x256/Pr_1e1/Ra_8e6/step_1e2/Spectra/';
%%
spec_times = importdata([spath 'spec_times.txt']);
nums = spec_times(:,1);
t = spec_times(:,2);
t = [0; t];
Ek = importdata([spath 'Ekspectrum.0001.txt']); Ek = Ek(:,2);
Ep = importdata([spath 'Epspectrum.0001.txt']); Ep = Ep(:,2);
kmat = ones(length(Ek),length(nums)+1); % where we store data
pmat = kmat;
%%
for i=1:length(nums)
    num = num2str(nums(i));
    while length(num) < 4
       num = ['0' num];
    end
    kinst = importdata([spath 'Ekcor.' num '.txt']); kinst = kinst(:,2);
    pinst = importdata([spath 'Epcor.' num '.txt']); pinst = pinst(:,2);
    kmat(:,i+1) = kinst./Ek;
    pmat(:,i+1) = pinst./Ep;
end
%% Figure
want = 5;
cols = distinguishable_colors(want);
figure()
for i=1:want
   col = cols(i,:);
   plot(t,kmat(i,:),'DisplayName',num2str(i), 'Color',col), hold on 
end
lgnd = legend();
title(lgnd,'$K$')
xlabel('$t\,(s)$')
ylabel('$R(K,t)$')
title('$R(K,t) = <u_i(\mbox{\boldmath $K$},t)u^*_i(\mbox{\boldmath $K$},0)>/<u_i(\mbox{\boldmath $K$},0)u^*_i(\mbox{\boldmath $K$},0)>$')
saveas(gcf,[figpath 'Ekcor'], 'epsc')
%
figure()
for i=1:want
   col = cols(i,:);
   plot(t,pmat(i,:),'DisplayName',num2str(i), 'Color',col), hold on 
end
lgnd = legend();
title(lgnd,'$K$')
xlabel('$t\,(s)$')
ylabel('$R(K,t)$')
title('$R(K,t) = <\theta_i(\mbox{\boldmath $K$},t)\theta^*_i(\mbox{\boldmath $K$},0)>/<\theta_i(\mbox{\boldmath $K$},0)\theta^*_i(\mbox{\boldmath $K$},0)>$')
saveas(gcf,[figpath 'Epcor'], 'epsc')





