function SS = SignStuffSteady(n1,m1,n2,m2,minst)
SS = n1*m2*f(m2,minst,m1) - m1*n2*f(m1,minst,m2);
end

