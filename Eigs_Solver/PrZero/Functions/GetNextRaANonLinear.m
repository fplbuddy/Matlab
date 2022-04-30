function RaANew = GetNextRaANonLinear(M)%,trans) 
    % M is a 2x2 which onle has where the crossing is
    sigmas = M(2,:);
    RaA_list = M(1,:);
    order = sign(sigmas(1));
    if order == -1 % Going from negative to positive
        lastNeg = 1;
        sigmaNeg = sigmas(lastNeg);
        sigmaPos = sigmas(lastNeg+1);
        RaANeg = RaA_list(lastNeg);
        RaAPos = RaA_list(lastNeg+1);
        lengthSigma = abs(sigmaNeg) + sigmaPos;
        fracZero = abs(sigmaNeg)/lengthSigma; % How long we have to 0
        fracRa = RaAPos/RaANeg;
        RaANew = RaANeg*fracRa^fracZero;
        RaANew = round(RaANew, 3, 'significant');
    else % Going from posirive to negative
        lastPos = 1;
        sigmaPos = sigmas(lastPos);
        sigmaNeg = sigmas(lastPos+1);
        RaAPos = RaA_list(lastPos);
        RaANeg = RaA_list(lastPos+1);
        lengthSigma = abs(sigmaNeg) + sigmaPos;
        fracZero = abs(sigmaPos)/lengthSigma;
        fracRa = RaANeg/RaAPos;
        RaANew = RaAPos*fracRa^fracZero;
        RaANew = round(RaANew, 3, 'significant');
    end
end

