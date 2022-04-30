function [RaNext,Done] = GetNextRaThreeCrossings(M)
    try 
    sigma_list = M(2,:);
    Ra_list = M(1,:);
    signs = sign(sigma_list);
    dsigns = diff(signs);
    Done = 0;
    % deal with first crossing first
    loc = find(dsigns == 2,1,'first');
    RaUpper = Ra_list(loc+1);
    RaLower = Ra_list(loc);
    sigmaUpper = sigma_list(loc)+1;
    sigmaLower = sigma_list(loc);
    RaNext = NLextrap(sigmaUpper,sigmaLower,RaUpper, RaLower);
    partDone = ismembertol(RaNext,Ra_list);
    if partDone % If I have done first bit
        % second crossing
        loc = find(dsigns == -2,1,'first');
        if length(loc) == 0
            error
        end
        RaUpper = Ra_list(loc+1);
        RaLower = Ra_list(loc);
        sigmaUpper = sigma_list(loc+1);
        sigmaLower = sigma_list(loc);
        RaNext = NLextrap(sigmaUpper,sigmaLower,RaUpper, RaLower);
        partDone = ismembertol(RaNext,Ra_list);
        if partDone % If I have done first and second bit
            % third crossing
            loc = find(dsigns == 2,1,'last');
            if length(loc) == 0
                error
            end
            RaUpper = Ra_list(loc+1);
            RaLower = Ra_list(loc);
            sigmaUpper = sigma_list(loc+1);
            sigmaLower = sigma_list(loc);
            RaNext = NLextrap(sigmaUpper,sigmaLower,RaUpper, RaLower);
            Done = ismembertol(RaNext,Ra_list);
        end
    end
    catch
        Done = 1;
        RaNext = 1;
    end
end

