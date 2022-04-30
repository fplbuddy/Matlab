function GCS = ClosestG(G, WNLData,remsame)
    GS_list = string(fields(WNLData));
    Results = zeros(length(GS_list), 1);
    for i=1:length(GS_list)
        GCheck = GStoG(GS_list(i));
        Results(i) = abs(G - GCheck);
    end
    if remsame
        Results(Results == 0) = [];
    end
    [~,I] = min(Results);
    GCS= GS_list(I);
end

