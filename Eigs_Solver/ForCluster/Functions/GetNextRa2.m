function [Done,RaNew] = GetNextRa2(M, SearchType,prec)
sigma_list = M(2,:);
Ra_list = M(1,:);
% First check if we have crossing at al
signs = sign(sigma_list);
dsigns = diff(signs);
nc = length(dsigns) - nnz(~dsigns); % number of crossings
locs = find(abs(dsigns) == 2,nc);
for i=1:nc
    loc = locs(i);
    [Done,RaNew] = GetNextRaCompliment(loc,Ra_list,SearchType,sigma_list,prec);
    if Done
        continue
    else
        break
    end
end
end



