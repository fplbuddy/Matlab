function epsS = epstoepsS(eps)
if eps >=1e-4
    epsS = ['eps_' num2str(floor(eps))];
    n=0;
    while (floor(eps*10^n)~=eps*10^n)
        n=n+1;
    end

    if n > 0
       dec = num2str(eps-floor(eps), n);
       dec = dec(3:end);
       epsS = [epsS '_' dec];
    end
% other naming in Pr < 1e-4
else
    PrChar = num2str(eps);
    PrChar = strrep(PrChar,'.','_');
    power = num2str(-ceil(abs(log10(eps))));
    if power > -10
       PrChar(end-1) = []; % Removing residual 0
    end
    epsS = ['eps_' PrChar];
    epsS = strrep(epsS,'-','_'); % Does not like minus sign in naming
end
end

