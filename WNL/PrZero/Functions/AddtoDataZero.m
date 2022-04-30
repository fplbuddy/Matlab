function WNLZero = AddtoDataZero(WNLZero,GS,As,Fs,sigmas)
try
    check = isfield(WNLZero.(GS),"As");
catch
    check = 0;
end




if check
    As = [WNLZero.(GS).As As];
    Fs = [WNLZero.(GS).Fs Fs];
    sigmas = [WNLZero.(GS).sigmas sigmas];
    % cleaning
    [As,I] = unique(As,'stable');
    Fs = Fs(I);
    sigmas = sigmas(I);
    % sort
    [As,I] = sort(As);
    Fs = Fs(I);
    sigmas = sigmas(I);
end
WNLZero.(GS).As = As;
WNLZero.(GS).Fs = Fs;
WNLZero.(GS).sigmas = sigmas;
end