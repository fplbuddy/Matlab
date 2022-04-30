run SetUp.m
ARS = 'AR_0_5';
res = '32x32';
Pr = 1; PrS = PrtoPrS(Pr);
RaA = 1; RaAS = convertStringsToChars(RaAtoRaAS(RaA));
path = [path ARS '/' res '/' PrS '/' RaAS '/'];
kpsmodes1 = importdata([path 'Checks/kpsmodes1.txt']);
t = kpsmodes1(:,1);
signal = kpsmodes1(:,3);
% calcs
G = 0.5;
RaC = pi^4*(4+G^2)^3/(4*G^4);
Ra = RaC + RaA;
kappa = sqrt((pi)^3/(Ra*Pr));
signal = signal/kappa;
t = t/(pi^2/kappa);
% plot
figure()
semilogy(t,signal), hold on
alpha = 0.0028;
y1 = 1e-9; t1 = 1; A = y1/exp(alpha*t1);
t2 = 1000; y2 = A*exp(t2*alpha);
plot([t1 t2], [y1 y2])




