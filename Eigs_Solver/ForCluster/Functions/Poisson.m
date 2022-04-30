function [v3, check] = Poisson(v1,v2,N,n,m,G,fast)
v3 = zeros(length(n),1);
positionMatrix = MakepositionMatrixEig(n,m);
nmax = max(n);
if not(fast)
    for i=1:length(n)
        n1 = n(i); m1 = m(i);
        for j=1:length(n)
            n2 = n(j); m2 = m(j);
            n3 = n1 + n2;
            if abs(n3) <= nmax
                Fact = v1(i)*v2(j)*(1i*pi^2/G);
                m31 = m1 - m2;
                if not(m31 == 0) && n3^2/N^2 + m31^2/(4*N^2) < 1/9
                    Fact1 = sign(m31)*(n1*m2+n2*m1); % If negative, we get a sign change
                    I1 = positionMatrix(abs(m31), n3 + 1 + nmax);
                    v3(I1) = v3(I1) + Fact*Fact1;
                end
                m32 = m1 + m2;
                if n3^2/N^2 + m32^2/(4*N^2) < 1/9
                    Fact2 = n1*m2-n2*m1;
                    I2 = positionMatrix(m32, n3 + 1 + nmax);
                    v3(I2) = v3(I2) + Fact*Fact2;
                end
            end
        end
    end
else % used if we have purely odd or even functions
    nums = 1:length(n);
    odd = abs(rem(n+m,2));
    even = not(odd);
    odd = nums.*odd;
    odd(odd == 0) = [];
    even = nums.*even;
    even(even == 0) = [];
    % checking if v1 is odd or even
    firstodd = rem(n(1)+m(1),2);
    if firstodd && v1(1) == 0
        list1 = even;
    elseif firstodd && v1(1) ~= 0
        list1 = odd;
    elseif not(firstodd) && v1(1) == 0
        list1 = odd;
    else
        list1 = even;
    end
    check = zeros(length(list1)*4,5); % dont think will need more than this
    I = 0;
    %
    if firstodd && v2(1) == 0
        list2 = even;
    elseif firstodd && v2(1) ~= 0
        list2 = odd;
    elseif not(firstodd) && v2(1) == 0
        list2 = odd;
    else
        list2 = even;
    end
    for ii=1:length(list1)
        ii
        i = list1(ii);
        n1 = n(i); m1 = m(i);
        for jj=1:length(list2)
            j = list2(jj);
            n2 = n(j); m2 = m(j);
            n3 = n1 + n2;
            if abs(n3) <= nmax
                Fact = v1(i)*v2(j)*(1i*pi^2/G);
                m31 = m1 - m2;
                if not(m31 == 0) && n3^2/N^2 + m31^2/(4*N^2) < 1/9
                    Fact1 = sign(m31)*(n1*m2+n2*m1); % If negative, we get a sign change
                    I1 = positionMatrix(abs(m31), n3 + 1 + nmax);
                    v3(I1) = v3(I1) + Fact*Fact1;
                    if abs(m31) == 1 && n3 == 0
                        I = I + 1;
                        check(I,1) = Fact*Fact1;
                        check(I,2) = n1;
                        check(I,3) = m1;
                        check(I,4) = n2;
                        check(I,5) = m2;
                    end
                end
                m32 = m1 + m2;
                if n3^2/N^2 + m32^2/(4*N^2) < 1/9
                    Fact2 = n1*m2-n2*m1;
                    I2 = positionMatrix(m32, n3 + 1 + nmax);
                    v3(I2) = v3(I2) + Fact*Fact2;
                    if abs(m32) == 1 && n3 == 0
                        I = I + 1;
                        check(I,1) = Fact*Fact2;
                        check(I,2) = n1;
                        check(I,3) = m1;
                        check(I,4) = n2;
                        check(I,5) = m2;
                    end
                end
            end
        end
    end
end
end

