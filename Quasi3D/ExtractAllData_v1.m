clearvars -except Data AllData
addpath('/Users/philipwinchester/Dropbox/Matlab/GeneralFuncs')
addpath('/Users/philipwinchester/Dropbox/Matlab/Quasi3D/Functions')

%%
Mpath = '/Volumes/Samsung_T5/Quasi3D';
cd /Volumes/Samsung_T5/Quasi3D
% findinf ICs
AllFolders = dir(Mpath);
AllFolders = extractfield(AllFolders,'name');
IC_list = [];
for k = 1:length(AllFolders)
    if strncmp("IC",AllFolders(k),1)
        IC_list = [IC_list AllFolders(k)]; % Finding which Re have
    end
end
IC_list = string(IC_list);
for i=1:length(IC_list)
    IC = convertStringsToChars(IC_list(i));
    path = [Mpath '/' IC];
    res_list = GetlistForExtractAllData(path,"N");
    for v = 1:length(res_list)
        res =  convertStringsToChars(res_list(v));
        path = [Mpath '/' IC '/' res];
        PrS_list = GetlistForExtractAllData(path,"P");
        for a=1:length(PrS_list)
            PrS = convertStringsToChars(PrS_list(a));
            path = [Mpath '/' IC '/' res '/' PrS];
            RaS_list = GetlistForExtractAllData(path,"R");
            for b=1:length(RaS_list)
                RaS = convertStringsToChars(RaS_list(b));
                path = [Mpath '/' IC '/' res '/' PrS '/' RaS];
                LyS_list = GetlistForExtractAllData(path,"Ly");
                for j=1:length(LyS_list)
                    LyS = convertStringsToChars(LyS_list(j));
                    Ra = StoNormal(RaS,4); Pr = StoNormal(PrS,4); Ly = StoNormal(LyS,4);
                    AllData.(IC).(res).(PrS).(RaS).(LyS).Ra =  Ra;
                    AllData.(IC).(res).(PrS).(RaS).(LyS).Pr =  Pr;
                    AllData.(IC).(res).(PrS).(RaS).(LyS).Ly =  Ly;
                    AllData.(IC).(res).(PrS).(RaS).(LyS).path = [path '/' LyS];
                end
            end
        end
    end
end
%% removing transients
AllData.IC_N.N_256x256.Pr_1e1.Ra_2e6.Ly_1e0.trans = 700;
AllData.IC_N.N_256x256.Pr_1e1.Ra_3e6.Ly_1e0.trans = 400;
AllData.IC_N.N_256x256.Pr_1e1.Ra_6e6.Ly_1e0.trans = 500;
AllData.IC_N.N_256x256.Pr_1e1.Ra_8e6.Ly_1e0.trans = 500;
AllData.IC_N.N_256x256.Pr_1e1.Ra_9e6.Ly_1e0.trans = 1000;
AllData.IC_N.N_256x256.Pr_1e1.Ra_1e7.Ly_1e0.trans = 1500;

AllData.IC_S.N_256x256.Pr_3e1.Ra_1_1e7.Ly_2_5e_1.trans = 500;
AllData.IC_S.N_256x256.Pr_3e1.Ra_1_2e7.Ly_2_5e_1.trans = 500;
AllData.IC_S.N_256x256.Pr_3e1.Ra_1_3e7.Ly_2_5e_1.trans = 500;
AllData.IC_S.N_256x256.Pr_3e1.Ra_1_6e7.Ly_2_5e_1.trans = 500;
AllData.IC_S.N_256x256.Pr_3e1.Ra_2e7.Ly_2_5e_1.trans = 500;

AllData.IC_N.N_256x256.Pr_3e1.Ra_4e6.Ly_5e_1.trans = 4000;


AllData.IC_S.N_1024x512.Pr_1e3.Ra_2e9.Ly_7e_2.trans = 6;
AllData.IC_S.N_1024x512.Pr_1e3.Ra_2e9.Ly_8e_2.trans = 8;
AllData.IC_S.N_1024x512.Pr_1e3.Ra_2e9.Ly_8_5e_2.trans = 30;
AllData.IC_S.N_1024x512.Pr_1e3.Ra_2e9.Ly_9e_2.trans = 40;

AllData.IC_S.N_1024x512.Pr_1e4.Ra_2e9.Ly_1e_1.trans = 500;
AllData.IC_S.N_1024x512.Pr_1e4.Ra_2e9.Ly_8e_2.trans = 500;

% top
AllData.IC_N.N_256x256.Pr_3e1.Ra_3e6.Ly_1e0.top =2800;
AllData.IC_N.N_256x256.Pr_3e1.Ra_6e6.Ly_1e0.top = 1850;
AllData.IC_S.N_1024x512.Pr_1e1.Ra_2e9.Ly_2e_2.top =1700;


cd /Users/philipwinchester/Dropbox/Matlab/Quasi3D




