function check = checkifaddeenew2_nxny(n2, m2,Nx,Ny) %checkifadd(n1, m1, n2, m2, nmax,mmax)
check = n2^2/Nx^2 + m2^2/(4*Ny^2) <1/9 && n2 >=0 && m2>=1 && not(mod(n2+m2,2)); %&& not(n1 ==  n2 && m1 == m2);
end