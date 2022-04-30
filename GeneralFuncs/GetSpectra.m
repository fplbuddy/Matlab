function [f, P1] = GetSpectra(Signal, t)
L = length(Signal);
tdiff = diff(t);
T = mean(tdiff);
Fs = 1/T;
Y = fft(Signal);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
end