function res = checkeenew2(ninst, minst, N,neven,meven)
    len = length(meven);
    res = [zeros(3*len,2) reshape(repelem(neven,3), 3*len,1) reshape(repelem(meven,3), 3*len,1)]; % maybe could trim this
    nmax = floor(N*sqrt(1/9-1/(4*N^2)));
    %mmax = floor(2*N/3);
    rem = zeros(3*N^2/2,1);
    for i=1:length(neven)
        neveninst = neven(i);
        meveninst = meven(i);
        n = ninst - neveninst;
        if abs(n) <= nmax
            minsts = [minst - meveninst minst + meveninst  meveninst - minst];
            for j = 1:3
                m = minsts(j);
                %if moddinst <= mmax && moddinst >= 1 % i think this error
                %has been fine before, as we have just removed the extra
                %modes with rem
                if n^2/N^2 + m^2/(4*N^2) < 1/9 && m >= 1 
                    res((i-1)*3+j,1) = n;
                    res((i-1)*3+j,2) = m;
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

