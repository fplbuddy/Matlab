function [c,H] = polyfitA(x,y,n)
M = length(x); V = ones(M,1); H = zeros(n+1,n);
for k = 1:n
    v = x.*V(:,k);
    for j = 1:k
        H(j,k) = V(:,j)'*v/M;
        v = v - H(j,k)*V(:,j);
    end
    H(k+1,k) = norm(v)/sqrt(M);
    V = [V v/H(k+1,k)];
end
c = V'*y/M;
end

