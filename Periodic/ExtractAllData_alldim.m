clearvars -except Data
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
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
    o1S_list = GetlistForExtractAllData(path,"o");
    for a=1:length(o1S_list)
        o1S = convertStringsToChars(o1S_list(a));
        path = [Mpath '/' res '/' o1S];
        o2S_list = GetlistForExtractAllData(path,"o");
        for b=1:length(o2S_list)
            o2S = convertStringsToChars(o2S_list(b));
            path = [Mpath '/' res '/' o1S '/' o2S];  
            fS_list = GetlistForExtractAllData(path,"f");
            for j=1:length(fS_list)
                fS = convertStringsToChars(fS_list(j));
                path = [Mpath '/' res '/' o1S '/' o2S '/' fS];
                hnuS_list = GetlistForExtractAllData(path,"h");
                for k=1:length(hnuS_list)
                    hnuS = convertStringsToChars(hnuS_list(k));
                    path = [Mpath '/' res '/' o1S '/' o2S '/' fS '/' hnuS];
                    nuS_list = GetlistForExtractAllData(path,"n");
                    for l=1:length(nuS_list)
                        nuS = convertStringsToChars(nuS_list(l));
                        path = [Mpath '/' res '/' o1S '/' o2S '/' fS '/' hnuS '/' nuS];
                        kappaS_list = GetlistForExtractAllData(path,"k");
                        for m=1:length(kappaS_list)
                            kappaS = convertStringsToChars(kappaS_list(m));
                            kappa = StoNormal(kappaS,7); nu = StoNormal(nuS,4);
                            f = StoNormal(fS,3); hnu = StoNormal(hnuS,5);
                            o1 = StoNormal(o1S,4); o2 = StoNormal(o2S,4);
                            AllData.(res).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).kappa =  kappa;
                            AllData.(res).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).nu =  nu;
                            AllData.(res).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).f =  f;
                            AllData.(res).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).hnu =  hnu;
                            AllData.(res).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).o1 =  o1;
                            AllData.(res).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).o2 =  o2;
                            %AllData.(res).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).StructPath =  {res o1S o2S fS hnuS nuS kappaS};
                            AllData.(res).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path = [path '/' kappaS];
                        end
                    end
                end
            end
        end
    end
end
%% removing transients
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_0e1.nu_5e_4.kappa_5e_4.trans = 40;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_0e1.nu_1e_2.kappa_1e_3.trans = 140;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_5e_2.nu_5e_4.kappa_5e_4.trans = 10;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_5e_2.nu_2e_3.kappa_2e_3.trans = 40;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_5e_2.nu_3e_3.kappa_3e_3.trans = 40;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_5e_2.nu_4e_3.kappa_4e_3.trans = 40;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_5e_2.nu_5e_3.kappa_5e_3.trans = 40;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_5e_2.nu_6e_3.kappa_6e_3.trans = 40;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_5e_2.nu_7e_3.kappa_7e_3.trans = 40;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_5e_2.nu_3e_3.kappa_3e_2.trans = 40;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_5e_2.nu_4e_3.kappa_4e_2.trans = 40;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_5e_2.nu_3e_2.kappa_3e_3.trans = 40;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_5e_2.nu_4e_2.kappa_4e_3.trans = 40;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_5e_2.nu_1_5e_3.kappa_1_5e_3.trans = 40;

AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_1e_1.nu_7e_3.kappa_7e_3.trans = 10;

AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_2e_1.nu_7e_3.kappa_7e_3.trans = 10;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_2e_1.nu_7e_3.kappa_7e_2.trans = 140;
AllData.n_512.o1_1e0.o2_1e0.f_0e1.hnu_2e_1.nu_7e_3.kappa_7e_4.trans = 40;

AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_4e_1.nu_7e_3.kappa_7e_3.trans = 10;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_8e_1.nu_7e_3.kappa_7e_3.trans = 10;

AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_7e_3.kappa_7e_3.trans = 10;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_7e_3.kappa_7e_4.trans = 10;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_7e_3.kappa_7e_5.trans = 20;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_7e_3.kappa_7e_2.trans = 400;



AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_2e0.nu_7e_3.kappa_7e_3.trans = 10;

% constant nu, vary kappa, n = m = 1. TS are not chaotic under
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_5e_3.kappa_5e_2.trans = 110;
AllData.n_1024.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_5e_3.kappa_2e_2.trans = 100;
AllData.n_1024.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_5e_3.kappa_5e_3.trans = 40;
AllData.n_1024.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_5e_3.kappa_2e_3.trans = 40;
AllData.n_1024.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_5e_3.kappa_5e_4.trans = 40;
AllData.n_1024.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_5e_3.kappa_2e_4.trans = 40;
AllData.n_1024.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_5e_3.kappa_5e_5.trans = 40;
AllData.n_2048.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_5e_3.kappa_5e_6.trans = 50;

% constant nu, vary kappa, n = 4, m = 1. TS are not chaotic under kappa =
% 1e-4
AllData.n_1024.o1_4e0.o2_1e0.f_0e1.hnu_1e0.nu_1e_15.kappa_1e_17.trans = 160;
AllData.n_1024.o1_4e0.o2_1e0.f_0e1.hnu_1e0.nu_1e_15.kappa_1e_16.trans = 120;
AllData.n_1024.o1_4e0.o2_1e0.f_0e1.hnu_1e0.nu_1e_15.kappa_1e_15.trans = 160;
AllData.n_1024.o1_4e0.o2_1e0.f_0e1.hnu_1e0.nu_1e_15.kappa_1e_14.trans = 1000;
%AllData.n_1024.o1_4e0.o2_1e0.f_0e1.hnu_1e0.nu_1e_15.kappa_1e_13.trans =
%800; was not chaotic, so got rid

% o2 = 0, hnu = 0.7
AllData.n_1024.o1_1e0.o2_0e1.f_0e1.hnu_7e_1.nu_5e_5.kappa_5e_3.trans = 40;

% o2 = 0, hnu = 1
AllData.n_256.o1_1e0.o2_0e1.f_0e1.hnu_1e0.nu_5e_3.kappa_5e_2.trans = 1000;
AllData.n_1024.o1_1e0.o2_0e1.f_0e1.hnu_1e0.nu_5e_3.kappa_3e_5.trans = 100;
AllData.n_1024.o1_1e0.o2_0e1.f_0e1.hnu_1e0.nu_5e_3.kappa_1e_4.trans = 100;
AllData.n_1024.o1_1e0.o2_0e1.f_0e1.hnu_1e0.nu_5e_3.kappa_5e_4.trans = 150;
AllData.n_1024.o1_1e0.o2_0e1.f_0e1.hnu_1e0.nu_5e_3.kappa_5e_3.trans = 200;
AllData.n_2048.o1_1e0.o2_0e1.f_0e1.hnu_1e0.nu_5e_3.kappa_5e_5.trans = 120;

% constant nu, vary kappa, n = 4, m = 0.
AllData.n_256.o1_4e0.o2_0e1.f_0e1.hnu_1e0.nu_1e_15.kappa_1e_13.trans = 30;
AllData.n_512.o1_4e0.o2_0e1.f_0e1.hnu_1e0.nu_1e_15.kappa_1e_14.trans = 40;
AllData.n_512.o1_4e0.o2_0e1.f_0e1.hnu_1e0.nu_1e_15.kappa_1e_15.trans = 60;
AllData.n_1024.o1_4e0.o2_0e1.f_0e1.hnu_1e0.nu_1e_15.kappa_1e_16.trans = 200;
AllData.n_1024.o1_4e0.o2_0e1.f_0e1.hnu_1e0.nu_1e_15.kappa_1e_17.trans = 250;


% o2 = 0, hnu = 1, different nu which is constant
AllData.n_2048.o1_1e0.o2_0e1.f_0e1.hnu_1e0.nu_1_5e_4.kappa_1_5e_4.trans = 100;
AllData.n_1024.o1_1e0.o2_0e1.f_0e1.hnu_5e_1.nu_3e_4.kappa_3e_4.trans = 35;
AllData.n_1024.o1_1e0.o2_0e1.f_0e1.hnu_1e_1.nu_1_5e_3.kappa_1_5e_3.trans = 100;

%% HERE

% m=1, n = 4, kappa, 1e-18
AllData.n_2048.o1_4e0.o2_1e0.f_0e1.hnu_1e0.nu_1e_16.kappa_1e_18.trans = 2000;
AllData.n_2048.o1_4e0.o2_1e0.f_0e1.hnu_1e0.nu_1e_17.kappa_1e_18.trans = 400;
AllData.n_2048.o1_4e0.o2_1e0.f_0e1.hnu_1e0.nu_1e_18.kappa_1e_18.trans = 250;
AllData.n_2048.o1_4e0.o2_1e0.f_0e1.hnu_1e0.nu_1e_19.kappa_1e_18.trans = 140;
AllData.n_2048.o1_4e0.o2_1e0.f_0e1.hnu_1e0.nu_1e_20.kappa_1e_18.trans = 200;
% nu 1e-18
AllData.n_1024.o1_4e0.o2_1e0.f_0e1.hnu_1e0.nu_1e_18.kappa_1e_16.trans = 50;
AllData.n_2048.o1_4e0.o2_1e0.f_0e1.hnu_1e0.nu_1e_18.kappa_1e_17.trans = 350;
AllData.n_2048.o1_4e0.o2_1e0.f_0e1.hnu_1e0.nu_1e_18.kappa_1e_19.trans = 300;
AllData.n_2048.o1_4e0.o2_1e0.f_0e1.hnu_1e0.nu_1e_18.kappa_1e_20.trans = 400;
% Ra large, very Pr
AllData.n_2048.o1_4e0.o2_1e0.f_0e1.hnu_1e0.nu_1e_19.kappa_1e_19.trans = 250;
AllData.n_2048.o1_4e0.o2_1e0.f_0e1.hnu_1e0.nu_3_16e_19.kappa_3_16e_20.trans = 300;
AllData.n_2048.o1_4e0.o2_1e0.f_0e1.hnu_1e0.nu_3_16e_20.kappa_3_16e_19.trans = 200;

%% nu, kappa at 2e-4
% keep nu at 2e-4, m = 1, n = 1.
AllData.n_1024.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_2e_4.kappa_2e_4.trans = 30;
AllData.n_512.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_2e_4.kappa_2e_3.trans = 15;
AllData.n_512.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_2e_4.kappa_2e_2.trans = 20;
AllData.n_4096.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_2e_4.kappa_2e_5.trans = 100;
AllData.n_8192.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_2e_4.kappa_2e_6.trans = 1;
%
AllData.n_512.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_2e_3.kappa_2e_4.trans = 10;
AllData.n_512.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_2e_2.kappa_2e_4.trans = 25;
AllData.n_1024.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_5e_3.kappa_2e_4.trans = 40;
AllData.n_2048.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_2e_5.kappa_2e_4.trans = 180; 
AllData.n_4096.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_2e_6.kappa_2e_4.trans = 200;
%
AllData.n_4096.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_2e_5.kappa_2e_5.trans = 200;
AllData.n_4096.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_6_32e_5.kappa_6_32e_6.trans = 200;
AllData.n_4096.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_6_32e_6.kappa_6_32e_5.trans = 140;

%% additional for nusselt
AllData.n_2048.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_6_32e_5.kappa_6_32e_5.trans = 30;
AllData.n_1024.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_6_32e_4.kappa_6_32e_4.trans = 20;
AllData.n_512.o1_1e0.o2_1e0.f_0e1.hnu_1e0.nu_2e_3.kappa_2e_3.trans = 20;

%%
addpath('/Users/philipwinchester/Dropbox/Matlab/Periodic/FunctionOnDF');
AllData = MeanQuantitiesPeriodic(AllData,50);

cd /Users/philipwinchester/Dropbox/Matlab/Periodic




