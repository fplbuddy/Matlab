function GS = GtoGS(g)
if g >=1e-4
    GS = ['G_' num2str(floor(g))];
    n=0;
    while (floor(g*10^n)~=g*10^n)
        n=n+1;
    end

    if n > 0
       dec = num2str(g-floor(g), n);
       dec = dec(3:end);
       GS = [GS '_' dec];
    end
% other naming in Pr < 1e-4
else
    PrChar = num2str(g);
    PrChar = strrep(PrChar,'.','_');
    power = num2str(-ceil(abs(log10(g))));
    if power > -10
       PrChar(end-1) = []; % Removing residual 0
    end
    GS = ['G_' PrChar];
    GS = strrep(GS,'-','_'); % Does not like minus sign in naming
end
end

