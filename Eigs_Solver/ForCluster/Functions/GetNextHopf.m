function [RaNext,Done] = GetNextHopf(M, thres)
    ImagPart = M(2,:); % Getting imag parts
    Ra_list =  M(1,:);
    [~,I] = find(ImagPart > thres);
    I = min(I);
    Ra1 = Ra_list(I-1);
    Ra2 = Ra_list(I);
    RaNext = round((Ra1+Ra2)/2, 3,'significant');
    if ismember(RaNext,Ra_list)
        Done = 1;
    else
        Done = 0;
    end
end

