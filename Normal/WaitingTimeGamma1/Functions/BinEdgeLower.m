function I = BinEdgeLower(binedges,number,lower,upper)
    if upper - lower == 1
        I = lower; % we are done
    else
        m = round(mean([lower,upper]));
        check = number >= binedges(m);
        if check % ie numner is greater that where we checker 
            upper = m;
        else
            lower = m;
        end
        I = BinEdgeLower(binedges,number,lower,upper); % Call function again
    end  
end

