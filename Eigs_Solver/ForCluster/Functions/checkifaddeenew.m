function check = checkifaddeenew(n2, m2, nmax,mmax) %checkifadd(n1, m1, n2, m2, nmax,mmax)
check = m2 <= mmax && m2 >= 1 && n2 <= nmax && n2 >= 0 && not(mod(n2+m2,2)); %&& not(n1 ==  n2 && m1 == m2);
end

