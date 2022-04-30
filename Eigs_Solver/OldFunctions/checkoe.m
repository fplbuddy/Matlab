function res = checkoe(ninst, minst, N)
neven = [-(N/2-1):2:(N/2-1) -(N/2):2:(N/2-2)]; neven = repmat(neven, N/2); neven = neven(1,:); % We want the negative ones here also, they might not appear actually... they will!
meven = 1:N; meven = repelem(meven, N/2);
nodd = [-(N/2):2:(N/2-2) -(N/2-1):2:(N/2-1)]; nodd = repmat(nodd, N/2); nodd = nodd(1,:);
modd = meven;
res = [];
for i=1:length(neven)
    neveninst = neven(i); meveninst = meven(i);
    for j=1:length(nodd)
        noddinst = nodd(j); moddinst = modd(j);
        if ninst == neveninst + noddinst && (minst == meveninst + moddinst || minst == abs(meveninst - moddinst))
            s = size(res);
            res(s(1)+1, 1) = noddinst; res(s(1)+1, 2) = moddinst; res(s(1)+1, 3) = neveninst; res(s(1)+1, 4) = meveninst;
        end
    end
end
end

