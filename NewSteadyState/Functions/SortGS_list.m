function [GS_list,I] = SortGS_list(GS_list)
    for i=1:length(GS_list)
        GS = GS_list(i);
        G = GStoG(GS);
        G_list(i) = G;
    end  
    [~,I] = sort(G_list);
    GS_list = GS_list(I);
    
end

