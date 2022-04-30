function [kappa_list,n_list] = Getkappa_list(AllData,fS,hnuS,o1S,o2S,nuS)
    % Inititation output lists
    kappa_list = [];
    n_list = [];
    % Finding which resolutions we have
    nS_list = string(fields(AllData));
    for i=1:length(nS_list) % looping rounds resolutions
        nS = nS_list(i);
        % check that we have data at this resolution
        try
            n = convertStringsToChars(nS); n = str2double(n(3:end));
            kappaS_list = string(fields(AllData.(nS).(o1S).(o2S).(fS).(hnuS).(nuS)));
            for j=1:length(kappaS_list)
                kappaS = kappaS_list(j);
                kappa = StoNormal(kappaS,7);
                kappa_list = [kappa_list kappa]; 
                n_list = [n_list n];
            end
        catch
        end  
    end
end

