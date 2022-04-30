function Raout = GetCrossings(M, SearchType,prec)
Raout = [];
sigma_list = M(2,:);
Ra_list = M(1,:);
% First check if we have crossing at al
signs = sign(sigma_list);
dsigns = diff(signs);
nc = length(dsigns) - nnz(~dsigns); % number of crossings
locs = find(abs(dsigns) == 2,nc);
for i=1:nc
    loc = locs(i);
    [~,Ra] = GetNextRaCompliment(loc,Ra_list,SearchType,sigma_list,prec);
    Raout = [Raout Ra];
end
end



