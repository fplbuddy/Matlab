function res = checkeenew(N, ninst, minst)
% Dont think the n=-Nx/2 causes a problem as it will not turn up
% (-Nx/2)*n < 0, and we dont consider the complex conjugates
n = [-(N/2-1):2:(N/2-1) -(N/2):2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:); % We want the negative ones here also, they might not appear actually... they will!
m = 1:N; m = repelem(m, N/2);
res = zeros(N^2,4);
loc = 0;
for i=1:length(n)
    n1 = n(i);
    n2 = ninst - n1;
    if -N/2 <= n2 && n2 < N/2
        m1 = m(i);
        m21 = minst - m1;
        m22 = - minst + m1;
        m23 =  minst + m1;
        if checkifaddee(n1, m1, n2, m21, N)
            loc = loc + 1;
            res(loc,1) = n1; res(loc,2) = m1; res(loc,3) = n2; res(loc,4) = m21;
        end
        if checkifaddee(n1, m1, n2, m22, N)
            loc = loc + 1;
            res(loc,1) = n1; res(loc,2) = m1; res(loc,3) = n2; res(loc,4) = m22;
        end
        if checkifaddee(n1, m1, n2, m23, N)
            loc = loc + 1;
            res(loc,1) = n1; res(loc,2) = m1; res(loc,3) = n2; res(loc,4) = m23;
        end
    end
end
res(loc+1:end,:) = [];
end

