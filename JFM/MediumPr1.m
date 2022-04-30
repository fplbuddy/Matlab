run SetUp.m
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);
%%
%Pr_list = [0.2 0.206 0.212 0.217];
Pr_list = [0.212];
figure('Renderer', 'painters', 'Position', [5 5 500 300])

for i=1:length(Pr_list)
    Pr = Pr_list(i);
    PrS = PrtoPrS(Pr);
    sig_list = [];
    Ra_list = [];
    RaS_list = string(fields((Data.AR_2.OneOne152.(PrS))));
    for j=1:length(RaS_list)
        RaS = RaS_list(j);
        Ra = RaStoRa(RaS);
        sig = max(real(Data.AR_2.OneOne152.(PrS).(RaS).sigmaodd));
        Ra_list = [Ra_list Ra];
        sig_list = [sig_list sig];
    end
    [Ra_list, I] = sort(Ra_list);
    sig_list = sig_list(I);
    plot(Ra_list,sig_list,'-o'), hold on 
end