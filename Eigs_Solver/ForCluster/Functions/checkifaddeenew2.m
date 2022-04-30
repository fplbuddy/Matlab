function check = checkifaddeenew2(n2, m2,N) %checkifadd(n1, m1, n2, m2, nmax,mmax)
check = n2^2/N^2 + m2^2/(4*N^2) <1/9 && n2 >=0 && m2>=1 && not(mod(n2+m2,2)); %&& not(n1 ==  n2 && m1 == m2);
end