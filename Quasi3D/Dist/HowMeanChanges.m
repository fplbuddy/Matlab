pathlarge = '/Volumes/Samsung_T5/ForDist/IC_S/N_256x256/Pr_1e1/Ra_8e6/Ly_2_5e_1/dt_2_5e_1';
kenergy2large = importdata([pathlarge '/Checks/kenergy2.txt']);
tot = length(kenergy2large)/1000;
% check growth rate variance
alpha_list = zeros(tot,1);
t = kenergy2large(:,1);
S = kenergy2large(:,2);
for i=1:tot
    [alpha, ~, ~, ~, ~] = Fitslogy(t(1+(1000)*(i-1):1000*i),S(1+(1000)*(i-1):1000*i));
    alpha_list(i) = alpha;
end
figure()
histogram(alpha_list)
xlabel('Exponent')
title('Partial exponent for 1000 steps with $\Delta t = 0.25$')
saveas(gcf,[figpath 'PartialExp'], 'epsc')

%% check variance variance
% v  = zeros(m-1,1);
% d = diff(t);
% w = zeros(1,length(d));
% for j=1:length(d)
%     if abs(d(j) - d(1)) < 1e-5
%         w(j) = log(S(j+1)/S(j));
%     end
% end
% for i=1:m-1
%     v(i) = var(w(1+(1000)*(i-1):1000*i));
% end
% histogram(v)


%% check mean
m  = zeros(tot-1,1);
d = diff(t);
w = zeros(1,length(d));
for j=1:length(d)
    if abs(d(j) - d(1)) < 1e-5
        w(j) = log(S(j+1)/S(j));
    end
end
for i=1:tot-1
    m(i) = mean(w(1+(1000)*(i-1):1000*i));
end
figure()
histogram(m)
xlabel('mean')
title('mean off 1000 samples with $\Delta t = 0.25$')
