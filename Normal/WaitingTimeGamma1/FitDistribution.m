run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
G = 1;
ARS = ['AR_' num2str(G)];
Pr = 30;
PrS = ['Pr_' num2str(Pr)];
Ra = 5e5; RaS = normaltoS(Ra,'Ra',1); RaT = RatoRaT(Ra);


kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
xlower = AllData.(ARS).(PrS).(RaS).ICT;
t = kpsmodes1(:,1); t = t(xlower:end);
s = kpsmodes1(:,2); s = s(xlower:end);
thresh = mean(abs(s));
Status = sign(s(1));
timesSwitch = [t(1)];
for j=2:length(s)
    if Status == 1 % we are positive and going negative
        if s(j) < -thresh % we have switched!
            Status = -1;
            timesSwitch = [timesSwitch t(j)];
        end
    else % we are negative and going posiive
        if s(j) > thresh % we have switched!
            Status = 1;
            timesSwitch = [timesSwitch t(j)];
        end
    end
    
end
WaitingTimes = diff(timesSwitch);
Mean = mean(WaitingTimes); 
w0 = min(WaitingTimes);
lambda = 1/(Mean-w0);


%% make plots
% PDF
n = 1000;
figure()
histogram(WaitingTimes,14,'Normalization','pdf','DisplayName','Empirical PDF'), hold on
x_list = linspace(0,max(WaitingTimes),n);
y_list = lambda*exp(-lambda*(x_list-w0));
plot(x_list,y_list,'-r','DisplayName','Exponential fit');
legend()
title(['$Ra = ' RaT ',\, Pr = ' num2str(Pr) ',\, \Gamma = ' num2str(G) '$'])
xlabel('$w\,(s)$')
saveas(gcf,[figpath 'G_1_PDF'], 'epsc')
%% CDF
figure()
cdf_empirical = zeros(n,1);
for i=1:n
    x = x_list(i); 
    for j=1:length(WaitingTimes)
        if WaitingTimes(j) <= x
            cdf_empirical(i) = cdf_empirical(i) + 1;
        end
    end
end
N = length(WaitingTimes);
cdf_empirical = cdf_empirical/N;
plot(x_list,cdf_empirical,'-b','DisplayName','Empirical CDF'), hold on
y_list = 1 - exp(-lambda*(x_list-w0));
plot(x_list,y_list,'--r','DisplayName','Exponential fit')
%plot 95% confidenc interval
epsilon = sqrt((1/(2*N))*log(2/0.95));
plot(x_list,cdf_empirical+epsilon,':b','DisplayName','95\% Empirical Conf Interval')
plot(x_list,cdf_empirical-epsilon,':b','HandleVisibility','off')
xlabel('$w\,(s)$')
ylabel('CDF$(w)$')
legend()
title(['$Ra = ' RaT ',\, Pr = ' num2str(Pr) ',\, \Gamma = ' num2str(G) '$'])

ylim([0 1])
saveas(gcf,[figpath 'G_1_CDF'], 'epsc')
% I think my way round (ML style) is the correct way of doing it. The
% empirocal CDF confidenc interval just tells that we are 95% sure that cdf
% will be in some region. Regin will be biggest with LESS data points. Thin
% we want to have the same distribution as they do, (shifted exponential)
% but do confidenc bands as we have done here. Set t0 equal to the minimum
% waiting time we have. Get range for mean by central limit theorem, and then make ansatz for
% probability distribution. 
% Ot mabye his version is better actually... if n is large enough, then it
% does tell us something useful! 

