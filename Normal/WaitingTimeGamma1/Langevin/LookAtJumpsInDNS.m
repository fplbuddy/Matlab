run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
G = 1;
ARS = ['AR_' num2str(G)];
Pr = 30;
PrS = ['Pr_' num2str(Pr)];
Ramin = 4.5e5;
Ramax = 1.9e6;
RaS_list = string(fieldnames(AllData.(ARS).(PrS)));
Ra_list = [];
var_list = [];
dt_list = [];
for i=1:length(RaS_list)
    RaS = RaS_list(i);
    Ra = AllData.(ARS).(PrS).(RaS).Ra;
    if isfield(AllData.(ARS).(PrS).(RaS),'ICT') && Ra >= Ramin && Ra <= Ramax
        kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
        xlower = AllData.(ARS).(PrS).(RaS).ICT;
        t = kpsmodes1(:,1); t = t(xlower:end);
        s = kpsmodes1(:,2); s = s(xlower:end);
        % only pick every 10th on when Ra is different from 1.85e6 where
        % we already do this i think
        if mean(diff(t)) < 10
            t = t(1:10:end); s = s(1:10:end);
        end 
        s = abs(s);
        jumps = zeros(1,length(s)-1);
        for j=1:length(jumps)
            jumps(j) = s(j+1)-s(j);
        end
        Ra_list = [Ra_list Ra];
        var_list = [var_list var(jumps)];
        dt_list = [dt_list mean(diff(t))];
    end
end
%%
a_list = var_list./dt_list;
figure()
plot(Ra_list,a_list,'.')
%% PLAY
Ra_list = [8e5 1e6 1.1e6 1.2e6 1.3e6 1.4e6 1.5e6 1.6e6 1.7e6 1.8e6 1.85e6 1.9e6];
for i=1:length(Ra_list)
    Ra = Ra_list(i); RaS = normaltoS(Ra,'Ra',1); RaT = RatoRaT(Ra);
    kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
    xlower = AllData.(ARS).(PrS).(RaS).ICT;
    s = kpsmodes1(:,2); s = s(xlower:end);
    histogram(abs(s),100,'Normalization','pdf','DisplayName','Empirical PDF'), hold on
    
end

xlabel('$\left|\widehat \psi_{0,1}\right|$')







