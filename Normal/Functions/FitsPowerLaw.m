function [alpha, A, xFitted, yFitted, Rval] = FitsPowerLaw(x,y)  
    if y(1) > 0
        mdl = fitlm(log(x), log(y));
        A = exp(mdl.Coefficients.Estimate(1));
        alpha = real(mdl.Coefficients.Estimate(2));
        xFitted = logspace(floor(log10(min(x))), ceil(log10(max(x))),100); 
        yFitted = A*xFitted.^alpha;
        Rval = real(mdl.Rsquared.Adjusted);
    elseif y(1) < 0 
        y = -y;
        mdl = fitlm(log(x), log(y));
        A = -exp(mdl.Coefficients.Estimate(1));
        alpha = mdl.Coefficients.Estimate(2);
        xFitted = logspace(floor(log10(min(x))), ceil(log10(max(x))),100); 
        yFitted = A*xFitted.^alpha;
        Rval = real(mdl.Rsquared.Adjusted);
    end
end