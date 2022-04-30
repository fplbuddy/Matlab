function res = checkoetwonew(ninst, minst, N)
% addapted to only look at when kxe - kxo = kx
neven = [-(N/2-1):2:(N/2-1) -(N/2):2:(N/2-2)]; neven = repmat(neven, N/2); neven = neven(1,:); % We want the negative ones here also, they might not appear actually... they will!
meven = 1:N; meven = repelem(meven, N/2);
res = [zeros(N^2/2,2) reshape(neven, N^2/2,1) reshape(meven, N^2/2,1)];
rem = [];
for i=1:length(neven)
    neveninst = res(i,3);
    meveninst = res(i,4);
    noddinst = ninst - neveninst;
    moddinst = - minst + meveninst;
    if -N/2 <= noddinst && noddinst < N/2 && moddinst <= N && moddinst >= 1 
        res(i,1) = noddinst;
        res(i,2) = moddinst;
    else
        rem = [i rem];
    end
end
res(rem,:) = [];
end

