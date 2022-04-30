function [Done,RaNew] = GetNextRaNonLinear(M)%,trans)  
    sigmas = M(2,:);
    Ras = M(1,:);
    order = sign(sigmas(1));
    if order == -1 % Going from negative to positive
        lastNeg = find(sign(sigmas) == -1,1,'last');
        sigmaNeg = sigmas(lastNeg);
        sigmaPos = sigmas(lastNeg+1);
        RaNeg = Ras(lastNeg);
        RaPos = Ras(lastNeg+1);
        lengthSigma = abs(sigmaNeg) + sigmaPos;
        fracZero = abs(sigmaNeg)/lengthSigma; % How long we have to 0
        fracRa = RaPos/RaNeg;
        RaNew = RaNeg*fracRa^fracZero;
        RaNew = round(RaNew, 3, 'significant');
        Done = ismember(RaNew,Ras);
    else % Going from posirive to negative
        lastPos = find(sign(sigmas) == 1,1,'last');
        sigmaPos = sigmas(lastPos);
        sigmaNeg = sigmas(lastPos+1);
        RaPos = Ras(lastPos);
        RaNeg = Ras(lastPos+1);
        lengthSigma = abs(sigmaNeg) + sigmaPos;
        fracZero = abs(sigmaPos)/lengthSigma;
        fracRa = RaNeg/RaPos;
        RaNew = RaPos*fracRa^fracZero;
        RaNew = round(RaNew, 3, 'significant');
        Done = ismember(RaNew,Ras);
    end
end

