clearvars -except AllData
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
G = 1;
ARS = ['AR_' num2str(G)];
Pr = 30;
PrS = ['Pr_' num2str(Pr)];
Ramin = 4.5e5;
Ramax = 1.9e6;
% try without doing any moving average when finding reversal times for now
% could aslo have switch when have reached mean of absolute value. Maybe
% this is better?
%% plot a random one

%%
RaS_list = string(fieldnames(AllData.(ARS).(PrS)));
Ra_list = [];
MeanWaitingTime_list = [];
UnbiasedVarianceWaitingTime_list = [];
errorWaitingTime_list = [];
close all
for i=1:length(RaS_list)
    RaS = RaS_list(i);
    Ra = AllData.(ARS).(PrS).(RaS).Ra;
    if isfield(AllData.(ARS).(PrS).(RaS),'ICT') && Ra >= Ramin && Ra <= Ramax
        %urms = AllData.(ARS).(PrS).(RaS).urms;
        kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
        xlower = AllData.(ARS).(PrS).(RaS).ICT;
        t = kpsmodes1(:,1); t = t(xlower:end); 
        s = kpsmodes1(:,2); s = s(xlower:end);
        % non-dim
        %t = t/(pi/urms);
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
        Ra_list = [Ra_list Ra];
        MeanWaitingTime_list = [MeanWaitingTime_list mean(WaitingTimes)];
        N = length(WaitingTimes);
        UnbiasedVarianceWaitingTime_list = [UnbiasedVarianceWaitingTime_list (N/(N-1))*var(WaitingTimes)];
        errorWaitingTime_list = [errorWaitingTime_list 1.96*sqrt((1/(N-1))*var(WaitingTimes))];
        %['Ra = ' convertStringsToChars(RaS) ', N = ' num2str(N)]
        %['Ra = ' convertStringsToChars(RaS) ', steps = ' num2str(N)]
        
    end
end
%%
figure()
errorbar(Ra_list,MeanWaitingTime_list,errorWaitingTime_list,'*','MarkerSize',MS/2), hold on
title(['$Pr = ' num2str(Pr) ',\, \Gamma = ' num2str(G) '$'])
ylabel('$w//(L_y/u_{rms})$')
xlabel('$Ra$')
set(gca, 'YScale', 'log')
%set(gca, 'XScale', 'log')
saveas(gcf,[figpath 'WaitingTime'], 'epsc')