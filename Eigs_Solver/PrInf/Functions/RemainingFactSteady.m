function RF = RemainingFactSteady(n,m,G)
kx = n*2*pi/G;
ky = m*pi;
KTwo = kx^2 + ky^2; KFour = KTwo^2;

RF = n*KFour^(-1);
end

