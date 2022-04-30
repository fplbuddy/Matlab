function [GCS,GCS2,GCS3] = ClosestG(G, Data)
    GS_list = string(fields(Data));
    [GS_list,~] = SortGS_list(GS_list);
    Results = zeros(length(GS_list), 1);
    for i=1:length(GS_list)
        GCheck = GStoG(GS_list(i));
        Results(i) = abs(G - GCheck);
    end
    [~,I] = min(Results);
    GCS= GS_list(I);
    try
    GCS2 = GS_list(I+1);
    GCS3 = GS_list(I-1);
    catch
    try
       GCS2 = GS_list(I+1); 
        GCS3 = GS_list(I+1);
    catch
        GCS3 = GS_list(I-1);
        GCS2 = GS_list(I-1);
    end
    
        
    end
end

