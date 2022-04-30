function res = checkoenew(ninst, minst, N)
    neven = [-(N/2-1):2:(N/2-1) -(N/2):2:(N/2-2)]; neven = repmat(neven, N/2); neven = neven(1,:); % We want the negative ones here also, they might not appear actually... they will!
    meven = 1:N; meven = repelem(meven, N/2);
    res = [zeros(3*N^2/2,2) reshape(repelem(neven,3), 3*N^2/2,1) reshape(repelem(meven,3), 3*N^2/2,1)];
    %rem = [];
    rem = zeros(3*N^2/2,1);
    for i=1:length(neven)
        neveninst = neven(i);
        meveninst = meven(i);
        noddinst = ninst - neveninst;
        if -N/2 <= noddinst && noddinst < N/2
            moddinsts = [minst - meveninst minst + meveninst  meveninst - minst];
            for j = 1:3
                moddinst = moddinsts(j);
                if moddinst <= N && moddinst >= 1
                    res((i-1)*3+j,1) = noddinst;
                    res((i-1)*3+j,2) = moddinst;
                else
                    %rem = [(i-1)*3+j rem];
                    rem((i-1)*3+j) = 1;
                end
            end
        else
            %rem = [(i-1)*3+1 (i-1)*3+2 (i-1)*3+3 rem];
            rem((i-1)*3+1:(i-1)*3+3) = 1;
            %rem((i-1)*3+2) = 1;
            %rem((i-1)*3+3) = 1;
        end
    end
    %res(rem,:) = [];
    res(rem==1,:) = [];
end

