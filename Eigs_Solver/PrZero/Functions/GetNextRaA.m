function [Done,RaANew] = GetNextRaA(M)  
sigma_list = M(2,:);
RaA_list = M(1,:);
% First check if we have crossing at al
signs = sign(sigma_list);
dsigns = diff(signs);
nc = length(dsigns) - nnz(~dsigns); % number of crossings
if not(ismember(1,signs)) % ie, we do not have a crossing
    RaANew = max(RaA_list)*2;
    Done = 0;
elseif nc == 1 % we have one crossing
    firstpos = find(sign(sigma_list) == 1,1,'first');
    RaANew = (RaA_list(firstpos-1) + RaA_list(firstpos))/2;
    RaANew = round(RaANew, 3, 'significant');
    Done = ismembertol(RaANew,RaA_list);
else % We have three crossings
    Done = 0;
    % deal with first crossing first
    firstpos = find(sign(sigma_list) == 1,1,'first');
    RaANew = (RaA_list(firstpos-1) + RaA_list(firstpos))/2;
    RaANew = round(RaANew, 3, 'significant');
    partDone = ismembertol(RaANew,RaA_list);
    if partDone % If I have done first bit
        % second crossing
        loc = find(dsigns == -2,1,'first');
        RaANew = (RaA_list(loc) + RaA_list(loc+1))/2;
        RaANew = round(RaANew, 3, 'significant');
        partDone = ismembertol(RaANew,RaA_list);
        if partDone % If I have done first and second bit
            % third crossing
            loc = find(dsigns == 2,1,'last');
            RaANew = (RaA_list(loc) + RaA_list(loc+1))/2;
            RaANew = round(RaANew, 3, 'significant');
            Done = ismembertol(RaANew,RaA_list);      
        end
        
    end
    
end

