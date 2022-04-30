function [PrS_list_order, I]= OrderPrS_list(PrS_list)
    Pr = [];
    for i=1:length(PrS_list)
       Pr = [Pr PrStoPr(PrS_list(i))]; 
    end
    [~, I] = sort(Pr, 'ascend');
    PrS_list_order = PrS_list(I);
end

