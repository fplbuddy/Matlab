function res = OWW(ninst,minst, n,m)
nmax = max(n);
mmax = max(m);
res = zeros(length(n)*4,4);
loc = 0;
for i=1:length(n)
    n1 = n(i);
    m1 = m(i);
    % making the options for the other one
    ns = unique([ninst + n1, ninst - n1, -ninst + n1]);
    ms = unique([minst + m1, minst - m1, -minst + m1]);
    options = zeros(length(ns)*length(ms),2);
    tot = 0;
    for j=1:length(ns)
        for k =1:length(ms)
            tot = tot + 1;
            options(tot,1) = ns(j); options(tot,2) = ms(k);
        end
    end
    % checking which ones are actually ok
    for j=1:length(options)
        n2 = options(j,1); m2 = options(j,2);
        if checkifadd(n1, m1, n2, m2, nmax,mmax)
            loc = loc + 1;
            res(loc,1) = n1; res(loc,2) = m1; res(loc,3) = n2; res(loc,4) = m2;
        end      
    end
end
res(loc+1:end,:) = [];
end

