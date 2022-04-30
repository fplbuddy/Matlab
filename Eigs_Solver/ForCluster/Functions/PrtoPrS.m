function PrS = PrtoPrS(Pr)
if Pr >=1e-4
    PrS = ['Pr_' num2str(floor(Pr))];
    n=0;
    while (floor(Pr*10^n)~=Pr*10^n)
        n=n+1;
    end

    if n > 0
       dec = num2str(Pr-floor(Pr), n);
       dec = dec(3:end);
       PrS = [PrS '_' dec];
    end
% other naming in Pr < 1e-4
else
    PrChar = num2str(Pr);
    PrChar = strrep(PrChar,'.','_');
    power = num2str(-ceil(abs(log10(Pr))));
    if power > -10
       PrChar(end-1) = []; % Removing residual 0
    end
    PrS = ['Pr_' PrChar];
    PrS = strrep(PrS,'-','_'); % Does not like minus sign in naming
end
end

