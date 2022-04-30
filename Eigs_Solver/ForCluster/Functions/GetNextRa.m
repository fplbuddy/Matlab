function [Done,RaNew] = GetNextRa(M)%,trans)  
    sigmas = M(2,:);
    Ras = M(1,:);
%     if trans
%     s = sign(sigmas(1));
%     all = find(sign(sigmas) == s);
%     d = diff(all);
%     d = find(d ~= 1,1);
%     d = d + 1;
%     sigmas(1:d) = [];
%     end
    order = sign(sigmas(1));
    if order == -1
        lastNeg = find(sign(sigmas) == -1,1,'last');
        sigmaNeg = sigmas(lastNeg);
        sigmaPos = sigmas(lastNeg+1);
        RaNeg = Ras(lastNeg);
        RaPos = Ras(lastNeg+1);
        lengthSigma = abs(sigmaNeg) + sigmaPos;
        lengthRa = abs(RaPos - RaNeg);
        frac = abs(sigmaNeg)/lengthSigma;
        RaNew = RaNeg + frac*lengthRa;
        RaNew = round(RaNew, 3, 'significant');
        Done = ismember(RaNew,Ras);
    else
        lastPos = find(sign(sigmas) == 1,1,'last');
        sigmaPos = sigmas(lastPos);
        sigmaNeg = sigmas(lastPos+1);
        RaPos = Ras(lastPos);
        RaNeg = Ras(lastPos+1);
        lengthSigma = abs(sigmaNeg) + sigmaPos;
        lengthRa = abs(RaPos - RaNeg);
        frac = abs(sigmaPos)/lengthSigma;
        RaNew = RaPos + frac*lengthRa;
        RaNew = round(RaNew, 3, 'significant');
        Done = ismember(RaNew,Ras);
    end
end

