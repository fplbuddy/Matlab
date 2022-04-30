function ARC = ClosestAr(AR,ARs)
    AR = convertStringsToChars(AR);
    G = str2num(strrep(AR(4:end),'_','.'));
    dif_array = zeros(1,length(ARs));
    for i=1:length(ARs)
        ARcheck = convertStringsToChars(ARs(i));
        Gcheck = str2num(strrep(ARcheck(4:end),'_','.'));
        dif_array(i) = abs(Gcheck-G);
    end
    [~,I] = min(dif_array);
    ARC = ARs(I);
end

