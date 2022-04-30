function yy = polyvalA(c,H,xx)
    M = length(xx); n = size(H,2); V = ones(M,1);
    for k = 1:n
    v = xx.*V(:,k);
    for j = 1:k
    v = v - H(j,k)*V(:,j);
    end
    V = [V v/H(k+1,k)];
    end
    yy = V*c;
end

