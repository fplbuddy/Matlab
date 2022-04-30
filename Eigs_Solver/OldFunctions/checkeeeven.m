function res = checkeeeven(N, ninst, minst)
    n = [-(N/2-1):2:(N/2-1) -(N/2):2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:); % We want the negative ones here also, they might not appear actually... they will!
    m = 1:N; m = repelem(m, N/2); % Hava included -(N/2) even though it does not technically exist. Should think about what i do for this in v4
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

