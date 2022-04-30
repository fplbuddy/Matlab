function w = ws(Ra,Pr,pm)
    if pm == 'p'
    w = (-Pr-1 + srs(Ra, Pr))/2;
    else
    w = (-Pr-1 - srs(Ra, Pr))/2;
    end
end

