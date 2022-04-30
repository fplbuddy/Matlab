addpath('/Users/philipwinchester/Dropbox/Matlab/GeneralFuncs')
run SetUp.m
dpath = '/Volumes/Samsung_T5/OldData/LangevinData.mat';
load(dpath)
%% Parameters
m = 1;
dt = 0.005;
% potential is v(x) = a(c^2-x^2)^2, where c is where steady state is.
% So negative of gradient of potential is 4ax(c^2-x^2). Is is sort of
% gravitational potenteil strength
%c = 1;
%
%% numerical intergration
steps = 1e8; % just set equalt to some large number
stepsmin = 1e6;
c_list = 1:10;
p = 2;
n = 0;
pS = normaltoS(p,'p',1);
nS = normaltoS(n,'n',1);
revswant = 20;
progstep = 0.1;
D = 1;
d = 2;
DS = normaltoS(D,'D',1);
dS = normaltoS(d,'d',1);
B = 10;
b = 1;
BS = normaltoS(B,'B',1);
bS = normaltoS(b,'b',1);
close all
%c_list = 1;
for j=1:length(c_list)
    c = c_list(j);
    disp(['c is: ' num2str(c)]) 
    a = p/c^n;
    cS = normaltoS(c,'c',1);
    v = zeros(1,steps);
    x = zeros(1,steps);
    F = zeros(1,steps);
    x(1) = c;
    v(1) = 0;
    Status = sign(x(1));
    WaitingTimes = [1];
    prog = progstep;
    revs = 0;
    i = 1;
    kt = D*c^d;
    beta = B*c^(-b);
    B1var = (3*kt/m)*(1-exp(-2*beta*dt));
    B2var = (6*kt/(m*beta^2))*(beta*dt-2*(1-exp(-beta*dt))/(1+exp(-beta*dt)));
    
    revscheck = revs < revswant || i < stepsmin;
    
    while revscheck && i < steps
    %while i < steps 
    i = 1+i;
%          if i/steps > prog
%              disp(['Prog is: ' num2str(prog*100) '%'])
%              prog = prog + progstep;
%          end
        F(i-1) = 4*a*x(i-1)*(c^2-x(i-1)^2);
        B1 = normrnd(0,sqrt(B1var));
        v(i) = v(i-1)*exp(-beta*dt)+(F(i-1)/(m*beta))*(1-exp(-beta*dt)) + B1;
        B2 = normrnd(0,sqrt(B2var));
        x(i) = x(i-1) + (1/beta)*(v(i)+v(i-1)-2*F(i-1)/(m*beta))*(1-exp(-beta*dt))/(1+exp(-beta*dt))+F(i-1)*dt/(m*beta)+B2;
         if Status == 1 % we are positive and going negative
            if x(i) < -c % we have switched!
                Status = -1;
                WaitingTimes = [WaitingTimes i];
                revs = 1+revs;
                disp(['We have: ' num2str(revs) ' revs at c = ' num2str(c)])
            end
        else % we are negative and going posiive
            if x(i) > c % we have switched!
                Status = 1;
                WaitingTimes = [WaitingTimes i];
                revs = 1+revs;
                disp(['We have: ' num2str(revs) ' revs at c = ' num2str(c)])
            end
         end 
     revscheck = revs < revswant || i < stepsmin;
    end
    x(i+1:end) = [];
    histogram(abs(x),100,'Normalization','pdf','DisplayName','Empirical PDF'), hold on
    % now we have the time series, need to find reversals, could put this
    % in loop above
     WaitingTimes = diff(WaitingTimes);
     LangevinData.(BS).(bS).(DS).(dS).(pS).(nS).(cS).WaitingTimes = mean(WaitingTimes)*dt;
     LangevinData.(BS).(bS).(DS).(dS).(pS).(nS).(cS).c = c;
     LangevinData.(BS).(bS).(DS).(dS).(pS).(nS).(cS).revs = revs;
     LangevinData.(BS).(bS).(DS).(dS).(pS).(nS).(cS).T = i*dt;
end
save(dpath,'LangevinData');
%% Plot time series
figure()
plot((1:length(x))*dt,x)
xlim([0 2e4])
title('$V(x) = \frac{2}{5^3}(5^2-x^2)^2$')
xlabel('$t$')
ylabel('$x$')

%% plot
close all
figure()
% B = 10;
% b = 0.5;
% BS = normaltoS(B,'B',1);
% bS = normaltoS(b,'b',1);
cS_list = string(fields(LangevinData.(BS).(bS).(DS).(dS).(pS).(nS)));
for i=1:length(cS_list)
   cS = cS_list(i);
   semilogy(LangevinData.(BS).(bS).(DS).(dS).(pS).(nS).(cS).c,LangevinData.(BS).(bS).(DS).(dS).(pS).(nS).(cS).WaitingTimes,'b.'), hold on
end
% b = 0.5;
% bS = normaltoS(b,'b',1);
% cS_list = string(fields(LangevinData.(BS).(bS).(DS).(dS).(pS).(nS)));
% for i=1:length(cS_list)
%    cS = cS_list(i);
%    loglog(LangevinData.(BS).(bS).(DS).(dS).(pS).(nS).(cS).c,LangevinData.(BS).(bS).(DS).(dS).(pS).(nS).(cS).WaitingTimes,'r.'), hold on
% end

title(['$n =' num2str(n) '$'])
xlabel('$c$')
ylabel('$\bar{\tau}$')
%saveas(gcf,[figpath 'LogWaitingTime_' nS], 'epsc')

