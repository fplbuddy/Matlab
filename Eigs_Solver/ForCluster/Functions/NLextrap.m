function [RaNew] = NLextrap(sigmaUpper,sigmaLower,RaUpper, RaLower)
    lengthSigma = abs(sigmaUpper) + abs(sigmaLower);
    fracZero = abs(sigmaLower)/lengthSigma;
    fracRa = RaUpper/RaLower;
    RaNew = RaLower*fracRa^fracZero;
    RaNew = round(RaNew, 3, 'significant');
end

