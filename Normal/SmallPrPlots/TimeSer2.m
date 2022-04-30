path = '/Volumes/Samsung_T5/AR_2/64x64/Pr_0_01/Ra_8_5e2';
figsave = '/Users/philipwinchester/Desktop/Figs/';
Ra = 8.5e2;
Pr = 0.01;
FS = 20;
kappa = sqrt((pi)^3/(Ra*Pr));
kpsmodes1 = importdata([path '/Checks/kpsmodes1.txt']);
ZeroOne = kpsmodes1(:,2); 
OneOneR = kpsmodes1(:,3); 
OneOneI = kpsmodes1(:,5); 
OneOne = (OneOneI.^2+OneOneR.^2).^(0.5);
t = kpsmodes1(:,1);
phase = zeros(1,length(OneOne));
ZeroOne = ZeroOne/kappa;
OneOne = OneOne/kappa;
t = t/(pi^2/kappa);
for j=1:length(OneOne)
    phase(j) = wrapTo2Pi(angle(OneOneR(j) + 1i*OneOneI(j)));
end
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(t,abs(OneOne), 'LineWidth', 1), hold on
plot(t,ZeroOne, 'LineWidth', 1)
%plot(t,phase, 'LineWidth', 2)
title(['$ Pr = 0.01, Ra = 2 \times 10^3$'],'FontSize',FS)
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
saveas(gcf,[figsave num2str(Ra) 'TimeSer.eps'], 'epsc')
