Pr = 2.44e-2;
PrS = PrtoPrSZero(Pr);
D = GetFullMZero(PrZeroData, PrS);
figure
plot(D(1,:),D(2,:), '-o')
hold on