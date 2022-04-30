dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);
%%
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
%clearvars -except AllData Data NewData
Pr = 0.21;
type = "OneOne152";
AR = 'AR_2';
PrS = PrtoPrS(Pr);
RaS_list = string(fieldnames(Data.(AR).(type).(PrS)));
RaS_list = OrderRaS_list(RaS_list);
Ra_list = zeros(1,length(RaS_list));
max_list = zeros(1,length(RaS_list));
for i = 1:length(RaS_list)
    RaS = RaS_list(i);
    Ra_list(i) = RaStoRa(RaS);
    sigma = Data.(AR).(type).(PrS).(RaS).sigmaodd;
    max_list(i) = max(real(sigma));
end
figure()
plot(Ra_list,max_list, '-o')