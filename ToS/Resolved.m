run SetUp.m
figure('Renderer', 'painters', 'Position', [5 5 1000 300])

%% 128x128
path = '/Volumes/Samsung_T5/res/128x128/Pr_10/Ra_2e8';
spectimes = importdata([path '/Spectra/spec_times.txt']);
times = spectimes(:,1);
for i=1:length(times)
   num = times(i); num = num2str(num);
   while length(num) < 4
    num = ['0' num];
   end
   add = importdata([path '/Spectra/Epspectrum.' num '.txt']);
   if i == 1
       av = add(:,2);
       k = add(:,1);
   else
       av = av + add(:,2);
   end
end
av = av/length(times);
subplot(1,3,1)
semilogy(k,av.*k.^2),  hold on
[m, i] = min(av);
xlim([1 i]);
ylim([1e-5 1e-1])
yticks([1e-5 1e-3 1e-1])
m = max(av.*k.^2);
plot([1 i], [m m], 'black--')
plot([1 i], [m/100 m/100], 'black--')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$K^2 \times \widehat E^{\theta}(K)$','FontSize', LabelFS)
title('$N_x \times N_y = 128 \times 128$', 'FontSize', TitleFS)
xlabel('$K$', 'FontSize', LabelFS)
hold off
%% 256x256
path = '/Volumes/Samsung_T5/res/256x256/Pr_10/Ra_2e8';
spectimes = importdata([path '/Spectra/spec_times.txt']);
times = spectimes(:,1);
for i=1:length(times)
   num = times(i); num = num2str(num);
   while length(num) < 4
    num = ['0' num];
   end
   add = importdata([path '/Spectra/Epspectrum.' num '.txt']);
   if i == 1
       av = add(:,2);
       k = add(:,1);
   else
       av = av + add(:,2);
   end
end
av = av/length(times);
subplot(1,3,2)
semilogy(k,av.*k.^2),  hold on
title('$256 \times 256$', 'FontSize', TitleFS)
[m, i] = min(av);
xlim([1 i]);
ylim([1e-5 1e-1])
yticks([1e-5 1e-3 1e-1])
m = max(av.*k.^2);
plot([1 i], [m m], 'black--')
plot([1 i], [m/100 m/100], 'black--')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$K$', 'FontSize', LabelFS)
hold off

%% 512x512
path = '/Volumes/Samsung_T5/AR_2/512x512/Pr_10/Ra_2e8';
spectimes = importdata([path '/Spectra/spec_times.txt']);
times = spectimes(:,1);
for i=1:length(times)
   num = times(i); num = num2str(num);
   while length(num) < 4
    num = ['0' num];
   end
   add = importdata([path '/Spectra/Epspectrum.' num '.txt']);
   if i == 1
       av = add(:,2);
       k = add(:,1);
   else
       av = av + add(:,2);
   end
end
av = av/length(times);
subplot(1,3,3)
semilogy(k,av.*k.^2),  hold on
title('$512 \times 512$', 'FontSize', TitleFS)
[m, i] = min(av);
xlim([1 i]);
ylim([1e-7 1e-1])
yticks([1e-7 1e-5 1e-3 1e-1])
m = max(av.*k.^2);
plot([1 i], [m m], 'black--')
plot([1 i], [m/100 m/100], 'black--')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$K$', 'FontSize', LabelFS)
hold off
