function [alpha, A, xFitted, yFitted, Rval] = FitsLinear(x,y)
    mdl = fitlm(x, y);
    A = mdl.Coefficients.Estimate(1);
    alpha = mdl.Coefficients.Estimate(2);
    xFitted = linspace(min(x), max(x),100);
    yFitted = A+xFitted*alpha;
    Rval = real(mdl.Rsquared.Adjusted);
end