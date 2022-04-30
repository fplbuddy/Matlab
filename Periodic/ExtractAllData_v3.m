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
    fS_list = GetlistForExtractAllData(path,"f");
    for j=1:length(fS_list)
        fS = convertStringsToChars(fS_list(j));
        path = [Mpath '/' res '/' fS];
        hnuS_list = GetlistForExtractAllData(path,"h");
        for k=1:length(hnuS_list)
            hnuS = convertStringsToChars(hnuS_list(k));
            path = [Mpath '/' res '/' fS '/' hnuS];
            nuS_list = GetlistForExtractAllData(path,"n");
            for l=1:length(nuS_list)
                nuS = convertStringsToChars(nuS_list(l));
                path = [Mpath '/' res '/' fS '/' hnuS '/' nuS];
                kappaS_list = GetlistForExtractAllData(path,"k");
                for m=1:length(kappaS_list)
                    kappaS = convertStringsToChars(kappaS_list(m));
                    kappa = kappaStokappa(kappaS); nu = nuStonu(nuS);
                    f = StoNormal(fS,3); hnu = StoNormal(hnuS,5);
                    AllData.(res).(fS).(hnuS).(nuS).(kappaS).kappa =  kappa;
                    AllData.(res).(fS).(hnuS).(nuS).(kappaS).nu =  nu;
                    AllData.(res).(fS).(hnuS).(nuS).(kappaS).f =  f;
                    AllData.(res).(fS).(hnuS).(nuS).(kappaS).hnu =  hnu;
                    AllData.(res).(fS).(hnuS).(nuS).(kappaS).path = [path '/' kappaS];          
                end
            end
        end
    end
end
%% removing transients
AllData.n_256.f_0e1.hnu_0e1.nu_5e_3.kappa_5e_3.trans = 10;
AllData.n_256.f_0e1.hnu_0e1.nu_5e_4.kappa_5e_4.trans = 10;

cd /Users/philipwinchester/Dropbox/Matlab/Periodic




