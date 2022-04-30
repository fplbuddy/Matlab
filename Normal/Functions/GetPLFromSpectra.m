function [power,Rval,lower,upper] = GetPLFromSpectra(datam,Spectrum,N,thresh)
Rval = 0;
count = 0;
while Rval < thresh
    top = round(N/3) - count*5; % Move down if we are in tail of spectrum
    if top < N/16 % We have gone too far down
        power = NaN;
        Rval = NaN;
        lower = NaN;
        upper = NaN;
        break
    end
    K = 1:top;
    % Cut at N/3
    data = datam(1:top);
    upper = top;
    if Spectrum(2) == 'p' % we are dealing with theta
        lower = 2;
        data = data(2:2:end); % onle take even ones
        K = K(2:2:end);
    else
        lower = N/32;
        data = data(N/32:end); % remove some large scale ones
        K = K(N/32:end);
    end
    [power, ~, ~, ~, Rval] = FitsPowerLaw(K,data);
    count = count +1;
end
end

