function [Done,RaANew] = GetNextRaACompliment(loc,RaA_list,SearchType,sigma_list,prec)
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
end



