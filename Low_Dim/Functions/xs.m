function x = xs(Ra,Pr,pm)
    if pm == 'p'
        x = (Pr - 2*Ra*Pr-1 + srs(Ra, Pr))/(2*Ra*Pr);
    else 
        x = (Pr - 2*Ra*Pr-1 - srs(Ra, Pr))/(2*Ra*Pr); 
    end
end

