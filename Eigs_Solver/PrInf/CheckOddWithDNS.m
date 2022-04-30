path = '/Volumes/Samsung_T5/PrInf_odd/AR_2_6/N_128x128/Ra_1e5';
modes = importdata([path '/Checks/kthetamodes1.txt']);
dpath = '/Volumes/Samsung_T5/OldData/PrInfData.mat';
load(dpath);
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions')

mode = modes(:,2);
t = modes(:,1);
figure()
semilogy(t, abs(mode)), hold on
alpha = max(real(PrInfData.AR_2_6.N_128x128.Ra_1e5.sigmaodd));
x1 = 0.1;
x2 = 1;
y1 = 1e-6;
A = y1/exp(alpha*x1);
y2 = A*exp(alpha*x2);
plot([x1 x2], [y1 y2], 'k--')

figure()
hej = mode;
t(hej == 0) = [];
hej(hej == 0) = [];
[f, P1] = GetSpectra(hej(2500:3000), t(2500:3000));
semilogy(f,P1,'r-o')