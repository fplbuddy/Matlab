function A = PreFact(n,m,G)
kx = 2*pi*n/G; ky = pi*m; 
A = 1i*kx/(kx^2+ky^2)^2;
end

