function pos = findpositionOld(ninst, minst, Nx)
ncheck1 = 1:2:(Nx/2-1); ncheck2 = 0:2:(Nx/2-2);
if ismember(abs(ninst), ncheck1)
    npos = find(ncheck1 == abs(ninst));
else
    npos = find(ncheck2 == abs(ninst));
end
pos = 1 + (Nx/4)*(minst - 1) + npos - 1;
end

