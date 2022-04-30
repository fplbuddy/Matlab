function res = checkee(Nx, Ny, ninst, minst)
% Dont think the n=-Nx/2 causes a problem as it will not turn up
% (-Nx/2)*n < 0, and we dont consider the complex conjugates
n = [-(Nx/2-1):2:(Nx/2-1) -(Nx/2):2:(Nx/2-2)]; n = repmat(n, Ny/2); n = n(1,:); % We want the negative ones here also, they might not appear actually... they will!
m = 1:Ny; m = repelem(m, Nx/2);
res = [];
for i=1:length(n)
    n1 = n(i); m1 = m(i);
    for j=1:length(n)
        n2 = n(j); m2 = m(j);
        if ninst == n2 + n1 && (minst == m1 + m2 || minst == abs(m1 - m2)) && not(n1 == n2 && m1 == m2)
            s = size(res);
            res(s(1)+1, 1) = n1; res(s(1)+1, 2) = m1; res(s(1)+1, 3) = n2; res(s(1)+1, 4) = m2;
        end
    end
end
end

