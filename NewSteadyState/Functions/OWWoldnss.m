function res = OWWoldnss(ninst,minst, n,m)
nmax = max(n);
mmax = max(m);
res = zeros(length(n)*4,4);
loc = 0;
for i=1:length(n)
    n1 = n(i);
    m1 = m(i);
    % making the options for the other one
    options = zeros(9,2);
    options(1,1) = ninst + n1; options(1,2) = minst + m1;
    options(2,1) = ninst - n1; options(2,2) = minst + m1;
    options(3,1) = -ninst + n1; options(3,2) = minst + m1;
    options(4,1) = ninst + n1; options(4,2) = minst - m1;
    options(5,1) = ninst - n1; options(5,2) = minst - m1;
    options(6,1) = -ninst + n1; options(6,2) = minst - m1;
    options(7,1) = ninst + n1; options(7,2) = -minst + m1;
    options(8,1) = ninst - n1; options(8,2) = -minst + m1;
    options(9,1) = -ninst + n1; options(9,2) = -minst + m1;
    % checking which ones are actually ok
    for j=1:9
        n2 = options(j,1); m2 = options(j,2);
        if checkifadd(n2, m2, nmax,mmax)%checkifadd(n1, m1, n2, m2, nmax,mmax)
            loc = loc + 1;
            res(loc,1) = n1; res(loc,2) = m1; res(loc,3) = n2; res(loc,4) = m2;
        end      
    end
end
res(loc+1:end,:) = [];
res = unique(res,'rows', 'stable');
end

