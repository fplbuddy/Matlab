run SetUp.m
G = 1;
GS = GtoGS(G);
ARS = ['AR' GS(2:end)];
res = '32x16';
RaA = 1e-2; RaAS = convertStringsToChars(RaAtoRaAS(RaA)); RaAT = RatoRaT(RaA);
%
path = [path ARS '/' res '/' RaAS '/'];
kpsmodes1 = importdata([path 'Checks/kpsmodes1.txt']);
t = kpsmodes1(:,1);
ZeroOne = 2*abs(kpsmodes1(:,2));
OneOne = 2*sqrt(kpsmodes1(:,3).^2+kpsmodes1(:,5).^2);
%
figure('Renderer', 'painters', 'Position', [5 5 600 250])
semilogy(t, ZeroOne, 'r'), hold on
semilogy(t,abs(OneOne),'b')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t$ ', 'FontSize', LabelFS)
text(1.991e5,1,'$|\widehat \psi_{1,1}|$','FontSize',LabelFS, 'Color','b')
text(1.993e5,1,'$|\widehat \psi_{0,1}|$','FontSize',LabelFS, 'Color','r')
title(['$\Gamma =' num2str(G) '$, $Pr = 0$, $\delta Ra =' RaAT '$'], 'FontSize', LabelFS)
%xlim([1e5 1.02e5])
%set(gca, 'YScale', 'log')
%ylim([max(abs(OneOne-OneOne(1))/1.1) max(abs(OneOne-OneOne(1)))])
ylabel('$|\widehat \psi_{1,1} - A^*|$', 'FontSize',LabelFS)



%% some calcs
% to see what growth rate is for A
% G = 1, RaA = 1e-1;
% xlower = 9.063e4;
% xupper = 9.075e4;
% OneOnecalc = OneOne(xlower:xupper);
% tcalc = t(xlower:xupper);
% figure
% semilogy(tcalc,OneOnecalc)
% [alpha, ~, ~, ~, Rval] = Fitslogy(tcalc,OneOnecalc);
% xlower = 8.1e4;
% xupper = 8.9e4;
% OneOnecalc = OneOne(xlower:xupper);
% tcalc = t(xlower:xupper);
% figure
% semilogy(tcalc,OneOnecalc)
% [alpha, ~, ~, ~, Rval] = Fitslogy(tcalc,OneOnecalc);

%%% To see what growth rate is for B %%%
% kpsmodes3 = importdata([path 'Checks/kpsmodes3.txt']);
% kpsmodes2 = importdata([path 'Checks/kpsmodes2.txt']);
% ennd = min([length(kpsmodes2) length(kpsmodes1) length(kpsmodes3)]);
% 
% xlower = 1e5;
% ZeroOneCalc = ZeroOne(xlower:ennd);
% tCalc = t(xlower:ennd);
% TwoOne = 2*sqrt(kpsmodes1(:,4).^2+kpsmodes1(:,6).^2);
% TwoOneCalc = TwoOne(xlower:ennd);
% %
% OneTwo = 2*sqrt(kpsmodes2(:,3).^2+kpsmodes2(:,5).^2);
% OneTwoCalc = OneTwo(xlower:ennd);
% %
% ZeroThree = 2*kpsmodes3(:,2);
% ZeroThreeCalc = ZeroThree(xlower:ennd);
% TwoThree = 2*sqrt(kpsmodes3(:,4).^2+kpsmodes3(:,6).^2);
% TwoThreeCalc = TwoThree(xlower:ennd);
% % 
% B_list = zeros(length(TwoThreeCalc),1);
% eps = sqrt(RaA);
% for i=1:length(TwoThreeCalc)
%     B_list(i) = sqrt(ZeroOneCalc(i)^2+2*TwoOneCalc(i)^2+2*OneTwoCalc(i)^2+ZeroThreeCalc(i)^2+2*TwoThreeCalc(i)^2)/eps; % this is how B is defined. length of odd modes devided by eps.
% end
% derivB = diff(B_list)./diff(tCalc);
% sigma = derivB./B_list(1:end-1);
% OneOneCalc = OneOne(xlower:end);
% figure
% plot(OneOneCalc(1:end-1),sigma)
% derivZeroOne = diff(ZeroOneCalc)./diff(tCalc);
% figure
% plot(OneOneCalc/max(OneOneCalc),'-o'), hold on
% plot(derivZeroOne/max(derivZeroOne),'-o')
% figure
% plot(OneOneCalc(1:end-1),derivZeroOne,'-o')




