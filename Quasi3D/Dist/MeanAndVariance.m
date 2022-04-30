%% Loading data
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
pathsmall = '/Volumes/Samsung_T5/ForDist/IC_S/N_256x256/Pr_1e1/Ra_8e6/Ly_2_5e_1/dt_5e_4';
kenergy2small = importdata([pathsmall '/Checks/kenergy2.txt']);
kenergysmall = importdata([pathsmall '/Checks/kenergy.txt']);
pathlarge = '/Volumes/Samsung_T5/ForDist/IC_S/N_256x256/Pr_1e1/Ra_8e6/Ly_2_5e_1/dt_2_5e_1';
kenergy2large = importdata([pathlarge '/Checks/kenergy2.txt']);
%% Getting mean and variance data from small
m = [];
v = [];
dt = [];
for i=1:499
    t = kenergy2small(:,1);
    S = kenergy2small(:,2);
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
    m = [m mean(w)];
    v = [v var(w)];
    dt = [dt d(1)];
end
%% Getting mean and variance data from large
for i=1:30
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
    m = [m mean(w)];
    v = [v var(w)];
    dt = [dt d(1)];
end
%% making figures
figure()
plot(dt,m,'-o','MarkerSize',MS/3), hold on
plot([0.25 0.25], [min(m) max(m)], '--r')
xlabel('$\Delta t$')
ylabel('Mean')
saveas(gcf,[figpath 'mean2'], 'epsc')
figure()
plot(dt,v,'-o','MarkerSize',MS/3), hold on
plot([0.25 0.25], [min(v) max(v)], '--r')
xlabel('$\Delta t$')
ylabel('Variance')
saveas(gcf,[figpath 'variance2'], 'epsc')
figure()
plot(dt,sqrt(v),'-o','MarkerSize',MS/3), hold on 
plot([0.25 0.25], [min(sqrt(v)) max(sqrt(v))], '--r')
xlabel('$\Delta t$')
ylabel('Standard Deviation')
saveas(gcf,[figpath 'StanDev2'], 'epsc')