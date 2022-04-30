function e = eigen(Ra,Pr, ws, xs)
    e = (Pr + 3*ws +1 + sre(Ra,Pr, ws, xs))/2;   
end

