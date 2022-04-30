function sr = sre(Ra,Pr, ws, xs)
    % Square root that is in the eigenvalue problem
    sr = (4*Pr*Ra*(1+xs)+(Pr + ws-1)^2)^0.5;
end

