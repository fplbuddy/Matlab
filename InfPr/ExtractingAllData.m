clear
%%
Ly = 1;
TE = 'latex';
home = '/Users/philipwinchester/Desktop/Work/Matlab/InfPr/';
Calcs = '/Users/philipwinchester/Desktop/Work/Matlab/InfPr/Calcs';
Functions = '/Users/philipwinchester/Desktop/Work/Matlab/InfPr/Functions';
Randomplots = '/Users/philipwinchester/Desktop/Work/Matlab/InfPr/Random_Plots';
addpath(home);
addpath(Calcs); 
addpath(Functions);
addpath(Randomplots);
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
%%
Mpath = "/Volumes/Samsung_T5/PrInfTest/";
cd /Volumes/Samsung_T5/PrInfTest/
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
            if contains(AllFolders(k),"Pr")
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
                % Now we save stuff
                path = join([Mpath ARP "/" ResP "/" PrS "/" RaS],"");
                % General info
                AllData.(ARP).(PrS).(RaS).Ra = str2double(erase(strrep(RaS,"_","."),"Ra."));
                AllData.(ARP).(PrS).(RaS).Pr = str2double(erase(strrep(PrS,"_","."),"Pr."));
                Ra = AllData.(ARP).(PrS).(RaS).Ra;
                Pr = AllData.(ARP).(PrS).(RaS).Pr;
                AllData.(ARP).(PrS).(RaS).Res = ResP;
                AllData.(ARP).(PrS).(RaS).kappa = sqrt((pi*Ly)^3/(Ra*Pr));
                AllData.(ARP).(PrS).(RaS).nu = sqrt((pi*Ly)^3*Pr/(Ra));
                AllData.(ARP).(PrS).(RaS).AR = str2double(erase(erase(strrep(ARP,"_","."),"AR."),"AR"));
                RaT = RatoRaT(Ra);
                dp = num2str(find(num2str(Ra) ~= '0', 1, 'last' )-1); % How many dp we want in Ra
                AllData.(ARP).(PrS).(RaS).title = join(["Pr = " convertCharsToStrings(num2str(Pr)) ", Ra = " convertCharsToStrings(RaT)],"");
                AllData.(ARP).(PrS).(RaS).path = path;
            end
        end
    end
end

cd /Users/philipwinchester/Desktop/Work/Matlab/InfPr/
clearvars -except AllData
