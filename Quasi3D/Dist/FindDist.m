run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Ly = 0.25; Pr = 10; Ra = 8e6;
LyS = normaltoS(Ly,'Ly',1); PrS = normaltoS(Pr,'Pr',1); RaS = normaltoS(Ra,'Ra',1);
Nx = 256; Ny =256; 
NS = ['N_' num2str(Nx) 'x' num2str(Ny)];
type = 'Shearing';
IC = ['IC_' type(1)];
path = '/Volumes/Samsung_T5/ForDist/IC_S/N_256x256/Pr_1e1/Ra_8e6/Ly_2_5e_1/dt_5e_4';
kenergy2 = importdata([path '/Checks/kenergy2.txt']);
%% single step size
% ansatz: S_{n+1} = S_(n)e^w, w ~ N(aT,bT).
t = kenergy2(:,1);
S = kenergy2(:,2);
d = diff(t);
w = zeros(1,length(d));
% getting w values. Only when step is d(1) though
for i=1:length(d)
   if abs(d(i) - d(1)) < 1e-5
      w(i) = log(S(i+1)/S(i));
   end
end
m1 = mean(w);
v1 = var(w);

dt = [d(1)];
m = [m1];
v = [v1];

%% make plots in first case

figure()
histogram(w), hold on
xlabel('$\log({\frac{<\nabla\psi_{3D})^2>(t+\Delta t)}{<\nabla\psi_{3D})^2>(t)}})$','FontSize',labelFS)
title(['$\Delta t = dt = ' num2str(dt) '$'])
%saveas(gcf,[figpath 'Histogram1'], 'epsc')
stip
wtest = (w - m1)/sqrt(v1);
%[h,p] = kstest(wtest)
figure()
cdfplot(wtest)
hold on
x_values = linspace(min(wtest),max(wtest));
plot(x_values,normcdf(x_values,0,1),'r-')
legend('Empirical CDF','Standard Normal CDF','Location','best')
%saveas(gcf,[figpath 'CDF_1'], 'epsc')

figure()
cdfplot(wtest)
hold on
x_values = linspace(min(wtest),max(wtest));
plot(x_values,normcdf(x_values,0,1),'r-')
legend('Empirical CDF','Standard Normal CDF','Location','best')
ylim([0.4 0.6])
%saveas(gcf,[figpath 'CDF_2'], 'epsc')


%% find mean and variance for for different step sizes
for i=2:20
    t = kenergy2(:,1);
    S = kenergy2(:,2);
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

figure()
histogram(w)
xlabel('$\log({\frac{<\nabla\psi_{3D})^2>(t+\Delta T)}{<\nabla\psi_{3D})^2>(t)}})$','FontSize',labelFS)
title(['$\Delta t =' num2str(d(1)) '$'])
%saveas(gcf,[figpath 'Histogram2'], 'epsc')


%% make plots in second case
figure()
plot(dt,m,'-o')
xlabel('$\Delta t$','FontSize',labelFS)
ylabel('Mean','FontSize',labelFS)
%saveas(gcf,[figpath 'mean'], 'epsc')

figure()
plot(dt,v,'-o'), hold on
xlabel('$\Delta t$','FontSize',labelFS)
ylabel('Variance','FontSize',labelFS)
%saveas(gcf,[figpath 'variance'], 'epsc')




