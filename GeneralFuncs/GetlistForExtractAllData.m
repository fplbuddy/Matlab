function outlist = GetlistForExtractAllData(path,locfor)
    AllFolders = dir(path);
    AllFolders = extractfield(AllFolders,'name');
    outlist = [];
    for k = 1:length(AllFolders)
        if strncmp(locfor,AllFolders(k),1)
            outlist = [outlist AllFolders(k)]; % Finding which Re have
        end
    end
    outlist = string(outlist);
end

