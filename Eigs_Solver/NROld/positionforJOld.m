function [realpos, imagpos] = positionforJOld(ninst, minst, Nx, Ny, type)
ncheck1 = 1:2:(Nx/2-1); ncheck2 = 0:2:(Nx/2-2);
if ismember(abs(ninst), ncheck1)
    npos = find(ncheck1 == abs(ninst));
else
    npos = find(ncheck2 == abs(ninst));
end
pos = 1 + (Nx/4)*(minst - 1) + npos - 1;

if type == 1
    realpos = 1 + (pos-1)*2;
elseif type == 2
    realpos = Nx*Ny/2 + 1 + (pos-1)*2;
end
imagpos = realpos + 1;
end

