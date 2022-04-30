function A = A2(n1, m1, n2, m2, type, G, minst)
kx1 = 2*pi*n1/G; kx2 = 2*pi*n2/G; ky1 = pi*m1; ky2 = pi*m2;
if round(m1) == round(minst + m2); ky1 = -ky1; end % Adding sign stuff, from y integral
if round(m2) == round(minst + m1); ky2 = -ky2; end
if type == 1
    A = (ky1*kx2-ky2*kx1)*(kx2^2+ky2^2);
elseif type == 2
    A = (ky2*kx1-ky1*kx2);
end
end

