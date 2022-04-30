function pos = columnfindeven(N,ninst,minst)
    n = [(-N/2+1):2:(N/2-1) (-N/2):2:(N/2-1) ]; n = repmat(n, N/2);  n = n(1,:);
    m = 1:N; m = repelem(m, N/2); m = m(1,:);
    for i=1:length(n)
       ncheck = n(i); mcheck = m(i);
       if ninst == ncheck && minst == mcheck
           pos = i;
       end
    end
end

