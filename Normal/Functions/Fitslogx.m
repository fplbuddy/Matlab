function [alpha, A, xFitted, yFitted, Rval] = Fitslogx(x,y)
    mdl = fitlm(log(x), y);
    alpha = real(mdl.Coefficients.Estimate(2));
    A = exp(mdl.Coefficients.Estimate(1));
    %A = mdl.Coefficients.Estimate(1);
    xFitted = linspace(floor(min(x)), ceil(max(x)),100);
    yFitted = log(A*xFitted.^alpha);
    Rval = real(mdl.Rsquared.Adjusted);
end