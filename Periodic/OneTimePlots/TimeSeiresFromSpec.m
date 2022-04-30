run /Users/philipwinchester/Dropbox/Matlab/Periodic/Plot/SetUp.m
spath = '/Volumes/Samsung_T5/Periodic/n_512/o1_1e0/o2_1e0/f_0e1/Rhnu_2e6/Pr_inf/Ra_1e7/Spectra/';

nums = 2:62;
want = 3:6;
% construct data
for w=want
    data.(['w_' num2str(w)]) = zeros(length(nums),1);
end

times = importdata([spath 'spec_times.txt']);
time = times(:,2); time = time(nums);
data.t = time;

for i=1:length(nums)
   num = nums(i);
   num = num2str(num);
   while length(num) < 4
      num = ['0' num];
   end
   spec  = importdata([spath 'PEspec' num '.txt']);
   for j=1:length(want)
      w = want(j);
      dat = data.(['w_' num2str(w)]);
      dat(i) = spec(w);
      data.(['w_' num2str(w)]) =dat;
   end
end

%loglog(data.t,data.w_3, '-o'), hold on
%loglog(data.t,data.w_4, '-o' ), hold on
%plot(data.t,data.w_5, '-o')
%semilogy(data.t,data.w_6, '-o')
%plot(data.w_4./data.w_6)

t =  data.t;
y = data.w_4;
sigma = log(y(1)/y(end))/(2*(t(1)-t(end)));

%%

for i=1:length(kappa_list)
    kappa = kappa_list(i); kappaS = kappatokappaS(kappa);
    n = n_list(i); nS = ['n_' num2str(n)];
    path = AllData.(nS).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
    spath = [path '/Spectra/'];
    times = importdata([spath 'spec_times.txt']);
    kenergy = importdata([path '/Checks/kenergy.txt']);
    t = kenergy(:,1);
    trans = AllData.(nS).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).trans;
    tcrit = t(trans);
    rem = times(:,2) < tcrit;
    for j=1:length(rem)
        if rem(j)
            times(1,:) = []; % removing outputs which are before tcrit
        end
    end
    
    for j=1:length(times)
        inst = num2str(times(j,1));
        while length(inst) < 4
            inst = ['0' inst];
        end
        flux  = importdata([spath 'PEspec' inst '.txt']);
        if j == 1
            total= flux;
        else
            total = total + flux;
        end
    end
    % take average
    Ktotal = total/length(times);
    loglog(Ktotal.*((1:length(Ktotal))').^2, '-o','LineWidth',1,'DisplayName',Pr_list(i)), hold on
end
lgnd = legend('Location', 'Best', 'FontSize', numFS);
title(lgnd,'$Pr$', 'FontSize', numFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$k = \sqrt{k_x^2 + k_y^2}$','FontSize',labelFS)
title('Potential Energy Spectrum','FontSize',labelFS)

%saveas(gcf,[figpath 'PESpec_PrComp'], 'epsc')





