clear
%% Set up
PrS = "Pr_30";
Ly = 1;
TE = 'latex';
home = '/Users/philipwinchester/Dropbox/Dropbox/Matlab/SandNSICs';
Functions = [home '/Functions'];
addpath(home);
addpath(Functions)
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
%%
Mpath = "/Volumes/Samsung_T5/SorNSICs/";
cd /Volumes/Samsung_T5/SorNSICs/
% Finding ICs
path = Mpath;
IC_list = string(extractfield(dir(path),'name'));
IC_list = IC_list(3:end); % Gets rid of the dots at the start, not very rigorous...
% Looping Round ICs
for i = 1:length(IC_list)
    IC = IC_list(i);
    path = join([Mpath IC],"");
    Ra_list = string(extractfield(dir(path),'name'));
    Ra_list = Ra_list(3:end); % Gets rid of the dots at the start, not very rigorous... 
    % Looping round Ra
    for i=1:length(Ra_list)
        RaS = Ra_list(i);
        path = join([Mpath IC "/" RaS],"");
        % Saving Stuff
        AllData.(IC).(RaS).Ra = str2double(erase(strrep(RaS,"_","."),"Ra."));
        AllData.(IC).(RaS).Pr = str2double(erase(strrep(PrS,"_","."),"Pr."));
        Ra = AllData.(IC).(RaS).Ra;
        Pr = AllData.(IC).(RaS).Pr;
        AllData.(IC).(RaS).kappa = sqrt((pi*Ly)^3/(Ra*Pr));
        AllData.(IC).(RaS).nu = sqrt((pi*Ly)^3*Pr/(Ra));
        RaT = RatoRaT(Ra);
        dp = num2str(find(num2str(Ra) ~= '0', 1, 'last' )-1); % How many dp we want in Ra
        AllData.(IC).(RaS).title = ['Pr = ' num2str(Pr) ', Ra = ' RaT];
        AllData.(IC).(RaS).path = path;      
    end
end
cd /Users/philipwinchester/Dropbox/Dropbox/Matlab/SandNSICs/
clearvars -except AllData
