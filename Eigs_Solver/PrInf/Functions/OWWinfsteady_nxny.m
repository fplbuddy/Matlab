function res = OWWinfsteady_nxny(ninst,minst, n,m,Nx,Ny)
% nmax = max(n);
% mmax = max(m);
res = zeros(length(n)*4,4);
loc = 0;
maxn = max(n);
% add c.c. to list 
zeroz = find(n == 0);
nwithoutzero = n; nwithoutzero(zeroz) = [];
mwithoutzero = m; mwithoutzero(zeroz) = [];
m = [m mwithoutzero];
n = [n -nwithoutzero];
for i=1:length(n)
    n1 = n(i);
    m1 = m(i);
    
    n2 = ninst - n1;
    if abs(n2) <= maxn
        m_list = [m1+minst abs(m1-minst)];
        for j=1:length(m_list)
            m2 = m_list(j);
            if checkifaddinf_nxny(n2, m2, Nx,Ny)
                loc = loc + 1;
                res(loc,1) = n1; res(loc,2) = m1; res(loc,3) = n2; res(loc,4) = m2;
                
            end
            
            
        end
        
    end
end
res(loc+1:end,:) = [];
%res = unique(res,'rows', 'stable');
end

