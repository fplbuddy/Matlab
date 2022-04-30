clearvars -except Data
addpath('/Users/philipwinchester/Dropbox/Matlab/Periodic/Functions')
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
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
                    PrS_list = GetlistForExtractAllData(path,"P");
                    for l=1:length(PrS_list)
                        PrS = convertStringsToChars(PrS_list(l));
                        path = [Mpath '/' res '/' o1S '/' o2S '/' fS '/' hnuS '/' PrS];
                        RaS_list = GetlistForExtractAllData(path,"R");
                        for m=1:length(RaS_list)
                            RaS = convertStringsToChars(RaS_list(m));
                            Ra = StoNormal(RaS,4); Pr = StoNormal(PrS,4);
                            f = StoNormal(fS,3); hnu = StoNormal(hnuS,5);
                            o1 = StoNormal(o1S,4); o2 = StoNormal(o2S,4);
                            AllData.(res).(o1S).(o2S).(fS).(hnuS).(PrS).(RaS).Ra =  Ra;
                            AllData.(res).(o1S).(o2S).(fS).(hnuS).(PrS).(RaS).Pr =  Pr;
                            AllData.(res).(o1S).(o2S).(fS).(hnuS).(PrS).(RaS).f =  f;
                            AllData.(res).(o1S).(o2S).(fS).(hnuS).(PrS).(RaS).hnu =  hnu;
                            AllData.(res).(o1S).(o2S).(fS).(hnuS).(PrS).(RaS).o1 =  o1;
                            AllData.(res).(o1S).(o2S).(fS).(hnuS).(PrS).(RaS).o2 =  o2;
                            AllData.(res).(o1S).(o2S).(fS).(hnuS).(PrS).(RaS).path = [path '/' RaS];
                        end
                    end
                end
            end
        end
    end
end
%% removing transients
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_1e0.Pr_1e_2.Ra_6e6.trans = 50;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_1e0.Pr_1e_1.Ra_6e6.trans = 20;
AllData.n_256.o1_1e0.o2_1e0.f_0e1.hnu_1e0.Pr_1e0.Ra_6e6.trans = 10;
AllData.n_512.o1_1e0.o2_1e0.f_0e1.hnu_1e0.Pr_1e1.Ra_6e6.trans = 50;
AllData.n_512.o1_1e0.o2_1e0.f_0e1.hnu_1e0.Pr_1e2.Ra_6e6.trans = 300;

AllData.n_512.o1_8e0.o2_1e0.f_0e1.hnu_1e0.Pr_1e0.Ra_7e91.trans = 40;
AllData.n_512.o1_8e0.o2_1e0.f_0e1.hnu_1e0.Pr_1e_1.Ra_7e91.trans = 40;
AllData.n_512.o1_8e0.o2_1e0.f_0e1.hnu_1e0.Pr_1e_2.Ra_7e91.trans = 20;
AllData.n_512.o1_8e0.o2_1e0.f_0e1.hnu_1e0.Pr_1e1.Ra_7e91.trans = 20;
AllData.n_512.o1_8e0.o2_1e0.f_0e1.hnu_1e0.Pr_1e2.Ra_7e91.trans = 20;

cd /Users/philipwinchester/Dropbox/Matlab/Periodic




