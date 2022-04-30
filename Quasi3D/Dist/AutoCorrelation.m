%% Load data
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
path = '/Volumes/Samsung_T5/ForDist/IC_S/N_256x256/Pr_1e1/Ra_8e6/Ly_2_5e_1/dt_2_5e_1';
kenergy2 = importdata([path '/Checks/kenergy2.txt']);
%% Get w qith i = 1
t = kenergy2(:,1);
S = kenergy2(:,2);
t = t(1:end);
S = S(1:end);
d = diff(t);
w = zeros(1,length(d));
% getting w values. Only when step is d(1) though
for j=1:length(d)
   if abs(d(j) - d(1)) < 1e-5
      w(j) = log(S(j+1)/S(j));
   end
end
figure()
autocorr(w,'numlags', 20)
xlabel('Lag ($k$)')
title(['$\Delta t =' num2str(d(1)) '$'])
saveas(gcf,[figpath 'AutoCorr'], 'epsc')
%% Do my other test
n = 50;
rat = zeros(n,1);
dt_list = zeros(n,1);
for i=1:n
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
dw = diff(w);
rat(i) = var(dw)/var(w);
dt_list(i) = d(i);
end
close all
plot(dt_list,rat)
xlabel("$\Delta t$")
ylabel('$\frac{var(W_{t+\Delta t}-W_{t})}{var(W_{t})}$')
title('$w_t(\Delta t) = \log({\frac{<\nabla\psi_{3D})^2>(t+\Delta T)}{<\nabla\psi_{3D})^2>(t)}})$')
saveas(gcf,[figpath 'VarCheck'], 'epsc')
