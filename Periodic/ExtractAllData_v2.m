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
    nuS_list = [];
    for k = 1:length(AllFolders)
        if strncmp("n",AllFolders(k),1)
            nuS_list = [nuS_list AllFolders(k)]; % Finding which Re have
        end
    end
    nuS_list = string(nuS_list);
    for j=1:length(nuS_list)
        nuS = convertStringsToChars(nuS_list(j));
        path = [Mpath '/' res '/' nuS];
        AllFolders = dir(path);
        AllFolders = extractfield(AllFolders,'name');
        kappaS_list = [];
        for k = 1:length(AllFolders)
            if strncmp("k",AllFolders(k),1)
                kappaS_list = [kappaS_list AllFolders(k)]; % Finding which Re have
            end
        end
        kappaS_list = string(kappaS_list);
        for l=1:length(kappaS_list)
           kappaS = convertStringsToChars(kappaS_list(l));
           kappa = kappaStokappa(kappaS); nu = nuStonu(nuS);
           AllData.(res).(nuS).(kappaS).kappa =  kappa;
           AllData.(res).(nuS).(kappaS).nu =  nu;
           AllData.(res).(nuS).(kappaS).path = [path '/' kappaS];
        end
        
    end
end
%% removing transients
AllData.n_256.nu_3e_3.kappa_3e_3.trans = 10;
AllData.n_256.nu_5e_31.kappa_5e_31.trans = 10;
AllData.n_512.nu_5e_31.kappa_5e_31.trans = 10;
AllData.n_512.nu_3e_3.kappa_3e_3.trans = 10;

cd /Users/philipwinchester/Dropbox/Matlab/Periodic




