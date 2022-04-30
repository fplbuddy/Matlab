%% Loading data
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
pathsmall = '/Volumes/Samsung_T5/ForDist/IC_S/N_256x256/Pr_1e1/Ra_8e6/Ly_2_5e_1/dt_5e_4';
kenergy2small = importdata([pathsmall '/Checks/kenergy2.txt']);
kenergysmall = importdata([pathsmall '/Checks/kenergy.txt']);
pathlarge = '/Volumes/Samsung_T5/ForDist/IC_S/N_256x256/Pr_1e1/Ra_8e6/Ly_2_5e_1/dt_2_5e_1';
kenergy2large = importdata([pathlarge '/Checks/kenergy2.txt']);
%% get w vector small
t = kenergy2small(:,1);
S = kenergy2small(:,2);
t = t(1:end);
S = S(1:end);
d = diff(t);
wsmall = zeros(1,length(d));
% getting w values. Only when step is d(1) though
for j=1:length(d)
   if abs(d(j) - d(1)) < 1e-5
      wsmall(j) = log(S(j+1)/S(j));
   end
end
figure()
plot(wsmall,'-o','MarkerSize',MS/3);
dt = diff(t);
dt = dt(1);
ylabel('$\log({\frac{<(\nabla\psi_{3D})^2>_{(1+i)\Delta t}}{<(\nabla\psi_{3D})^2>_{i\Delta t}}})$')
xlabel('$i$')
title(['$\Delta t =' num2str(dt) '$'])
xlim([1 100]);
saveas(gcf,[figpath 'TimeStepTSSmall'], 'epsc')

%% get w vector large
t = kenergy2large(:,1);
S = kenergy2large(:,2);
t = t(1:end);
S = S(1:end);
d = diff(t);
wlarge = zeros(1,length(d));
% getting w values. Only when step is d(1) though
for j=1:length(d)
   if abs(d(j) - d(1)) < 1e-5
      wlarge(j) = log(S(j+1)/S(j));
   end
end
figure()
plot(wlarge,'-o','MarkerSize',MS/3);
dt = diff(t);
dt = dt(1);
ylabel('$\log({\frac{<(\nabla\psi_{3D})^2>_{(1+i)\Delta t}}{<(\nabla\psi_{3D})^2>_{i\Delta t}}})$')
xlabel('$i$')
title(['$\Delta t =' num2str(dt) '$'])
xlim([1 100]);
saveas(gcf,[figpath 'TimeStepTSLarge'], 'epsc')

%% get w vector even large
step = 11;
t = kenergy2large(:,1);
S = kenergy2large(:,2);
t = t(1:11:end);
S = S(1:11:end);
d = diff(t);
wlarge = zeros(1,length(d));
% getting w values. Only when step is d(1) though
for j=1:length(d)
   if abs(d(j) - d(1)) < 1e-5
      wlarge(j) = log(S(j+1)/S(j));
   end
end
figure()
plot(wlarge,'-o','MarkerSize',MS/3);
dt = diff(t);
dt = dt(1);
ylabel('$\log({\frac{<(\nabla\psi_{3D})^2>_{(1+i)\Delta t}}{<(\nabla\psi_{3D})^2>_{i\Delta t}}})$')
xlabel('$i$')
title(['$\Delta t =' num2str(dt) '$'])
xlim([1 100]);
saveas(gcf,[figpath 'TimeStepTSEvenLarge'], 'epsc')




%% play 1
close all
stepmax = 100;
autocor1 = zeros(stepmax,1);
for i=1:stepmax
    t = kenergy2large(:,1);
    S = kenergy2large(:,2);
    t = t(1:i:end);
    S = S(1:i:end);
    d = diff(t);
    w = zeros(1,length(d));
    % getting w values. Only when step is d(1) though
    for j=1:length(d)
       if abs(d(j) - d(1)) < 1e-5
          w(j) = log(S(j+1)/S(j));
       end
    end
    [acf,~, ~] =  autocorr(w);
    autocor1(i) = acf(2);
end
plot(autocor1,'-o','MarkerSize',MS/3)
saveas(gcf,[figpath 'AutoCor'], 'epsc')

%% play 2
n = 100000;
listnum = zeros(n,1);
for i=1:2:n-1
    listnum(i) = randi(1000);
    %listnum(i+1) = listnum(i);
    listnum(i+1) = randi(1000);
end
close all
autocorr(listnum,'Numlags', 100)
