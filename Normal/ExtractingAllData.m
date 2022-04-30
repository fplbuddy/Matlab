clearvars -except Data
%%
Ly = 1;
TE = 'latex';
home = '/Users/philipwinchester/Dropbox/Matlab/Normal';
Calcs = [home '/Calcs'];
Functions = [home '/Functions'];
Randomplots = [home '/Random_Plots'];
Tests = [home '/Tests'];
addpath(home);
addpath(Calcs);
addpath(Functions);
addpath(Randomplots);
addpath(Tests);
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
addpath('/Users/philipwinchester/Dropbox/Matlab/GeneralFuncs')
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/FunctionOnDF')
%%
Mpath = "/Volumes/Samsung_T5/";
cd /Volumes/Samsung_T5/
%Mpath = "/Users/philipwinchester/Documents/Data/";
%cd /Users/philipwinchester/Documents/Data/
% Getting the Aspect Ratios
path = Mpath;
AllFolders = dir(path);
AllFolders = extractfield(AllFolders,'name');
l = 0;
for k = 1:length(AllFolders)
    if strncmp("AR",AllFolders(k),2)
        l = l + 1;
        AR_list(l) = AllFolders(k); % Finding which Re have
    end
end
AR_list = string(AR_list);

for i=1:length(AR_list) % Loooping round AR
    ARP = AR_list(i); % Picking the aspect ratio
    % Getting the Resolutions
    clear Res_list
    path = join([Mpath ARP],"");
    AllFolders = dir(path);
    AllFolders = extractfield(AllFolders,'name');
    l = 0;
    for k = 1:length(AllFolders)
        if contains(AllFolders(k),"x")
            l = l + 1;
            Res_list(l) = AllFolders(k); % Finding which Re have
        end
    end
    Res_list = string(Res_list);
    for i=1:length(Res_list) % Loopint round Res
        ResP = Res_list(i); % Picking the Resolution
        % Getting the Prs
        clear Pr_list
        path = join([Mpath ARP "/" ResP],"");
        AllFolders = dir(path);
        AllFolders = extractfield(AllFolders,'name');
        l = 0;
        for k = 1:length(AllFolders)
            if AllFolders{k}(1) == 'P' && contains(AllFolders(k),"Pr")
                l = l + 1;
                Pr_list(l) = AllFolders(k); % Finding which Re have
            end
        end
        Pr_list = string(Pr_list);
        for i=1:length(Pr_list) % Looping around Pr
            PrS = Pr_list(i); % Picking the Pr
            % Getting the Ras
            clear Ra_list
            path = join([Mpath ARP "/" ResP "/" PrS],"");
            AllFolders = dir(path);
            AllFolders = extractfield(AllFolders,'name');
            l = 0;
            for k = 1:length(AllFolders)
                if contains(AllFolders(k),"Ra")
                    l = l + 1;
                    Ra_list(l) = AllFolders(k); % Finding which Re have
                end
            end
            Ra_list = string(Ra_list);
            for i=1:length(Ra_list)
                RaS = Ra_list(i);
                check = convertStringsToChars(RaS);
                if check(3) == 'A' || check(end) == 'o' % Removes RaA and _two
                    continue
                end
                % Now we save stuff
                try
                    path = join([Mpath ARP "/" ResP "/" PrS "/" RaS],"");
                    % General info
                    AllData.(ARP).(PrS).(RaS).Ra = RaStoRa(RaS);
                    try
                        AllData.(ARP).(PrS).(RaS).Pr = PrStoPr(PrS);
                        if isnan(AllData.(ARP).(PrS).(RaS).Pr)
                            error
                        end
                    catch
                        AllData.(ARP).(PrS).(RaS).Pr = PrStoPrZero(PrS);
                    end
                    Ra = AllData.(ARP).(PrS).(RaS).Ra;
                    Pr = AllData.(ARP).(PrS).(RaS).Pr;
                    AllData.(ARP).(PrS).(RaS).Res = ResP;
                    AllData.(ARP).(PrS).(RaS).kappa = sqrt((pi*Ly)^3/(Ra*Pr));
                    AllData.(ARP).(PrS).(RaS).nu = sqrt((pi*Ly)^3*Pr/(Ra));
                    AllData.(ARP).(PrS).(RaS).AR = str2double(erase(erase(strrep(ARP,"_","."),"AR."),"AR"));
                    RaT = RatoRaT(Ra);
                    dp = num2str(find(num2str(Ra) ~= '0', 1, 'last' )-1); % How many dp we want in Ra
                    AllData.(ARP).(PrS).(RaS).title = ['Pr = ' num2str(Pr) ', Ra = ' RaT];
                    AllData.(ARP).(PrS).(RaS).path = path;
                catch
                end
            end
        end
    end
end

%% Remove Initial conditions AR_2_8
% Dont actually need this do i?
% AllData.AR_2_8.Pr_1.Ra_6_6e2.ICT = 129576;
% AllData.AR_2_8.Pr_1.Ra_6_59e2.ICT = 24897;
% AllData.AR_2_8.Pr_1.Ra_6_597e2.ICT = 26880;
% AllData.AR_2_8.Pr_1.Ra_6_594e2.ICT = 27073;
% AllData.AR_2_8.Pr_1.Ra_6_58e2.ICT = 94623; % Has different IC

%% AR_1
AllData.AR_1.Pr_30.Ra_1e4.ICT = 5000;
AllData.AR_1.Pr_30.Ra_2e4.ICT = 5000;
AllData.AR_1.Pr_30.Ra_3e4.ICT = 1e4;
AllData.AR_1.Pr_30.Ra_6e4.ICT = 2e4;
AllData.AR_1.Pr_30.Ra_1e5.ICT = 2500;
AllData.AR_1.Pr_30.Ra_2e5.ICT = 1e4;
AllData.AR_1.Pr_30.Ra_3e5.ICT = 300;
AllData.AR_1.Pr_30.Ra_4_5e5.ICT = 300;
AllData.AR_1.Pr_30.Ra_5e5.ICT = 3000;
AllData.AR_1.Pr_30.Ra_6e5.ICT = 300;
AllData.AR_1.Pr_30.Ra_7e5.ICT = 1300;
AllData.AR_1.Pr_30.Ra_8e5.ICT = 950;
AllData.AR_1.Pr_30.Ra_9e5.ICT = 800;
AllData.AR_1.Pr_30.Ra_1e6.ICT = 1;
AllData.AR_1.Pr_30.Ra_1_1e6.ICT = 1;
AllData.AR_1.Pr_30.Ra_1_2e6.ICT = 1;
AllData.AR_1.Pr_30.Ra_1_3e6.ICT = 1;
AllData.AR_1.Pr_30.Ra_1_4e6.ICT = 1;
AllData.AR_1.Pr_30.Ra_1_5e6.ICT = 1;
AllData.AR_1.Pr_30.Ra_1_6e6.ICT = 1;
AllData.AR_1.Pr_30.Ra_1_7e6.ICT = 1;
AllData.AR_1.Pr_30.Ra_1_8e6.ICT = 1;
AllData.AR_1.Pr_30.Ra_1_85e6.ICT = 1;
AllData.AR_1.Pr_30.Ra_1_9e6.ICT = 1;

% these are with N = 256
%AllData.AR_1.Pr_30.Ra_1e6.ICT = 300;
%AllData.AR_1.Pr_30.Ra_2e6.ICT = 300;
%AllData.AR_1.Pr_30.Ra_3e6.ICT = 300;
%AllData.AR_1.Pr_30.Ra_6e6.ICT = 300;
%AllData.AR_1.Pr_30.Ra_1e7.ICT = 300;
%AllData.AR_1.Pr_30.Ra_1_4e6.ICT = 500;
%%
AllData.AR_1.Pr_0_1.Ra_1e7.ICT = 100; 
AllData.AR_1.Pr_0_1.Ra_1e8.ICT = 500;
AllData.AR_1.Pr_0_001.Ra_1e7.ICT = 2e4;
AllData.AR_1.Pr_0_001.Ra_1e8.ICT = 4e4;
% AllData.AR_1.Pr_0_00001.Ra_1e8.ICT = 1;
% AllData.AR_1.Pr_0_00001.Ra_1e7.ICT = 1;
AllData.AR_1.Pr_0_03.Ra_1e7.ICT = 1e3;
AllData.AR_1.Pr_0_03.Ra_1e8.ICT = 5e3;
AllData.AR_1.Pr_0_01.Ra_1e7.ICT = 1e3;
AllData.AR_1.Pr_0_01.Ra_1e8.ICT = 1e3;
AllData.AR_1.Pr_0_003.Ra_1e7.ICT = 3e4;

%% Remove Initial conditions AR_2
AllData.AR_2.Pr_0_001.Ra_1e3.ICT = 1;
AllData.AR_2.Pr_0_001.Ra_9e2.ICT = 1;

AllData.AR_2.Pr_0_01.Ra_7_85e2.ICT = 200;
AllData.AR_2.Pr_0_01.Ra_7_86e2.ICT = 600;
AllData.AR_2.Pr_0_01.Ra_7_8627e2.ICT = 1;
AllData.AR_2.Pr_0_01.Ra_7_85e2.ICT = 6e4;
AllData.AR_2.Pr_0_01.Ra_7_88e2.ICT = 6e4;
AllData.AR_2.Pr_0_01.Ra_7_91e2.ICT = 6e4;
AllData.AR_2.Pr_0_01.Ra_7_94e2.ICT = 6e4;
AllData.AR_2.Pr_0_01.Ra_7_97e2.ICT = 4e4;
AllData.AR_2.Pr_0_01.Ra_8e2.ICT = 4e4;
AllData.AR_2.Pr_0_01.Ra_9e2.ICT = 8e4;
AllData.AR_2.Pr_0_01.Ra_1e3.ICT = 1;
AllData.AR_2.Pr_0_01.Ra_2e3.ICT = 1.0685e4;
AllData.AR_2.Pr_0_01.Ra_3e3.ICT = 1.12e4;
AllData.AR_2.Pr_0_01.Ra_6e3.ICT = 6850;
AllData.AR_2.Pr_0_01.Ra_4e3.ICT = 1e4;
AllData.AR_2.Pr_0_01.Ra_5e3.ICT = 8e3;
AllData.AR_2.Pr_0_01.Ra_1e4.ICT = 3e3;
AllData.AR_2.Pr_0_01.Ra_8e2.ICT = 1;
AllData.AR_2.Pr_0_01.Ra_8_5e2.ICT = 1;
AllData.AR_2.Pr_0_01.Ra_7_9e2.ICT = 1.6e5;

AllData.AR_2.Pr_0_03.Ra_8_4e2.ICT = 1;
AllData.AR_2.Pr_0_03.Ra_2_1e3.ICT = 1;
AllData.AR_2.Pr_0_03.Ra_2_2e3.ICT = 1;
AllData.AR_2.Pr_0_03.Ra_8_3e3.ICT = 1;
AllData.AR_2.Pr_0_03.Ra_6e5.ICT = 1;
AllData.AR_2.Pr_0_03.Ra_1e6.ICT = 1;

AllData.AR_2.Pr_0_1.Ra_2e6.ICT = 2e5;
AllData.AR_2.Pr_0_1.Ra_3_7e4.ICT = 40;
AllData.AR_2.Pr_0_1.Ra_3_8e4.ICT = 40;
AllData.AR_2.Pr_0_1.Ra_4_1e4.ICT = 2e4;
AllData.AR_2.Pr_0_2.Ra_2e5.ICT = 500;
AllData.AR_2.Pr_0_2.Ra_3_32e5.ICT = 20;
AllData.AR_2.Pr_0_2.Ra_3_33e5.ICT = 2e4;
AllData.AR_2.Pr_0_2.Ra_3_35e5.ICT = 1e4;
AllData.AR_2.Pr_0_3.Ra_3_5e5.ICT = 500;
AllData.AR_2.Pr_0_3.Ra_5e5.ICT = 20;
AllData.AR_2.Pr_0_4.Ra_5e5.ICT = 500;
AllData.AR_2.Pr_1.Ra_2e6.ICT = 51000;
AllData.AR_2.Pr_1.Ra_1e5.ICT = 3000;
AllData.AR_2.Pr_1.Ra_2e5.ICT = 5000;
AllData.AR_2.Pr_1.Ra_3e5.ICT = 2.5e5;
AllData.AR_2.Pr_1.Ra_6e5.ICT = 2500;
AllData.AR_2.Pr_1.Ra_2e7.ICT = 2.2e4;
AllData.AR_2.Pr_1.Ra_2e8.ICT = 3e4;

AllData.AR_2.Pr_1.Ra_1e4.ICT = 4000;
AllData.AR_2.Pr_1.Ra_2e4.ICT = 1000;
AllData.AR_2.Pr_1.Ra_3e4.ICT = 1000;
AllData.AR_2.Pr_1.Ra_4e4.ICT = 1000;
AllData.AR_2.Pr_1.Ra_5e4.ICT = 1000;
AllData.AR_2.Pr_1.Ra_6e4.ICT = 1000;
AllData.AR_2.Pr_1.Ra_7e4.ICT = 1000;
AllData.AR_2.Pr_1.Ra_8e4.ICT = 1000;
AllData.AR_2.Pr_1.Ra_9e4.ICT = 1000;
AllData.AR_2.Pr_1.Ra_1_1e5.ICT = 2e4;
AllData.AR_2.Pr_1.Ra_1_2e5.ICT = 500;
AllData.AR_2.Pr_1.Ra_1_3e5.ICT = 500;
AllData.AR_2.Pr_1.Ra_1_4e5.ICT = 2e4;
AllData.AR_2.Pr_1.Ra_6e3.ICT = 4e5;
AllData.AR_2.Pr_1.Ra_8e2.ICT = 5e4;
AllData.AR_2.Pr_1.Ra_7_79e2.ICT = 3000;
AllData.AR_2.Pr_1.Ra_7_8e2.ICT = 6e4;
AllData.AR_2.Pr_1.Ra_7_94e2.ICT = 4000;
AllData.AR_2.Pr_1.Ra_7_93e2.ICT = 3500;
AllData.AR_2.Pr_1.Ra_7_92e2.ICT = 4000;
AllData.AR_2.Pr_1.Ra_7_91e2.ICT = 4500;
AllData.AR_2.Pr_1.Ra_7_84e2.ICT = 11000;
AllData.AR_2.Pr_1.Ra_7_83e2.ICT = 1.4e4;
AllData.AR_2.Pr_1.Ra_7_82e2.ICT = 1.6e4;
AllData.AR_2.Pr_1.Ra_7_81e2.ICT = 3e4;
AllData.AR_2.Pr_1.Ra_7_9e2.ICT = 5000;
AllData.AR_2.Pr_1.Ra_1_1e6.ICT = 40;
AllData.AR_2.Pr_1.Ra_1_2e6.ICT = 40;

AllData.AR_2.Pr_1.Ra_1_2e4.ICT = 2e4;
AllData.AR_2.Pr_1.Ra_1_5e4.ICT = 2e4;
AllData.AR_2.Pr_1.Ra_1_8e4.ICT = 5e3;
AllData.AR_2.Pr_1.Ra_1_7e4.ICT = 5e3;
AllData.AR_2.Pr_1.Ra_1_6e4.ICT = 5e3;
AllData.AR_2.Pr_1.Ra_1_78e4.ICT = 5e3;
AllData.AR_2.Pr_1.Ra_1_75e4.ICT = 5e3;
AllData.AR_2.Pr_1.Ra_1_72e4.ICT = 5e3;
AllData.AR_2.Pr_1.Ra_1_74e4.ICT = 4000;
AllData.AR_2.Pr_1.Ra_1_73e4.ICT = 4000;
AllData.AR_2.Pr_1.Ra_1_742e4.ICT = 2000;
AllData.AR_2.Pr_1.Ra_1_745e4.ICT = 500;
AllData.AR_2.Pr_1.Ra_1_748e4.ICT = 500;
AllData.AR_2.Pr_1.Ra_1_744e4.ICT = 1000;
AllData.AR_2.Pr_1.Ra_1_743e4.ICT = 2000;

AllData.AR_2.Pr_1.Ra_1_35e5.ICT = 10000;
AllData.AR_2.Pr_1.Ra_1_4e4.ICT = 2000;
AllData.AR_2.Pr_1.Ra_1_31e5.ICT = 1;
AllData.AR_2.Pr_1.Ra_1_32e5.ICT = 1;
AllData.AR_2.Pr_1.Ra_1_33e5.ICT = 1;
AllData.AR_2.Pr_1.Ra_1_34e5.ICT = 5000;

AllData.AR_2.Pr_1.Ra_1e8.ICT = 5000;
AllData.AR_2.Pr_1.Ra_1e6.ICT = 70;
AllData.AR_2.Pr_1.Ra_1e7.ICT = 200;
AllData.AR_2.Pr_1.Ra_6_4e6.ICT = 60;

AllData.AR_2.Pr_1_5.Ra_2e6.ICT = 147000;
AllData.AR_2.Pr_2.Ra_2e6.ICT = 2000;
AllData.AR_2.Pr_3.Ra_1e4.ICT = 6000;
AllData.AR_2.Pr_3.Ra_2e6.ICT = 4500;
AllData.AR_2.Pr_3.Ra_1e6.ICT = 3000;
AllData.AR_2.Pr_3.Ra_4e6.ICT = 3500;
AllData.AR_2.Pr_3.Ra_5e5.ICT = 1000;
AllData.AR_2.Pr_3.Ra_1e7.ICT = 4500;
AllData.AR_2.Pr_3.Ra_2e7.ICT = 1.2e4;
AllData.AR_2.Pr_3.Ra_3e7.ICT = 1.4e4;
AllData.AR_2.Pr_3.Ra_4e7.ICT = 1.65e4;
AllData.AR_2.Pr_3.Ra_5e7.ICT = 1.8e4;
AllData.AR_2.Pr_3.Ra_5e8.ICT = 4.4e4;
AllData.AR_2.Pr_3.Ra_6e7.ICT = 2e4;
AllData.AR_2.Pr_3.Ra_2e4.ICT = 5000;
AllData.AR_2.Pr_3.Ra_3e4.ICT = 5000;
AllData.AR_2.Pr_3.Ra_6e4.ICT = 400;
AllData.AR_2.Pr_3.Ra_1e5.ICT = 500;
AllData.AR_2.Pr_3.Ra_2e5.ICT = 2e4;
AllData.AR_2.Pr_3.Ra_3e5.ICT = 1.5e5;
AllData.AR_2.Pr_3.Ra_6e5.ICT = 1;

AllData.AR_2.Pr_3.Ra_3e5.ICT = 2000;
AllData.AR_2.Pr_3.Ra_3e6.ICT = 2000;
AllData.AR_2.Pr_3.Ra_6e6.ICT = 2000;
AllData.AR_2.Pr_3.Ra_4e5.ICT = 5000;
AllData.AR_2.Pr_3.Ra_2_99e5.ICT = 5000;


AllData.AR_2.Pr_4.Ra_5e8.ICT = 4e4;
AllData.AR_2.Pr_5.Ra_2e6.ICT = 3000;
AllData.AR_2.Pr_5.Ra_1e7.ICT = 5000;
AllData.AR_2.Pr_5.Ra_2e7.ICT = 1.3e4;
AllData.AR_2.Pr_5.Ra_3e7.ICT = 1.6e4;
AllData.AR_2.Pr_5.Ra_4e7.ICT = 1.8e4;
AllData.AR_2.Pr_5.Ra_5e7.ICT = 2e4;
AllData.AR_2.Pr_5.Ra_5e8.ICT = 3.75e4;
AllData.AR_2.Pr_5.Ra_6e7.ICT = 2e4;
AllData.AR_2.Pr_6.Ra_1e6.ICT = 500;
AllData.AR_2.Pr_6.Ra_2e6.ICT = 500;

AllData.AR_2.Pr_6_2.Ra_6e4.ICT = 2.2e4;
AllData.AR_2.Pr_6_2.Ra_7e4.ICT = 0.6e4;

%AllData.AR_2.Pr_6_8.Ra_3e6.ICT = 4450;
%AllData.AR_2.Pr_6_8.Ra_3e8.ICT = 1400;
AllData.AR_2.Pr_8.Ra_2e6.ICT = 2500;

AllData.AR_2.Pr_8.Ra_3_32e4.ICT = 4.2e4;
AllData.AR_2.Pr_8.Ra_3_38e4.ICT = 1e4;
AllData.AR_2.Pr_8.Ra_3_41e4.ICT = 4.3e4;
AllData.AR_2.Pr_8.Ra_3_51e4.ICT = 2.5e4;
AllData.AR_2.Pr_8.Ra_3_6e4.ICT = 2e4;
AllData.AR_2.Pr_8.Ra_5e4.ICT = 0.5e4;

AllData.AR_2.Pr_8_57.Ra_1_2e6.ICT = 1;
AllData.AR_2.Pr_8_57.Ra_1_27e6.ICT = 2.5e4;
AllData.AR_2.Pr_8_57.Ra_1_3e6.ICT = 3e5;


AllData.AR_2.Pr_8_58.Ra_1_2e6.ICT = 700;
%AllData.AR_2.Pr_8_58.Ra_1_28e6.ICT = 1;
AllData.AR_2.Pr_8_58.Ra_1_3e6.ICT = 1;
AllData.AR_2.Pr_8_58.Ra_1_35e6.ICT = 5000;
AllData.AR_2.Pr_8_58.Ra_1_27e6.ICT = 1;
AllData.AR_2.Pr_8_58.Ra_1_29e6.ICT = 1.5e5;

AllData.AR_2.Pr_9.Ra_3_25e4.ICT = 7e4;
AllData.AR_2.Pr_9.Ra_3_28e4.ICT = 7e4;
AllData.AR_2.Pr_9.Ra_3_3e4.ICT = 7e4;
AllData.AR_2.Pr_9.Ra_3_4e4.ICT = 7e4;
AllData.AR_2.Pr_9.Ra_3_5e4.ICT = 7e4;
AllData.AR_2.Pr_9.Ra_5e4.ICT = 7e4;

AllData.AR_2.Pr_10.Ra_3_25e4.ICT = 4.5e4;
AllData.AR_2.Pr_10.Ra_3_27e4.ICT = 4.5e4;
AllData.AR_2.Pr_10.Ra_3_41e4.ICT = 4.5e4;
AllData.AR_2.Pr_10.Ra_3_6e4.ICT = 1.5e4;
AllData.AR_2.Pr_10.Ra_3_2e4.ICT = 100;
AllData.AR_2.Pr_10.Ra_3_3e4.ICT = 100;

AllData.AR_2.Pr_10.Ra_2e6.ICT = 5000;
AllData.AR_2.Pr_10.Ra_2e7.ICT = 9000;
AllData.AR_2.Pr_10.Ra_2e8.ICT = 2500;
AllData.AR_2.Pr_10.Ra_5e8.ICT = 1.5e4;
AllData.AR_2.Pr_10.Ra_2e4.ICT = 5e4;
%AllData.AR_2.Pr_10.Ra_3e4.ICT = 5e4; had not converged yet
AllData.AR_2.Pr_10.Ra_6e4.ICT = 2000;
AllData.AR_2.Pr_10.Ra_1e5.ICT = 2000;
AllData.AR_2.Pr_10.Ra_5e4.ICT = 1e4;
AllData.AR_2.Pr_10.Ra_4e4.ICT = 2e4;
AllData.AR_2.Pr_10.Ra_3e4.ICT = 4e5;
AllData.AR_2.Pr_10.Ra_1e4.ICT = 1e4;

AllData.AR_2.Pr_10.Ra_3_5e4.ICT = 1.5e5;
AllData.AR_2.Pr_10.Ra_3_8e4.ICT = 1e5;
AllData.AR_2.Pr_10.Ra_3_1e4.ICT = 7e4;

AllData.AR_2.Pr_10.Ra_2e5.ICT = 0.5e4;
AllData.AR_2.Pr_10.Ra_3e5.ICT = 0.5e4;
AllData.AR_2.Pr_10.Ra_6e5.ICT = 0.5e4;
AllData.AR_2.Pr_10.Ra_1e6.ICT = 0.5e4;

AllData.AR_2.Pr_10.Ra_6e6.ICT = 2000;
AllData.AR_2.Pr_10.Ra_1e7.ICT = 2000;
AllData.AR_2.Pr_10.Ra_1_99e7.ICT = 2000;

AllData.AR_2.Pr_11.Ra_3_2e4.ICT = 9000;
AllData.AR_2.Pr_11.Ra_3_28e4.ICT = 7e4;
AllData.AR_2.Pr_11.Ra_3_3e4.ICT = 7e4;
AllData.AR_2.Pr_11.Ra_3_4e4.ICT = 7e4;
AllData.AR_2.Pr_11.Ra_3_5e4.ICT = 7e4;
AllData.AR_2.Pr_11.Ra_4e4.ICT = 7e4;
AllData.AR_2.Pr_11.Ra_5e4.ICT = 7e4;

AllData.AR_2.Pr_20.Ra_3e6.ICT = 5000;
AllData.AR_2.Pr_20.Ra_6e6.ICT = 5000;
AllData.AR_2.Pr_20.Ra_1e7.ICT = 5000;
AllData.AR_2.Pr_20.Ra_2e7.ICT = 5000;
AllData.AR_2.Pr_20.Ra_1_5e7.ICT = 5000;

AllData.AR_2.Pr_30.Ra_4_9e4.ICT = 1.2e5;
AllData.AR_2.Pr_30.Ra_1e5.ICT = 5000;
AllData.AR_2.Pr_30.Ra_1e6.ICT = 5000;
AllData.AR_2.Pr_30.Ra_1e7.ICT = 500;
AllData.AR_2.Pr_30.Ra_2e5.ICT = 3500;
AllData.AR_2.Pr_30.Ra_2e6.ICT = 200;
AllData.AR_2.Pr_30.Ra_3_5e6.ICT = 100;
AllData.AR_2.Pr_30.Ra_3e6.ICT = 200;
AllData.AR_2.Pr_30.Ra_4_5e6.ICT = 300;
AllData.AR_2.Pr_30.Ra_4e6.ICT = 700;
AllData.AR_2.Pr_30.Ra_4e5.ICT = 4000;
AllData.AR_2.Pr_30.Ra_5_5e6.ICT = 3000;
AllData.AR_2.Pr_30.Ra_5_6e6.ICT = 3000;
AllData.AR_2.Pr_30.Ra_5_7e6.ICT = 3000;
AllData.AR_2.Pr_30.Ra_5_8e6.ICT = 4000;
AllData.AR_2.Pr_30.Ra_5_9e6.ICT = 3000;
AllData.AR_2.Pr_30.Ra_5e6.ICT = 3000;
AllData.AR_2.Pr_30.Ra_6_1e6.ICT = 3000;
AllData.AR_2.Pr_30.Ra_6_2e6.ICT = 3000;
AllData.AR_2.Pr_30.Ra_6_3e6.ICT = 3000;
AllData.AR_2.Pr_30.Ra_6_5e6.ICT = 3000;
AllData.AR_2.Pr_30.Ra_6_8e6.ICT = 3500;
AllData.AR_2.Pr_30.Ra_6e5.ICT = 4000;
AllData.AR_2.Pr_30.Ra_6e6.ICT = 2500;
AllData.AR_2.Pr_30.Ra_7e6.ICT = 3000;
AllData.AR_2.Pr_30.Ra_8e5.ICT = 5000;
AllData.AR_2.Pr_30.Ra_8e6.ICT = 400;
AllData.AR_2.Pr_30.Ra_2e7.ICT = 1.5e4;
AllData.AR_2.Pr_30.Ra_4e7.ICT = 1.5e4;
AllData.AR_2.Pr_30.Ra_6e7.ICT = 1.5e4;
AllData.AR_2.Pr_30.Ra_8e7.ICT = 1.5e4;
AllData.AR_2.Pr_30.Ra_1e8.ICT = 1.5e4;
AllData.AR_2.Pr_30.Ra_6_4e6.ICT = 3000;
AllData.AR_2.Pr_30.Ra_2e7.ICT = 10000;
AllData.AR_2.Pr_30.Ra_5e8.ICT = 1.2e4;
AllData.AR_2.Pr_30.Ra_1e9.ICT = 2e4;
AllData.AR_2.Pr_30.Ra_3e7.ICT = 1e4;
AllData.AR_2.Pr_30.Ra_2e8.ICT = 1e4;
AllData.AR_2.Pr_30.Ra_3e8.ICT = 1.5e4;
AllData.AR_2.Pr_30.Ra_2e4.ICT = 8e4;
AllData.AR_2.Pr_30.Ra_3e4.ICT = 1.1e5;
AllData.AR_2.Pr_30.Ra_6e4.ICT = 1e4;
AllData.AR_2.Pr_30.Ra_4_78e4.ICT = 5e5;
AllData.AR_2.Pr_30.Ra_4_79e4.ICT = 5e5;
AllData.AR_2.Pr_30.Ra_4_8e4.ICT = 5e5;
AllData.AR_2.Pr_30.Ra_4_83e4.ICT = 5e5;
AllData.AR_2.Pr_30.Ra_4_87e4.ICT = 6e5;
AllData.AR_2.Pr_30.Ra_4_97e4.ICT = 6e5;
AllData.AR_2.Pr_30.Ra_5_07e4.ICT = 6e5;
AllData.AR_2.Pr_30.Ra_5_37e4.ICT = 6e5;
AllData.AR_2.Pr_30.Ra_5_77e4.ICT = 6e5;

AllData.AR_2.Pr_30.Ra_4e4.ICT = 5e4;
AllData.AR_2.Pr_30.Ra_4_5e4.ICT = 2e4;

AllData.AR_2.Pr_30.Ra_4_766e4.ICT = 6e4;
AllData.AR_2.Pr_30.Ra_4_767e4.ICT = 1.2e5;
AllData.AR_2.Pr_30.Ra_4_768e4.ICT = 1e5;
AllData.AR_2.Pr_30.Ra_4_769e4.ICT = 1.4e5;

AllData.AR_2.Pr_30.Ra_1_5e4.ICT = 1e5;
AllData.AR_2.Pr_30.Ra_1e4.ICT = 5e5;
AllData.AR_2.Pr_30.Ra_2e3.ICT = 4e4;
AllData.AR_2.Pr_30.Ra_4e3.ICT = 4e4;
AllData.AR_2.Pr_30.Ra_6e3.ICT = 5e5;
AllData.AR_2.Pr_30.Ra_8e2.ICT = 8e4;
AllData.AR_2.Pr_30.Ra_8e3.ICT = 2e5;

AllData.AR_2.Pr_30.Ra_7_79e2.ICT = 3000;

AllData.AR_2.Pr_30.Ra_7_81e2.ICT = 3.15e5;
AllData.AR_2.Pr_30.Ra_7_82e2.ICT = 2.05e5;
AllData.AR_2.Pr_30.Ra_7_83e2.ICT = 1.54e5;
AllData.AR_2.Pr_30.Ra_7_84e2.ICT = 1.25e5;
AllData.AR_2.Pr_30.Ra_7_9e2.ICT = 5.7e4;
AllData.AR_2.Pr_30.Ra_7_91e2.ICT = 5.4e4;
AllData.AR_2.Pr_30.Ra_7_92e2.ICT = 5e4;
AllData.AR_2.Pr_30.Ra_7_93e2.ICT = 4.55e4;
AllData.AR_2.Pr_30.Ra_7_94e2.ICT = 4.25e4;

AllData.AR_2.Pr_30.Ra_3_6e6.ICT = 1;
AllData.AR_2.Pr_30.Ra_3_7e6.ICT = 1;
AllData.AR_2.Pr_30.Ra_7_8e6.ICT = 200;
AllData.AR_2.Pr_30.Ra_7_9e6.ICT = 200;
AllData.AR_2.Pr_30.Ra_9e6.ICT = 1.178e4;

AllData.AR_2.Pr_30.Ra_3_4e6.ICT = 1;
AllData.AR_2.Pr_30.Ra_3_3e6.ICT = 100;
AllData.AR_2.Pr_30.Ra_3_2e6.ICT = 100;
AllData.AR_2.Pr_30.Ra_3_1e6.ICT = 100;
AllData.AR_2.Pr_30.Ra_2_8e6.ICT = 100;
AllData.AR_2.Pr_30.Ra_2_5e6.ICT = 100;
AllData.AR_2.Pr_30.Ra_5_3e6.ICT = 100;
AllData.AR_2.Pr_30.Ra_4_1e6.ICT = 100;
AllData.AR_2.Pr_30.Ra_2_7e6.ICT = 100;
AllData.AR_2.Pr_30.Ra_2_1e6.ICT = 100;
AllData.AR_2.Pr_30.Ra_1_7e6.ICT = 100;
AllData.AR_2.Pr_30.Ra_1_3e6.ICT = 100;
AllData.AR_2.Pr_30.Ra_4_77e4.ICT = 1.7e5;

AllData.AR_2.Pr_50.Ra_1e7.ICT = 2000;
AllData.AR_2.Pr_50.Ra_2e7.ICT = 3000;
AllData.AR_2.Pr_50.Ra_3e7.ICT = 2500;
AllData.AR_2.Pr_50.Ra_1e8.ICT = 10000;
AllData.AR_2.Pr_50.Ra_1e9.ICT = 2.5e4;
AllData.AR_2.Pr_50.Ra_5e8.ICT = 500;
AllData.AR_2.Pr_100.Ra_7e6.ICT = 7500;
AllData.AR_2.Pr_100.Ra_8e6.ICT = 6000;
AllData.AR_2.Pr_100.Ra_9e6.ICT = 4000;
AllData.AR_2.Pr_100.Ra_1e7.ICT = 5000;
AllData.AR_2.Pr_100.Ra_2e7.ICT = 4000;
AllData.AR_2.Pr_100.Ra_3e7.ICT = 3000;
AllData.AR_2.Pr_100.Ra_5e7.ICT = 5000;
AllData.AR_2.Pr_100.Ra_1e8.ICT = 9000;
% AllData.AR_2.Pr_100.Ra_2e9.ICT = 2.24e4; this was for 512x512 run
AllData.AR_2.Pr_100.Ra_3e9.ICT = 3.1e4;
AllData.AR_2.Pr_100.Ra_3e8.ICT = 8000;
AllData.AR_2.Pr_100.Ra_5e8.ICT = 7000;
AllData.AR_2.Pr_100.Ra_1e9.ICT = 8000;
AllData.AR_2.Pr_100.Ra_2e8.ICT = 2000;
AllData.AR_2.Pr_100.Ra_3e8.ICT = 2e4;
AllData.AR_2.Pr_100.Ra_3e5.ICT = 7000;
AllData.AR_2.Pr_100.Ra_6e5.ICT = 5000;
AllData.AR_2.Pr_100.Ra_1e6.ICT = 5000;
AllData.AR_2.Pr_100.Ra_2e6.ICT = 3000;
AllData.AR_2.Pr_100.Ra_3e6.ICT = 3000;
AllData.AR_2.Pr_100.Ra_6e6.ICT = 2000;

AllData.AR_2.Pr_100.Ra_6e4.ICT = 3e4;
AllData.AR_2.Pr_100.Ra_2e5.ICT = 2e4;
AllData.AR_2.Pr_100.Ra_3e5.ICT = 1e4;
AllData.AR_2.Pr_100.Ra_2_5e5.ICT = 5e3;
AllData.AR_2.Pr_100.Ra_2_2e5.ICT = 4000;
AllData.AR_2.Pr_100.Ra_2_1e5.ICT = 2000;

AllData.AR_2.Pr_100.Ra_1e5.ICT = 1.8e5;
AllData.AR_2.Pr_100.Ra_2_05e5.ICT = 1.5e4;

AllData.AR_2.Pr_100.Ra_2_01e5.ICT = 3e4;
AllData.AR_2.Pr_100.Ra_2_02e5.ICT = 2e4;
AllData.AR_2.Pr_100.Ra_2_03e5.ICT = 2e4;
AllData.AR_2.Pr_100.Ra_2_023e5.ICT = 2e4;
AllData.AR_2.Pr_100.Ra_2_025e5.ICT = 2e4;
AllData.AR_2.Pr_100.Ra_2_028e5.ICT = 2e4;
AllData.AR_2.Pr_100.Ra_2_029e5.ICT = 2e4;
AllData.AR_2.Pr_100.Ra_2_0283e5.ICT = 2e4;
AllData.AR_2.Pr_100.Ra_2_0284e5.ICT = 4e4;
AllData.AR_2.Pr_100.Ra_2_0285e5.ICT = 1.5e4;
AllData.AR_2.Pr_100.Ra_2_0288e5.ICT = 1.5e4;
AllData.AR_2.Pr_100.Ra_1_1e5.ICT = 2.5e4;
AllData.AR_2.Pr_100.Ra_3e4.ICT = 1e4;
AllData.AR_2.Pr_100.Ra_5e4.ICT = 3000;
AllData.AR_2.Pr_100.Ra_2_31e5.ICT = 1e4;
AllData.AR_2.Pr_100.Ra_1e5.ICT = 400;
AllData.AR_2.Pr_100.Ra_1_1e5.ICT = 400;
%AllData.AR_2.Pr_100.Ra_2_41e5.ICT = ;

AllData.AR_2.Pr_110.Ra_2e7.ICT = 700;
AllData.AR_2.Pr_120.Ra_2e7.ICT = 800;
AllData.AR_2.Pr_150.Ra_1e8.ICT = 8000;
AllData.AR_2.Pr_150.Ra_2e8.ICT = 8000;
AllData.AR_2.Pr_150.Ra_3e8.ICT = 8000;
AllData.AR_2.Pr_150.Ra_6e8.ICT = 6000;
AllData.AR_2.Pr_150.Ra_1e9.ICT = 8000;
AllData.AR_2.Pr_200.Ra_5e8.ICT = 6500;
AllData.AR_2.Pr_200.Ra_5e7.ICT = 2e4;
AllData.AR_2.Pr_200.Ra_1e8.ICT = 1.5e4;
AllData.AR_2.Pr_200.Ra_1e9.ICT = 1.2e4;
AllData.AR_2.Pr_200.Ra_2e8.ICT = 1.6e4;
AllData.AR_2.Pr_200.Ra_3e8.ICT = 1e4;
AllData.AR_2.Pr_200.Ra_6e8.ICT = 1e4;
AllData.AR_2.Pr_200.Ra_2e9.ICT = 4.1e4;
AllData.AR_2.Pr_200.Ra_3e9.ICT = 4.5e4;
AllData.AR_2.Pr_250.Ra_1e8.ICT = 8000;
AllData.AR_2.Pr_250.Ra_2e8.ICT = 6000;
AllData.AR_2.Pr_250.Ra_3e8.ICT = 9000;
AllData.AR_2.Pr_250.Ra_6e8.ICT = 8000;
AllData.AR_2.Pr_250.Ra_1e9.ICT = 7000;
AllData.AR_2.Pr_300.Ra_5e8.ICT = 8000;
AllData.AR_2.Pr_300.Ra_5e7.ICT = 2.7e4;
AllData.AR_2.Pr_300.Ra_1e8.ICT = 2.7e4;
AllData.AR_2.Pr_300.Ra_1e9.ICT = 1.3e4;
AllData.AR_2.Pr_300.Ra_2e8.ICT = 1e4;
AllData.AR_2.Pr_300.Ra_3e8.ICT = 1e4;
AllData.AR_2.Pr_300.Ra_6e8.ICT = 1e4;
AllData.AR_2.Pr_300.Ra_2e9.ICT = 4.5e4;
AllData.AR_2.Pr_300.Ra_3e9.ICT = 5e4;

AllData.AR_2.Pr_300.Ra_1e6.ICT = 1e4;
AllData.AR_2.Pr_300.Ra_2e6.ICT = 1e4;
AllData.AR_2.Pr_300.Ra_3e6.ICT = 1e4;
AllData.AR_2.Pr_300.Ra_6e5.ICT = 2e4;
AllData.AR_2.Pr_300.Ra_3e5.ICT = 2.5e4;
AllData.AR_2.Pr_300.Ra_4e5.ICT = 3e4;

AllData.AR_2.Pr_1000.Ra_6e5.ICT = 2000;
AllData.AR_2.Pr_1000.Ra_7e5.ICT = 2000;

AllData.AR_2.Pr_400000.Ra_2_6e7.ICT = 1;

% 1024x512 runs
AllData.AR_2.Pr_0_1.Ra_2e9.ICT = 3e4;
AllData.AR_2.Pr_0_3.Ra_2e9.ICT = 1e4;
AllData.AR_2.Pr_1.Ra_2e9.ICT = 2e3;
AllData.AR_2.Pr_3.Ra_2e9.ICT = 500;
AllData.AR_2.Pr_10.Ra_2e9.ICT = 2e3;
AllData.AR_2.Pr_100.Ra_2e9.ICT = 1e3;
AllData.AR_2.Pr_Inf.Ra_2e9.ICT = 200;

%% Subeset 1
AllData.AR_2.Pr_30.Ra_2e6.ICT = 200;
AllData.AR_2.Pr_30.Ra_4_5e6.ICT = 300;
AllData.AR_2.Pr_30.Ra_6_4e6.ICT = 3000;
AllData.AR_2.Pr_30.Ra_9e6.ICT = 1.178e4;
AllData.AR_2.Pr_1.Ra_6_4e6.ICT = 60;

%% Subeset 2
AllData.AR_2.Pr_0_1.Ra_3_7e4.ICT = 40;
AllData.AR_2.Pr_0_1.Ra_3_8e4.ICT = 40;
AllData.AR_2.Pr_10.Ra_3_2e4.ICT = 100;
AllData.AR_2.Pr_10.Ra_3_3e4.ICT = 100;
AllData.AR_2.Pr_1.Ra_1_1e6.ICT = 40;
AllData.AR_2.Pr_1.Ra_1_2e6.ICT = 40;
AllData.AR_2.Pr_0_01.Ra_7_85e2.ICT = 200;
AllData.AR_2.Pr_0_01.Ra_7_86e2.ICT = 600;

%% Subeset 3
AllData.AR_2.Pr_100.Ra_2e9.ICT = 1e3;
AllData.AR_2.Pr_10.Ra_2e8.ICT = 2500;
AllData.AR_2.Pr_1.Ra_2e7.ICT = 2.2e4;
AllData.AR_2.Pr_0_1.Ra_2e6.ICT = 2e5;

%% Do some Calcs
count = 0;
AR_list =string(fieldnames(AllData));
for i=1:length(AR_list)
    ARS = AR_list(i);
    Pr_list = string(fieldnames(AllData.(ARS)));
    for i=1:length(Pr_list)
        PrS = Pr_list(i);
        Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
        for i=1:length(Ra_list)
            RaS = Ra_list(i);
            if isfield(AllData.(ARS).(PrS).(RaS),'ICT')
                xlower = AllData.(ARS).(PrS).(RaS).ICT;
                count = count + 1;
                disp(count)
                if ARS == "AR_1"
                    run GetStateStuff2.m
                else
                    run GetStateStuff.m
                end
            end
        end
    end
end
%AllData = MeanQuantities(AllData,50);
cd /Users/philipwinchester/Dropbox/Matlab/Normal
clearvars -except AllData Data
