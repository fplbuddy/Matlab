function [Done,RaANew] = GetNextRaA2nss(M, SearchType,prec)
sigma_list = M(2,:);
RaA_list = M(1,:);
% First check if we have crossing at al
signs = sign(sigma_list);
dsigns = diff(signs);
nc = length(dsigns) - nnz(~dsigns); % number of crossings
if nc == 1
    loc = find(dsigns == -2,1,'first'); % positive to neg
    if isempty(loc)
        loc = find(dsigns == 2,1,'first'); % neg to pos
    end
    RaAlower = RaA_list(loc);
    RaAupper = RaA_list(loc+1);
    if SearchType == "NonLinear"
        sigmalower = sigma_list(loc);
        sigmaupper = sigma_list(loc+1);
        lengthSigma = abs(sigmaupper) + abs(sigmalower);
        fracZero = abs(sigmalower)/lengthSigma;
        fracRaA = RaAupper/RaAlower;
        RaANew = RaAlower*fracRaA^fracZero;
    elseif SearchType == "Simple"
        RaANew = (RaAlower + RaAupper)/2;
    end
    RaANew = round(RaANew, prec, 'significant');
    Done = ismembertol(RaANew,RaA_list);
else %2
    Done = 0;
    loc = find(dsigns == -2,1,'first');
    RaAPos = RaA_list(loc);
    RaANeg = RaA_list(loc+1);
    sigmaPos = sigma_list(loc);
    sigmaNeg = sigma_list(loc+1);
    lengthSigma = abs(sigmaNeg) + sigmaPos;
    fracZero = abs(sigmaPos)/lengthSigma;
    fracRaA = RaANeg/RaAPos;
    RaANew = RaAPos*fracRaA^fracZero;
    RaANew = round(RaANew, 3, 'significant');
    partDone = ismembertol(RaANew,RaA_list);
    if partDone % If I have done first bit
        % second crossing
        loc = find(dsigns == 2,1,'first');
        sigmaNeg = sigma_list(loc);
        sigmaPos = sigma_list(loc+1);
        RaANeg = RaA_list(loc);
        RaAPos = RaA_list(loc+1);
        lengthSigma = abs(sigmaNeg) + sigmaPos;
        fracZero = abs(sigmaNeg)/lengthSigma; % How long we have to 0
        fracRa = RaAPos/RaANeg;
        RaANew = RaANeg*fracRa^fracZero;
        RaANew = round(RaANew, 3, 'significant');
        Done = ismembertol(RaANew,RaA_list);
    end
end
end



