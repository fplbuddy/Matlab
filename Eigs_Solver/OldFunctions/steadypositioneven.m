function pos = steadypositioneven(N, ninst, minst)
    n = [1:2:(N/2-1) 0:2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:);
    m = 1:N; m = repelem(m, N/4);
    for i=1:length(n)
       ncheck = n(i); mcheck = m(i);
       if ninst == ncheck && minst == mcheck
           pos = i;
       end
    end
end
