function [Done,RaNew] = GetNextRaCompliment(loc,Ra_list,SearchType,sigma_list,prec)
Ralower = Ra_list(loc);
Raupper = Ra_list(loc+1);
if SearchType == "NonLinear"
    sigmalower = sigma_list(loc);
    sigmaupper = sigma_list(loc+1);
    lengthSigma = abs(sigmaupper) + abs(sigmalower);
    fracZero = abs(sigmalower)/lengthSigma;
    fracRa = Raupper/Ralower;
    RaNew = Ralower*fracRa^fracZero;
elseif SearchType == "Simple"
    RaNew = (Ralower + Raupper)/2;
    
elseif SearchType == "Secant"
    sigmalower = sigma_list(loc);
    sigmaupper = sigma_list(loc+1);
    RaNew = Raupper - sigmaupper*(Raupper-Ralower)/(sigmaupper-sigmalower);
end
RaNew = round(RaNew, prec, 'significant');
Done = ismembertol(RaNew,Ra_list);
end



