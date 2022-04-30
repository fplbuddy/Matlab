run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
path = '/Volumes/Samsung_T5/AR_2/1024x512/Pr_0_1/Ra_2e9/Checks/';
tit = '$Ra = 2 \times 10^9 ,\, Pr =  6\times10^{-1}$';
%tlower = 1e4;

%%
penergy = importdata([path 'penergy.txt']);
kenergy = importdata([path 'kenergy.txt']);

%% Get lines where we have spectra
path = '/Volumes/Samsung_T5/AR_2/1024x512/Pr_0_6/Ra_2e9/Spectra/';
times = importdata([path 'spec_times.txt']);
times = times(:,2);

%%
figure('Renderer', 'painters', 'Position', [5 5 540 400])
subplot(2,1,1)
plot(kenergy(:,1), kenergy(:,2)), hold on
ylabel('$<(\nabla \psi)^2 >$','FontSize',labelFS)
for i=1:length(times)
   plot([times(i) times(i)], [min(kenergy(:,2)) max(kenergy(:,2))],'r--')
end

ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([tlower,max(kenergy(:,1))])

subplot(2,1,2)
plot(penergy(:,1), penergy(:,2)), hold on
for i=1:length(times)
   plot([times(i) times(i)], [min(penergy(:,2)) max(penergy(:,2))],'r--')
end
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$<\theta^2>$','FontSize',labelFS)
xlabel('$t\,  (s)$','FontSize',labelFS)
xlim([tlower,max(penergy(:,1))])
sgtitle(tit, 'FontSize',labelFS)