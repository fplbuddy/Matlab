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
c_list = [];
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
        c = mean(abs(s));
        Ra_list = [Ra_list Ra];
        c_list = [c_list c];
        %['Ra = ' convertStringsToChars(RaS) ', N = ' num2str(N)]
        %['Ra = ' convertStringsToChars(RaS) ', steps = ' num2str(N)]
        
    end
end
%%
figure()
[Ra_list,I] = sort(Ra_list);
c_list = c_list(I);
plot(Ra_list,c_list,'*','MarkerSize',MS/2), hold on
title(['$Pr = ' num2str(Pr) ',\, \Gamma = ' num2str(G) '$'])
ylabel('$c$')
xlabel('$Ra$')
%set(gca, 'YScale', 'log')
%set(gca, 'XScale', 'log')

[alpha, A, xFitted, yFitted, Rval] = FitsPowerLaw(Ra_list(3:end),c_list(3:end)); 
plot(xFitted,yFitted,'r--')
xlim([Ramin, Ramax])