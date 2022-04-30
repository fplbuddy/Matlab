function F = GetF(V,n,m,positionMatrix,N,G)
F = 0;
nmax = max(n);
for i=1:length(n)
    n1 = n(i); m1 = m(i);
    n2 = 1 - n1;
    m2_list = [m1-1  m1+1];
    for j=1:length(m2_list)
        m2 = m2_list(j);
        if m2 > 0 && n2^2/N^2 + m2^2/(4*N^2) <= 1/9
           pos1 = positionMatrix(m1, n1 + 1 + nmax); 
           pos2 = positionMatrix(m2, n2 + 1 + nmax); 
           psi1 = V(pos1);
           psi2 = V(pos2);        
           F = F + (1i*pi^2/G)*psi1*psi2*Square(n2,m2,G)*(m1*n2*h(m1,1,m2)-m2*n1*h(m2,1,m1)); 
           %F = F + (2/G)*(pi^2/G)*psi1*psi2*Square(n2,m2,G)*(m1*n2*h(m1,1,m2)-m2*n1*h(m2,1,m1));  % I think I missed the factor of 2/G before, see paper
        end       
    end
end 
end

