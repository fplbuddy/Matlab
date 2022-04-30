function [alpha, A, xFitted, yFitted, Rval] = Fitslogy(x,y)
    if y(1) > 0
        mdl = fitlm(x, log(y));
        A = exp(mdl.Coefficients.Estimate(1));
        alpha = real(mdl.Coefficients.Estimate(2));
        xFitted = linspace(floor(min(x)), ceil(max(x)),100); 
        yFitted = A*exp(xFitted*alpha);
        Rval = real(mdl.Rsquared.Adjusted);
    else
        y = -y;
        mdl = fitlm(x, log(y));
        A = -exp(mdl.Coefficients.Estimate(1));
        alpha = real(mdl.Coefficients.Estimate(2));
        xFitted = linspace(floor(min(x)), ceil(max(x)),100); 
        yFitted = A*exp(xFitted*alpha);
        Rval = real(mdl.Rsquared.Adjusted);
end