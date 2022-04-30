function [Ra_list_order, I]= OrderRaS_list(RaS_list)
    Ra = [];
    for i=1:length(RaS_list)
       Ra = [Ra RaStoRa(RaS_list(i))]; 
    end
    [~, I] = sort(Ra, 'ascend');
    Ra_list_order = RaS_list(I);
end