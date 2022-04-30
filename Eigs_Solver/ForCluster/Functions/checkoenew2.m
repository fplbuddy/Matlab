function res = checkoenew2(ninst, minst, N,neven,meven)
    len = length(meven);
    res = [zeros(3*len,2) reshape(repelem(neven,3), 3*len,1) reshape(repelem(meven,3), 3*len,1)]; % maybe could trim this
    nmax = floor(N*sqrt(1/9-1/(4*N^2)));
    %mmax = floor(2*N/3);
    rem = zeros(3*N^2/2,1);
    for i=1:length(neven)
        neveninst = neven(i);
        meveninst = meven(i);
        noddinst = ninst - neveninst;
        if abs(noddinst) <= nmax
            moddinsts = [minst - meveninst minst + meveninst  meveninst - minst];
            for j = 1:3
                moddinst = moddinsts(j);
                %if moddinst <= mmax && moddinst >= 1 % i think this error
                %has been fine before, as we have just removed the extra
                %modes with rem
                if noddinst^2/N^2 + moddinst^2/(4*N^2) < 1/9 && moddinst >= 1 
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

