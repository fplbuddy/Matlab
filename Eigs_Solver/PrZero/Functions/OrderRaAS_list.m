function [RaAS_list_order, I]= OrderRaAS_list(RaAS_list)
    RaA = [];
    for i=1:length(RaAS_list)
       RaA = [RaA RaAStoRaA(RaAS_list(i))]; 
    end
    [~, I] = sort(RaA, 'ascend');
    RaAS_list_order = RaAS_list(I);
end