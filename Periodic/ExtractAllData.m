clearvars -except Data
addpath('/Users/philipwinchester/Dropbox/Matlab/Periodic/Functions')
%%
Mpath = '/Volumes/Samsung_T5/Periodic';
cd /Volumes/Samsung_T5/Periodic
% finding the resolutions we have
AllFolders = dir(Mpath);
AllFolders = extractfield(AllFolders,'name');
res_list = [];
for k = 1:length(AllFolders)
    if strncmp("n",AllFolders(k),1)
        res_list = [res_list AllFolders(k)]; % Finding which Re have
    end
end
res_list = string(res_list);
for i=1:length(res_list)
    res =  convertStringsToChars(res_list(i));
    path = [Mpath '/' res];
    AllFolders = dir(path);
    AllFolders = extractfield(AllFolders,'name');
    PrS_list = [];
    for k = 1:length(AllFolders)
        if strncmp("P",AllFolders(k),1)
            PrS_list = [PrS_list AllFolders(k)]; % Finding which Re have
        end
    end
    PrS_list = string(PrS_list);
    for j=length(PrS_list)
        PrS = convertStringsToChars(PrS_list(j));
        path = [path '/' PrS];
        AllFolders = dir(path);
        AllFolders = extractfield(AllFolders,'name');
        RaS_list = [];
        for k = 1:length(AllFolders)
            if strncmp("R",AllFolders(k),1)
                RaS_list = [RaS_list AllFolders(k)]; % Finding which Re have
            end
        end
        RaS_list = string(RaS_list);
        for l=1:length(RaS_list)
           RaS = convertStringsToChars(RaS_list(l));
           Ra = RaStoRa(RaS); Pr = RaStoRa(PrS);
           AllData.(res).(PrS).(RaS).Ra =  Ra;
           AllData.(res).(PrS).(RaS).Pr =  Pr;
           AllData.(res).(PrS).(RaS).path = [path '/' RaS];
           AllData.(res).(PrS).(RaS).nu = sqrt((2*pi)^3*Pr/Ra);
           AllData.(res).(PrS).(RaS).kappa = sqrt((2*pi)^3/(Ra*Pr));
        end
        
    end
end
%% removing transients
AllData.n_32.Pr_1e0.Ra_1_5e3.trans = 2;
AllData.n_32.Pr_1e0.Ra_1_6e3.trans = 2;

cd /Users/philipwinchester/Dropbox/Matlab/Periodic




