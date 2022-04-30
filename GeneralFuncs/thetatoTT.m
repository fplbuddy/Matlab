function TT = thetatoTT(theta)
    s = ones(height(theta),width(theta));
    Ny = height(theta);
    dy = 1/Ny;
    ylist = flip((0:(Ny-1))*dy+dy/2);
    TT = theta + s.*ylist';
end