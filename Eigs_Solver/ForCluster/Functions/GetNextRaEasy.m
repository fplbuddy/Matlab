function [RaNext,Done] = GetNextRaEasy(M)
    sigma_list = M(2,:);
    Ra_list = M(1,:);
    signs = sign(sigma_list);
    dsigns = diff(signs);
    Done = 0;
    % deal with first crossing first
    loc = find(dsigns == 2,1,'first');
    RaUpper = Ra_list(loc+1);
    RaLower = Ra_list(loc);
    RaNext = (RaUpper + RaLower)/2;
    RaNext = round(RaNext, 3, 'significant');
    Done = ismembertol(RaNext,Ra_list);
end

