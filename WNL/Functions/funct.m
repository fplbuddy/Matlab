function F = funct(u2, u1,As, Fs)
    %if  u2 > -10
        F = -exp(u2*2)*interp1(As,Fs,u1);
    %else
     %   F = 0;
    %end
end