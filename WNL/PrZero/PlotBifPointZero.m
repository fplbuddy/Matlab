addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/PrZero/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/Functions')
load('/Volumes/Samsung_T5/OldData/WNLZero.mat')
run SetUp.m
%%
G_list = [2 1.9 1.8 1.7 1.6 1.5 1.4 1.3 1.2 1.1 1 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1];
for i=1:length(G_list)
    G = G_list(i);
    GS = GtoGS(G);
    As = WNLZero.(GS).As;
    sigmas = WNLZero.(GS).sigmas;
    Fs = WNLZero.(GS).Fs;
    [point, Astar, Bstar] = FindBifPointZero2(As,sigmas,imag(Fs));
    pint_list(i) = point;
end
figure('Renderer', 'painters', 'Position', [5 5 600 250])
plot(G_list,pint_list,'-o')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel("$1-\frac{A^* \lambda'(A^*)}{\lambda(A^*)}$",'FontSize',numFS)
xlabel("$\Gamma$",'FontSize',numFS)
xlim([0 1])