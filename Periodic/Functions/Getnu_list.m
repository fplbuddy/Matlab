function [nu_list,n_list] = Getnu_list(AllData,fS,hnuS,o1S,o2S,kappaS)
    % Inititation output lists
    nu_list = [];
    n_list = [];
    % Finding which resolutions we have
    nS_list = string(fields(AllData));
    for i=1:length(nS_list) % looping rounds resolutions
        nS = nS_list(i)
        n = convertStringsToChars(nS); n = str2double(n(3:end));
        try % debugginf try
        nuS_list = string(fields(AllData.(nS).(o1S).(o2S).(fS).(hnuS)));
        for j = 1:length(nuS_list) % looping round nuS
            nuS = nuS_list(j);
            if isfield(AllData.(nS).(o1S).(o2S).(fS).(hnuS).(nuS),kappaS)
                nu = AllData.(nS).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).nu;
                nu_list = [nu_list nu]; 
                n_list = [n_list n];
            end
            
        end
        catch
        end
    end
end

