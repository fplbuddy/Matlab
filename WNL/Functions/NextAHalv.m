function A = NextAHalv(As,sigmas)
    sig = sign(sigmas);
    I = find(sig == 1); I = I(1);
    A = (As(I-1)+As(I))/2;
end

