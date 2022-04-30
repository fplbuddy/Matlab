% Get data and functions
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions';
addpath(fpath)
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);
%% For paper - not quite
% GS = "AR_2";
% Res_list = string(fields(Data.(GS)));
% for i = 1:length(Res_list)
%     Res = Res_list(i); Res = convertStringsToChars(Res); Res = Res(7:end);
%     Pr_list = [];
%     Ra_list = [];
%     PrS_list = string(fields(Data.(GS).(Res_list(i))));
%     for j=1:length(PrS_list)
%         PrS = PrS_list(j); Pr = PrStoPr(PrS);
%         RaS_list = string(fields(Data.(GS).(Res_list(i)).(PrS)));
%         for k=1:length(RaS_list)
%             RaS = RaS_list(k); Ra = RaStoRa(RaS);
%             Pr_list = [Pr_list Pr];
%             Ra_list = [Ra_list Ra];
%         end
%     end
%     loglog(Pr_list,Ra_list,'*','DisplayName',[num2str(Res) 'x' num2str(Res)]), hold on 
% end
% lgnd = legend('Location', 'Bestoutside', 'FontSize', FS); title(lgnd,'$Ra$', 'FontSize', FS)

%% Actual
GS = "AR_2";
types =  string(fields(Data.(GS)));
for i=1:length(types)
    type = types(i); type = convertStringsToChars(type); Res = type(7:end);
    PrS_list =  string(fields(Data.(GS).(type)));
    Pr_list = [];
    Ra_list = [];
    for j=1:length(PrS_list)
        PrS = PrS_list(j); Pr = PrStoPr(PrS);
        RaS_list = string(fields(Data.(GS).(type).(PrS)));
        for k=1:length(RaS_list)
            RaS = RaS_list(k); Ra = RaStoRa(RaS);
            Pr_list = [Pr_list Pr];
            Ra_list = [Ra_list Ra];
        end
    end
    loglog(Pr_list,Ra_list,'*','DisplayName',[num2str(Res) 'x' num2str(Res)]), hold on 
end
lgnd = legend('Location', 'Bestoutside', 'FontSize', 16); title(lgnd,'$Ra$', 'FontSize', 16)
