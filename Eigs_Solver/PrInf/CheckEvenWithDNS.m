path = '/Volumes/Samsung_T5/PrInf_even/AR_0_9/N_128x128/Ra_1e4';
modes = importdata([path '/Checks/kthetamodes2.txt']);
dpath = '/Volumes/Samsung_T5/OldData/PrInfData.mat';
load(dpath);
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions')

mode = modes(:,2);
t = modes(:,1);
figure()
semilogy(t, abs(mode-mode(end))), hold on
alpha = max(real(PrInfData.AR_0_9.N_128x128.Ra_1e4.sigmaeven));
x1 = 0.1;
x2 = 1;
y1 = 2e-1;
A = y1/exp(alpha*x1);
y2 = A*exp(alpha*x2);
plot([x1 x2], [y1 y2], 'k--')

figure()
hej = mode-mode(end);
t(hej == 0) = [];
hej(hej == 0) = [];
[f, P1] = GetSpectra(hej(200:end), t(200:end));
semilogy(f,P1,'r-o')